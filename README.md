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
	and/or 
	use k-means/som to find clusters and check whether they fit the existing subjects

The first two steps are the data-aquiration and may be done together - getting
only books on a few subjects seems sensible.

The actual processing splits up into two steps, which can be done independently
of each other. Especially after computing the tf-idf one may store the thus
generated feature-vector for later use.
For both of the steps using map-reduce is sensible, considering the amount of
data.



