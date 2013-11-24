package is.hi.sdm.gutenberg;

import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.StringTokenizer;

import org.apache.hadoop.io.BytesWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Reducer.Context;

public class DocumentTotalWordCount {
	public static class Map extends Mapper<LongWritable, Text, Text, Text> {
		private final static IntWritable one = new IntWritable(1);
	    private Text word = new Text();
	    
	    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
	    	//format is: word@document \t count
	    	String[] split = value.toString().split("\t");
	    	String[] wordAndDoc = split[0].split("@");
	    	
	    	String word = wordAndDoc[0];
	    	String doc = wordAndDoc[1];
	    	String count = split[1];
	    	
	    	context.write(new Text(doc), new Text(word + "=" + count));
		}
	 } 
        
	 public static class Reduce extends Reducer<Text, Text, Text, Text> {
	    public void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
	    	int sumOfWordsInDocument = 0;
	        java.util.Map<String, Integer> tempCounter = new HashMap<String, Integer>();
	        for (Text val : values) {
	            String[] wordCounter = val.toString().split("=");
	            tempCounter.put(wordCounter[0], Integer.valueOf(wordCounter[1]));
	            sumOfWordsInDocument += Integer.parseInt(val.toString().split("=")[1]);
	        }
	        for (String wordKey : tempCounter.keySet()) {
	            context.write(new Text(wordKey + "@" + key.toString()), new Text(tempCounter.get(wordKey) + "/"
	                    + sumOfWordsInDocument));
	        }
	    }
	 }
}
