package is.hi.sdm.gutenberg;

import is.hi.sdm.gutenberg.WordCount.Map;
import is.hi.sdm.gutenberg.WordCount.Reduce;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import com.cotdp.hadoop.ZipFileInputFormat;

public class Main {
	public static void main(String[] args) throws Exception {
	    Configuration conf = new Configuration();
	        
	    Job job = new Job(conf, "gutenberg-preprocessor");
	    
	    job.setJarByClass(WordCount.class);
	    
	    job.setOutputKeyClass(Text.class);
	    job.setOutputValueClass(IntWritable.class);
	        
	    job.setMapperClass(WordCount.Map.class);
	    job.setReducerClass(WordCount.Reduce.class);
	        
	    job.setInputFormatClass(ZipFileInputFormat.class);
	    job.setOutputFormatClass(TextOutputFormat.class);
	        
	    //FileInputFormat.addInputPath(job, new Path(args[0]));
	    //FileOutputFormat.setOutputPath(job, new Path(args[1]));
	        
	    ZipFileInputFormat.setLenient( true );
	    ZipFileInputFormat.setInputPaths(job, new Path(args[0] + "/*.zip"));
	    TextOutputFormat.setOutputPath(job, new Path(args[1]));
	    
	    job.waitForCompletion(true);
	 }
}
