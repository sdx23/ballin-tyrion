package is.hi.sdm.gutenberg;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeMap;

import is.hi.sdm.gutenberg.WordCount.Map;
import is.hi.sdm.gutenberg.WordCount.Reduce;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FileUtil;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import au.com.bytecode.opencsv.CSVWriter;

import com.cotdp.hadoop.ZipFileInputFormat;

public class Main {
	/**
	 * Threshold for values to be considered relevant. Any TF-IDF below this will
	 * not get emitted during csv generation.
	 * - ignored if second parameter is given
	 */
	public static final double THRESHOLD = .00001;
	
	private static String inputPath;
	private static String outputPath;
	private static String tmp;
	
	private static boolean job1(Configuration conf) throws Exception {
	    Job job = new Job(conf, "gutenberg-preprocessor");
	    
	    job.setJarByClass(Main.class);
	    
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(IntWritable.class);
	        
	    job.setMapperClass(WordCount.Map.class);
	    job.setReducerClass(WordCount.Reduce.class);
	        
	    job.setInputFormatClass(ZipFileInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);
	        
	    //FileInputFormat.addInputPath(job, new Path(args[0]));
	    //FileOutputFormat.setOutputPath(job, new Path(args[1]));
	        
	    ZipFileInputFormat.setLenient( true );
	    ZipFileInputFormat.setInputPaths(job, new Path(inputPath));
	    TextOutputFormat.setOutputPath(job, new Path(tmp));
	    
	    return job.waitForCompletion(true);
	}
	
	private static boolean job2(Configuration conf) throws Exception {
	    //Merge all the results form job 1 so we can count number of words in each document.
	    String job2InputPath = tmp + "/merge/wordcount-merged";
	    FileSystem hdfs = FileSystem.get(conf);
	    FileUtil.copyMerge(hdfs, new Path(tmp), hdfs, new Path(job2InputPath), false, conf, null);
	    
	    //job 2: count up number of words in each document.
	    Job job = new Job(conf, "gutenberg-preprocessor-count");
	   
	    job.setJarByClass(Main.class);
	    
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(Text.class);
	    
	    job.setInputFormatClass(TextInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);
	    
	    job.setMapperClass(DocumentTotalWordCount.Map.class);
	    job.setReducerClass(DocumentTotalWordCount.Reduce.class);
	    
	    ZipFileInputFormat.setInputPaths(job, new Path(job2InputPath));
	    TextOutputFormat.setOutputPath(job, new Path(tmp + "/job2"));
	    
	    return job.waitForCompletion(true);
	}

	private static boolean job3(Configuration conf) throws Exception {
	    //Merge all the results from job2 so we can compute tf-idf
	    String job3InputPath = tmp + "/merge/job2-merged";
	    FileSystem hdfs = FileSystem.get(conf);
	    FileUtil.copyMerge(hdfs, new Path(tmp + "/job2"), hdfs, new Path(job3InputPath), false, conf, null);
	    
	    
	    //job 3: computeTF-IDF
	    Job job = new Job(conf, "gutenberg-preprocessor-tfidf");
	   
	    job.setJarByClass(Main.class);
	    
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(Text.class);
	    
	    job.setInputFormatClass(TextInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);
	    
	    job.setMapperClass(TFIDF.Map.class);
	    job.setReducerClass(TFIDF.Reduce.class);
	    
	    ZipFileInputFormat.setInputPaths(job, new Path(job3InputPath));
	    TextOutputFormat.setOutputPath(job, new Path(tmp + "/job3"));
	    
	    return job.waitForCompletion(true);
	}
	
	private static boolean makeCSV(Configuration conf) throws IOException {
		//merge all results from job 3 so we can create a csv file
	    String csvInputPath = tmp + "/merge/job3-merged";
	    FileSystem hdfs = FileSystem.get(conf);
	    FileUtil.copyMerge(hdfs, new Path(tmp + "/job3"), hdfs, new Path(csvInputPath), false, conf, null);
		double threshold = THRESHOLD;
		threshold = Double.parseDouble(conf.get("threshold"));
	    
	    //This map stores the document name and the current TF-IDF value for the given word.
	    //We can get away with this because the words are sorted alphabetically, so our 3rd dimension (word)
	    //Only needs to be stored as a string.
	    //0 is a default value in case a document is missing a TF-IDF value, which gets set in the first pass
	    //and on row resets.
	    TreeMap<String, String> documentAndIDF = new TreeMap<String, String>();
	    
	    //first pass: get all document names
	    Path csvInputpathHDFS = new Path(csvInputPath);
        
        BufferedReader br = new BufferedReader(new InputStreamReader(hdfs.open(csvInputpathHDFS)));
        String line;
        String previousDocument = "";
        
        while ((line = br.readLine()) != null) {
        	String wordAndDoc = line.split("\t")[0];
        	String doc = wordAndDoc.split("@")[1];
        	if (!previousDocument.equals(doc)) {
        		documentAndIDF.put(doc, "0");
        	}
        }
        
        br.close();
        
        //Second pass: create csv.
        FSDataOutputStream out = hdfs.create(new Path(outputPath + "/data.csv"));
        CSVWriter writer = new CSVWriter(new OutputStreamWriter(out));
        
        br = new BufferedReader(new InputStreamReader(hdfs.open(csvInputpathHDFS)));
        line = null;
        String previousWord = "";
        
        //first write the header (document names)
        Set<String> keys = documentAndIDF.keySet();
        int numDocuments = keys.size();
        String[] firstRow = new String[numDocuments + 1];
        
        firstRow[0] = "word";
        int c = 1;
        
        for (String key : keys) {
        	firstRow[c] = key;
        	c++;
        }
        
        writer.writeNext(firstRow);
        
        while ((line = br.readLine()) != null) {
        	String[] split = line.split("\t");
        	String doc = split[0].split("@")[1].trim();
        	String word = split[0].split("@")[0].trim();
        	String idf = split[1].trim();
        	
        	//every time we have a new word, we need to write the row and reset.
        	//ignore if prev word is "" because that is the first time, and we don't need a
        	//blank row.
        	if (!word.equals(previousWord) && !previousWord.equals("")) {
        		//we should now have a full map.
        		
    			String[] row = new String[numDocuments + 1];
    			row[0] = previousWord;
    			
        		c = 1;
        		
        		//create row and then reset. 
				int doc_count = 0;
        		boolean writeRow = false;
        		for (String key : keys) {
        			String stringValue = documentAndIDF.get(key);
        			double val = Double.parseDouble(stringValue);
        			
        			if (val >= threshold) {
        				writeRow = true;
        			}
        			if (val != 0) {
						doc_count++;
        			}
        			
        			row[c] = stringValue;
        			documentAndIDF.put(key, "0");
        			c++;
        		}
        		
        		if (writeRow && doc_count >= 5) writer.writeNext(row);
        	}
        	
        	//record the idf in the map for this current word.
        	documentAndIDF.put(doc, idf);
        	previousWord = word;
        }
        
        br.close();
        writer.close();
		
		return true;
	}
	
	public static void main(String[] args) throws Exception {
	    Configuration conf = new Configuration();
	    inputPath = "gbp-inputs/*.zip";
	    outputPath = "gbp-outputs";
	    tmp = "gbp-tmp";
	    
	    //Need to hard code number of documents
	    conf.set("corpus", args[0]);
	    conf.set("threshold", args[1]);
	    
	    if (job1(conf)) {
	    	if (job2(conf)) {
	    		if (job3(conf)) {
	    			makeCSV(conf);
	    		}
	    	}
	    }
	 }
}
