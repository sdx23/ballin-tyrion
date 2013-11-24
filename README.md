ballin-tyrion
=============

Final project for statistical datamining course. 
Main goal: categorize texts via hadoop / map-reduce.

##Dataset

The data source of choice is retrieved from the
[gutenberg-project library](http://www.gutenberg.org/).
Available are thousands of books in a usable format, i.e. plain text, and
even subject tags for each book are available.

###Text corpuses

Text corpuses can be fetched directly from a mirror of the project, for example

	ftp://eremita.di.uminho.pt/pub/gutenberg/

Each book is located in it's own directory, where the directory number gives the
id of the book - always in subdirectories for each decimal place.
That is "ftp://eremita.di.uminho.pt/pub/gutenberg/6/9/4/6940/" is the directly
associated with book number 6940.

###Subject tags

The project provides catalog files containing metainformation, e.g. author,
title, book id, subjects among others.
The format of this is rdf / xml:

	<pgterms:etext rdf:ID="etext6940">
	  <dc:publisher>&pg;</dc:publisher>
	  <dc:title rdf:parseType="Literal">Old Mortality, Volume 2.</dc:title>
	  <dc:creator rdf:parseType="Literal">Scott, Walter, Sir, 1771-1832</dc:creator>
	  <pgterms:friendlytitle rdf:parseType="Literal">Old Mortality, Volume 2. by Sir Walter Scott</pgterms:friendlytitle>
	  <dc:language><dcterms:ISO639-2><rdf:value>en</rdf:value></dcterms:ISO639-2></dc:language>
	  <dc:subject>
	    <rdf:Bag>
	      <rdf:li><dcterms:LCSH><rdf:value>Scotland -- History -- 1660-1688 -- Fiction</rdf:value></dcterms:LCSH></rdf:li>
	      <rdf:li><dcterms:LCSH><rdf:value>War stories</rdf:value></dcterms:LCSH></rdf:li>
	      <rdf:li><dcterms:LCSH><rdf:value>Bothwell Bridge, Battle of, Scotland, 1679 -- Fiction</rdf:value></dcterms:LCSH></rdf:li>
	      <rdf:li><dcterms:LCSH><rdf:value>Historical fiction</rdf:value></dcterms:LCSH></rdf:li>
	    </rdf:Bag>
	  </dc:subject>
	  <dc:subject><dcterms:LCC><rdf:value>PR</rdf:value></dcterms:LCC></dc:subject>
	  <dc:created><dcterms:W3CDTF><rdf:value>2004-08-22</rdf:value></dcterms:W3CDTF></dc:created>
	  <pgterms:downloads><xsd:nonNegativeInteger><rdf:value>10</rdf:value></xsd:nonNegativeInteger></pgterms:downloads>
	  <dc:rights rdf:resource="&lic;" />
	</pgterms:etext>

##Processing

The data processing is done in different steps:
- downloading text corpuses and catalog
- cleaning: reordering files and parsing the catalog
- preprocessing: counting words, computing tf-idf
- categorization / data mining:
	use svm/knn/ann for categorization on a training set and mesure performance on test set
	*and/or* 
	use k-means/som to find clusters and check whether they fit the existing subjects

The first two steps are the data-aquiration and may be done together - getting
only books on a few subjects seems sensible.

The actual processing splits up into two steps, which can be done independently
of each other. Especially after computing the tf-idf one may store the thus
generated feature-vector for later use.
For both of the steps using map-reduce is sensible, considering the amount of
data.

###Data aquiration

tbd

general idea:
- parser for catalog: extract list of subjects
- wget all texts for a selection of subjects

###Preprocessing

Preprocessing means computing the tf-idf and storing it together as
feature-vector for the respective book id.

The tf-idf, term frequency–inverse document frequency, is defined as:

	tf-idf := tf * idf

	tf(t,d) := f(t,d)
	idf(t,D) := \log \frac{|D|}{\{d \in D : t \in d\}}

where

	t is a term
	d is a document
	D is the set of documents	
	f(t,d) is the number of times the term t occurs in document d
	
We conclude:
- tf(t,d) can be computed for each document separately (in a single map-reduce
  task handling all terms) and is quite straight forward
- idf(t,D) has to be computed for each term separately and we could possibly
  reuse the "counted words vector" for all documents from the tf step before
	- best try to get terms as keys, documents in which they appear as values 
	- reduce to number of documents 

- or even tuples (document, f(t,d)) as values, thus doing tf and idf in one step
	- this requires two reduces (kind of): 
		- reduce to the document number for idf
		- reduce to document and tf
	- complicates everything immensely

- ultimatively we may want to dismiss terms with low tf-idf values (for all
  documents) thus reducing the dimensionality of the feature space dismissing
  less relevant components (this is similar to PCA). On the other hand this may
  not be necessary. To be decided when finally working with a classifier.

Basic code setup
================

Software:

* Hadoop 0.20.2
* Ant to scp source over and compile on futuregrid

MapReduce steps:

1. Basic multifile word count. Emit out word -> count for each document
2. Go from word -> count to word -> tf/idf
3. Output per document tabbed data with word -> td/if
4. Merge together all separate files into table (rows = words, columns = document names, values = tf/idf)

See matrix multiplication for example of how to merge things together. Rest should be easy

Statistical analysis:

1. Read in CSV to R
2. Mathematical sorcery
3. Results
	
http://importantfish.com/one-step-matrix-multiplication-with-hadoop/

To merge outputs:

* hadoop fs -getmerge /output/dir/on/hdfs/ /desired/local/output/file.txt

Reading from zip files: 
http://cotdp.com/2011/03/reading-zip-files-from-hadoop-mapreduce/

TF-IDF in hadoop tutorial:
http://marcellodesales.wordpress.com/2009/12/31/tf-idf-in-hadoop-part-1-word-frequency-in-doc/

To build (Debian/Ubuntu-based systems)
--------------------------------------

clone this project.

Run `git submodule init` and then `git submodule update`. This downloads the Hadoop zip file reader.

`sudo apt-get install ant ivy` if you don't have them already.

Make sure Ivy is on the classpath (usually `export CLASSPATH=/usr/share/java/ivy.jar:$CLASSPATH`)

Run ant: `ant`

This will create a `dist/` directory that has the preprocessor jar inside it. It can then be SCPed to Futuregrid.
