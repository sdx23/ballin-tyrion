#!/bin/bash

while read line
do
    id=${line%%	*}
    echo "id $id"
	wget "http://www.gutenberg.org/files/$id/$id.zip"
done < subjects.dat
