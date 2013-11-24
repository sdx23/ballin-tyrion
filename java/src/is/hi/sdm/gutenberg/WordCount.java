package is.hi.sdm.gutenberg;

import java.io.IOException;
import java.util.*;

import org.apache.hadoop.io.*;
import org.apache.hadoop.mapreduce.*;
        
public class WordCount {	
	public static class Map extends Mapper<Text, BytesWritable, Text, IntWritable> {
		private final static IntWritable one = new IntWritable(1);
	    private Text word = new Text();
	    
	    public void map( Text key, BytesWritable value, Context context ) throws IOException, InterruptedException {
			// NOTE: the filename is the *full* path within the ZIP file
			// e.g. "subdir1/subsubdir2/Ulysses-18.txt"
			String filename = key.toString();
	
			// We only want to process .txt files
			if (!filename.endsWith(".txt"))
				return;
	
			//strip txt extension
			if (filename.indexOf(".") > 0) {
				filename = filename.substring(0, filename.lastIndexOf("."));
			}
			
			// Prepare the content
			String content = new String(value.getBytes(), "UTF-8");
			content = content.replaceAll("[^A-Za-z \n]", "").toLowerCase();
	
			// Tokenize the content
			StringTokenizer tokenizer = new StringTokenizer(content);
			while (tokenizer.hasMoreTokens()) {
				String token = tokenizer.nextToken();
				
				if (StopWords.contains(token)) {
					continue;
				}
				
				word.set(token + "@" + filename);
				context.write(word, one);
			}
		}
	 } 
        
	 public static class Reduce extends Reducer<Text, IntWritable, Text, IntWritable> {
	    public void reduce(Text key, Iterable<IntWritable> values, Context context) throws IOException, InterruptedException {
	        int sum = 0;
	        for (IntWritable val : values) {
	            sum += val.get();
	        }
	        
	        context.write(key, new IntWritable(sum));
	    }
	 } 
}