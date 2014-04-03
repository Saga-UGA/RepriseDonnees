#!/usr/bin/perl
# Conversion BibTex pour les données du LRP

use strict;
my $compt = 0;

open (REFS, "<$ARGV[0]") or die("open: $!");

 while (<REFS>){
   m/\@/ && do  { 
		$compt+=1; 
		print "\@article{_ref$compt,\n";
		
		$_ = <REFS>;
    	chop;
     	\&AUTHORS($_);
	 	
		$_ = <REFS>;
     	chop;
		\&TITLE($_);
     	
		$_ = <REFS>;
     	chop;
		\&JOURNAL($_);
     	
		print "}\n";
    }
 };
close REFS;

sub AUTHORS {
    my $authors = shift(@_);
    print "\tauthor= {$authors},\n";
}

sub TITLE {
    shift(@_);
	s/\.$//;
    print "\ttitle= {$_},\n";
}

sub JOURNAL {
    shift(@_);
	s/\.$//;
    if (s/^([^,]+),//)  { print "\tjournal = {$1},\n"; }  
    if (s/vol[^ ]+ (\d+),//i)  { print "\tvolume = {$1},\n"; }
 	if (s/pp[^\d]+([^,]+),//)  { print "\tpages = {$1},\n"; }
	if (s/([1-2]\d\d\d)$//)  { print "\tyear = {$1},\n"; }
	
	print "reste =$_\n";
    
}
