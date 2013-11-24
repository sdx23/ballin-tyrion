
.PHONY:  download catalog
catalog: subjects.dat

download: subjects.dat 
	./download.sh

subjects.dat: catalog.rdf
	perl parse.pl > subjects.dat

catalog.rdf.bz2:
	wget http://gutenberg.readingroo.ms/cache/generated/feeds/catalog.rdf.bz2

catalog.rdf: catalog.rdf.bz2
	bunzip2 catalog.rdf.bz2
