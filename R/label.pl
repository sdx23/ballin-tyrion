#!/usr/bin/perl

use strict;
use warnings;

my $colstr = `head -n1 data.csv`;

my %cats;
open(my $fh, '<', 'download.log');
while(<$fh>){
	my ($id, $c) = split(' ', $_);
	$cats{$id} = $c;
}
close($fh);

my @cols = split(',', $colstr);
my $labels = 'cat';
foreach my $c (@cols) {
	if($c eq 'word'){
		$labels = 'cat';
		next;
	}

	$c =~ s/X\.*//;
	$c =~ s/"//g;
	print STDERR "problem with $c\n" unless($cats{$c});
	my $tc = $cats{$c};
	$tc = "Fiction" unless($cats{$c});
	$labels .= ','.$tc;
}

print "$labels\n";
