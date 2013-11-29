#Map-Reduce Code
The map-reduce code is done in order to get the data into a format that R can use for statistical analysis. We had to take an iterative approach in order to make the problem of computing the TF-IDF fit into a map-reduce framework. Each step builds on the previous one to eventually get to the output CSV file.


There are 4 steps in the data-preprocessing:
* Word count: the most basic map-reduce problem. It counts the word occurrences for each document in the input.
* Total word count: This step counts the total number of words in each document and outputs values that record the number of a single word in a single document, a slash, then the total number of words in that document.
* TF-IDF: Calculates the TF-IDF for each word, which is the statistic we want to analyze.


Each step also includes a merging sub-step between them. Hadoop can output multiple result files if the data is big enough, and we a single file for input to each step. We use Hadoop’s FileUtil.copyFileMerge method to merge the files together after each step. With our small testing data set this step is useless because it’s only merging one file into itself, but with a bigger data set it would become relevant.
Word Count (Job 1)
This is only slightly different than the regular word count example. First, we are reading zipped text files instead of flat text files in HDFS. A custom ZipFileInputFormat from a third party library automatically delivers the uncompressed files in the zip files to the Hadoop mapper. We also have a stop word dictionary to discard irrelevant English words such as “I” or “and” or “the”.


The structure of this job’s input (map):
* Key: The filename in the zip file, as a path relative to the zip file. e.g. “folder/myfolder/myfile.txt”
* Value: The bytes in the zip file that are the file.


The structure of this job’s output (reduce):
* Key: word@processedFileName, e.g. “acceptance@myfile”
* Value: The count of the word in the document.


The map function in this first step does some basic processing to discard information we don’t care about, such as the filename’s extension and preceding folder structure within the zip file. The files we are using are named by document ID, and are usually just a single txt file in a zip file. However, sometimes they have folder structures.
Document Word Count (Job 2)
This step receives the merged output from Job 1: Word Count as its input. The purpose of this job is to get the total number of words in each document, which is required to compute the TF-IDF.


The structure of this job’s input (map):
* Key: word@processedFileName, e.g. “acceptance@myFile”
* Value: The count of this word in the processed file.


The structure of this job’s output (reduce):
* Key: word@processedFileName
* Value: wordCount/totalWordCount, e.g. “3/48023”


The map function emits out a key-value structure of document name => word=count. This is so the reduce step can re-emit a key structure similar to job 1 but also acquire the total word count. Thus, each reduce call is per-document in the corpus. The reduce step keeps a HashMap to map words and their counts, and simultaneously adds up the total number of words in the document. Then it loops through the key set to emit the next finalized output structure for this step.


<<Picture of job2 code, also fix that code so it’s understandable>>
TF-IDF (Job 3)
Job 3 receives the mergd output of Job 2: Document word count as its input. The purpose of this job is to compute the final TF-IDF value, which is the statistic we want to analyze. 


The structure of this job’s input (map):
* Key: word@processedFileName
* Value: wordCount/totalWordCount, e.g. “3/48023”


The structure of this job’s output (reduce):
* Key: word@processedFileName
* Value: tf-idf, e.g. “.0000458”


The map splits the merged ouptut of job 3 and emits the word as a key, and “document=count/totalCount” as the value. This is basically a pivot of the format output from job 2, and allows us to reduce by word instead of document name, which gives us the magic sorted file for CSV generation. The TF-IDF value is computed using the standard formula:


<<Formula here>>


We considered using this reduce step for discarding TF-IDF values that don’t meet the threshold for interesting data. However, because the reduce step is isolated by word, we cannot determine if we want to discard a given word here. In order to discard a word, all of its TF-IDF values must be below the threshold. It’s likely we could do it in a fifth map-reduce step, by emitting out the word and a set of TF-IDF values, but we chose to do it in the csv generation step for simplicity.
CSV Generation (Job 4)
This final step produces the CSV, and is not actually a map-reduce job. It does use the Hadoop API to merge the job 3 output and read that in/write it out, but otherwise has no dependency on Hadoop. We tried to figure out a way to make this work in map-reduce, but the three data dimensions (word, document, TF-IDF) made it difficult to comprehend. We opted for a simple two-pass algorithm to generate the CSV:
* First pass: Gather only document names. This allows us to define the CSV columns
* Second pass: Read in lines and parse them to get TF-IDF values. We store the TF-IDF values in a map with the document as the key. When we detect a new word in the document, write out the CSV row and reset the map.


This algorithm is possible because of the way job 3 sorts its output. They are sorted alphabetically by word, and then by document name. Thus, the third data dimension can be stored in a single string.


The main limitation of this algorithm should be in the limitation of the running JVM’s implementation of HashMap. The map stores the document columns in memory simultaneously, and HashMap can store up to Integer.MAX_VALUE keys in it, according to the documentation. For the purposes of our project, the application should be able to handle entire English Project Gutenberg catalog. But for larger data set, i.e. “Big Data” scale, this could be a problem.

The other issue is time. The efficiency of this algorithm is O(2n), which is not ideal. Some more map-reduce steps could be implemented to reduce the overall data size that the CSV generator needs to process, but the efficiency of the algorithm will remain unchanged. Converting the CSV generation job to a map-reduce step is probably the best way to get around this, but the overhead of map-reduce may prove to be detrimental in the long run.
