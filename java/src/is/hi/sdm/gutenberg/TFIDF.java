package is.hi.sdm.gutenberg;

import java.io.IOException;
import java.text.DecimalFormat;
import java.util.HashMap;

import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.Reducer.Context;

public class TFIDF {
	public static class Map extends Mapper<LongWritable, Text, Text, Text> {
	    /**
	     * @param key is the byte offset of the current line in the file;
	     * @param value is the line from the file
	     * @param output has the method "collect()" to output the key,value pair
	     * @param reporter allows us to retrieve some information about the job (like the current filename)
	     *
	     *     PRE-CONDITION: marcello@book.txt  \t  3/1500
	     *     POST-CONDITION: marcello, book.txt=3/1500
	     */
	    public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException {
	        String[] wordAndCounters = value.toString().split("\t");
	        String[] wordAndDoc = wordAndCounters[0].split("@");                 //3/1500
	        context.write(new Text(wordAndDoc[0]), new Text(wordAndDoc[1] + "=" + wordAndCounters[1]));
	    }
	}
	
	public static class Reduce extends Reducer<Text, Text, Text, Text> {
		 
		/**
		 * Threshold for values to be considered relevant. Any TF-IDF below this will
		 * not get emitted during reduce step.
		 */
		public static final double THRESHOLD = .00001;
		
	    private static final DecimalFormat DF = new DecimalFormat("###.########");
	    
	    /**
	     * @param key is the key of the mapper
	     * @param values are all the values aggregated during the mapping phase
	     * @param context contains the context of the job run
	     *
	     *             PRECONDITION: receive a list of <word, ["doc1=n1/N1", "doc2=n2/N2"]>
	     *             POSTCONDITION: <"word@doc1,  [d/D, n/N, TF-IDF]">
	     */
	    protected void reduce(Text key, Iterable<Text> values, Context context) throws IOException, InterruptedException {
	        // get the number of documents indirectly from the file-system (stored in the job name on purpose)
	        int numberOfDocumentsInCorpus = Integer.parseInt(context.getConfiguration().get("corpus"));
	        // total frequency of this word
	        int numberOfDocumentsInCorpusWhereKeyAppears = 0;
	        java.util.Map<String, String> tempFrequencies = new HashMap<String, String>();
	        for (Text val : values) {
	            String[] documentAndFrequencies = val.toString().split("=");
	            numberOfDocumentsInCorpusWhereKeyAppears++;
	            tempFrequencies.put(documentAndFrequencies[0], documentAndFrequencies[1]);
	        }
	        for (String document : tempFrequencies.keySet()) {
	            String[] wordFrequenceAndTotalWords = tempFrequencies.get(document).split("/");
	 
	            //Term frequency is the quocient of the number of terms in document and the total number of terms in doc
	            double tf = Double.valueOf(Double.valueOf(wordFrequenceAndTotalWords[0])
	                    / Double.valueOf(wordFrequenceAndTotalWords[1]));
	 
	            //interse document frequency quocient between the number of docs in corpus and number of docs the term appears
	            double idf = (double) numberOfDocumentsInCorpus / (double) numberOfDocumentsInCorpusWhereKeyAppears;
	 
	            //given that log(10) = 0, just consider the term frequency in documents
	            double tfIdf = numberOfDocumentsInCorpus == numberOfDocumentsInCorpusWhereKeyAppears ?
	                    tf : tf * Math.log10(idf);
	 
	            if (tfIdf >= THRESHOLD) {
	            	context.write(new Text(key + "@" + document), new Text(DF.format(tfIdf)));
	            }
	        }
	    }
	}
}
