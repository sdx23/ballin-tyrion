#!/bin/bash

downloaddir="$1"

while read line
do
	# get id and download the zip
    id=${line%%	*}
    echo "id $id"
	wget -P "$downloaddir" "http://www.gutenberg.org/files/$id/$id.zip"
	# check number of file inside
	nf=$( unzip -l ${downloaddir}$id.zip | tail -1 | awk '{ print $2 }' )
	[ $nf == 1 ] || rm -f ${downloaddir}$id.zip
done < subjects.dat
