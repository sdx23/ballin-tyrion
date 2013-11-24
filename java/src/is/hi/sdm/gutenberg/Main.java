package is.hi.sdm.gutenberg;

import java.io.IOException;

import is.hi.sdm.gutenberg.WordCount.Map;
import is.hi.sdm.gutenberg.WordCount.Reduce;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.FileUtil;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import com.cotdp.hadoop.ZipFileInputFormat;

public class Main {
	private static String inputPath;
	private static String outputPath;
	private static String tmp;
	
	private static boolean job1(Configuration conf) throws Exception {
	    
	    String tmp = "gbp-tmp";
	    
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
	    String job2InputPath = tmp + "/job2/wordcount-merged";
	    FileSystem hdfs = FileSystem.get(conf);
	    FileUtil.copyMerge(hdfs, new Path(tmp), hdfs, new Path(job2InputPath), false, conf, null);
	    
	    //job 2: count up number of words in each document.
	    Job job = new Job(conf, "gutenberg-preprocessor-count");
	   
	    job.setJarByClass(Main.class);
	    
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(IntWritable.class);
	    
	    job.setInputFormatClass(TextInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);
	    
	    job.setMapperClass(DocumentTotalWordCount.Map.class);
	    job.setReducerClass(DocumentTotalWordCount.Reduce.class);
	    
	    ZipFileInputFormat.setInputPaths(job, new Path(job2InputPath));
	    TextOutputFormat.setOutputPath(job, new Path(tmp + "/job2"));
	    
	    return job.waitForCompletion(true);
	}
	
	
	public static void main(String[] args) throws Exception {
	    Configuration conf = new Configuration();
		inputPath = args[0] + "/*.zip";
	    outputPath = args[1];
	    tmp = "gbp-tmp";
	    
	    if (job1(conf)) {
	    	job2(conf);
	    }
	 }
}
