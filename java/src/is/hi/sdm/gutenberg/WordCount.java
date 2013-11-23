package is.hi.sdm.gutenberg;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.conf.*;
import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.input.TextInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.apache.hadoop.mapreduce.lib.output.TextOutputFormat;

import com.cotdp.hadoop.ZipFileInputFormat;
        
public class WordCount {
        
 public static class Map extends Mapper<Text, BytesWritable, Text, IntWritable> {
    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();
    
    public void map( Text key, BytesWritable value, Context context ) throws IOException, InterruptedException {
		// NOTE: the filename is the *full* path within the ZIP file
		// e.g. "subdir1/subsubdir2/Ulysses-18.txt"
		String filename = key.toString();

		// We only want to process .txt files
		if (filename.endsWith(".txt") == false)
			return;

		// Prepare the content
		String content = new String(value.getBytes(), "UTF-8");
		//content = content.replaceAll("[^A-Za-z \n]", "").toLowerCase();

		// Tokenize the content
		StringTokenizer tokenizer = new StringTokenizer(content);
		while (tokenizer.hasMoreTokens()) {
			word.set(tokenizer.nextToken());
			context.write(word, one);
		}
	}
 } 
        
 public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {

    public void reduce(Text key, Iterable<IntWritable> values, Context context) 
      throws IOException, InterruptedException {
        int sum = 0;
        for (IntWritable val : values) {
            sum += val.get();
        }
        
        context.write(key, new IntWritable(sum));
    }
 }
        
 public static void main(String[] args) throws Exception {
    Configuration conf = new Configuration();
        
    Job job = new Job(conf, "gutenberg-preprocessor");
    
    job.setJarByClass(WordCount.class);
    
    job.setOutputKeyClass(Text.class);
    job.setOutputValueClass(IntWritable.class);
        
    job.setMapperClass(Map.class);
    job.setReducerClass(Reduce.class);
        
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