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
	    
	    conf.set("corpus", "2"); //hardcoded test for now
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
	    
	    //first pass: get all document names
	    TreeMap<String, String> documents = new TreeMap<String, String>();
	    
	    Path csvInputpathHDFS = new Path(csvInputPath);
        
        BufferedReader br = new BufferedReader(new InputStreamReader(hdfs.open(csvInputpathHDFS)));
        String line;
        String previousDocument = "";
        
        while ((line = br.readLine()) != null) {
        	String wordAndDoc = line.split("\t")[0];
        	String doc = wordAndDoc.split("@")[1];
        	if (!previousDocument.equals(doc)) {
        		documents.put(doc, "");
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
        Set<String> keys = documents.keySet();
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
        	if (!word.equals(previousWord)) {
        		//we should now have a full map.
        		
    			String[] row = new String[numDocuments + 1];
    			row[0] = previousWord;
    			
        		c = 1;
        		
        		//create row and then reset.
        		for (String key : keys) {
        			row[c] = documents.get(key);
        			documents.put(key, "");
        			c++;
        		}
        		
        		writer.writeNext(row);
        	}
        	
        	//record the idf in the map for this current word.
        	documents.put(doc, idf);
        	previousWord = word;
        }
        
        br.close();
        writer.close();
		
		return true;
	}
	
	public static void main(String[] args) throws Exception {
	    Configuration conf = new Configuration();
		//inputPath = args[0] + "/*.zip";
	    //outputPath = args[1];
	    inputPath = "gbp-inputs/*.zip";
	    outputPath = "gbp-outputs";
	    tmp = "gbp-tmp";
	    
	    if (job1(conf)) {
	    	if (job2(conf)) {
	    		if (job3(conf)) {
	    			makeCSV(conf);
	    		}
	    	}
	    }
	 }
}
