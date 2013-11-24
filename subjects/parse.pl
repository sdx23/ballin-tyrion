#!/usr/bin/perl

use strict;
use warnings;

my $cf = "catalog.rdf";

my $fh;
open($fh, '<', $cf);
my $id = '';
my $newid = '';
my $l = '';
my @ss;
while(<$fh>){
	if($_ =~ /pgterms:etext rdf:ID="etext(\d+)"/){
		$newid = $1;	

		if($id ne '' 
				&& $l eq 'en' 
				&& @ss != 0 
			){
			print "$id\t";
			print join(',', @ss);
			print "\n";
		}
		
		$id = $newid;
		@ss = ();
	}

	if($_ =~ m!<dc:language><dcterms:ISO639-2><rdf:value>(.+)</rdf:value></dcterms:ISO639-2></dc:language>!){
		$l = $1;	
	}
	if($_ =~ m!<rdf:li><dcterms:LCSH><rdf:value>(.+)</rdf:value></dcterms:LCSH></rdf:li>!){
			push(@ss, $1);
	}
}
close($fh);
