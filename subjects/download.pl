#!/usr/bin/perl

use strict;
use warnings;

my $sf = "subjects.dat";
my $dlf = "download.log";

my @ss = qw(History Poetry Fiction Drama Biology Music);

my $fh;
my $dllog;
open($dllog, '>', $dlf);
my $id = '';
my $count = 0;
my $maxcount = 100;

foreach my $ccat (@ss){
	open($fh, '<', $sf);
	while(<$fh>){
		my($id,$subjects) = split('\t', $_);
	
		my $mcat = '';
		$mcat = $ccat if($subjects =~ m/$ccat/i);
	
		next if $mcat eq '';
	
		print "$id $mcat\n";
		#http://www.mirrorservice.org/sites/ftp.ibiblio.org/pub/docs/books/gutenberg/2/6/3/8/26388/26388.zip
		my $dlid = 'http://www.mirrorservice.org/sites/ftp.ibiblio.org/pub/docs/books/gutenberg/'
			.substr($id,0,1).'/'
			.substr($id,1,1).'/'
			.substr($id,2,1).'/';
		$dlid .= substr($id,3,1).'/' if $id > 9999;
		$dlid .= "$id/$id.zip";
		my $err = system("wget $dlid");
	
		#sleep(1);
	
		next if $err;
		print "success!\n\n";
		$count++;
		last if $count > $maxcount;
		print $dllog "$id $mcat\n";
	}
	close($fh);
	$count = 0;
}

close($dllog);
