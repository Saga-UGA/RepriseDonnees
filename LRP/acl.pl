#!/usr/bin/perl
# LRP

use strict;
my $compt = 0;
my $authors = "";
my $title = "";

open (REFS, "<$ARGV[0]") or die("open: $!");

 while (<REFS>){
   if (/@/)  { 
     $compt+=1; 
     print "\@article{_ref$compt,\n";
     $authors = <REFS>;
     chomp($authors);
     print "\tauthor= {$authors},\n";
     $_ = <REFS>;
     chop;
     s/\.$//;
     print "\ttitle= {$_},\n";
     $_ = <REFS>;
     chop;
     s/\.$//;
     print "\tjournal = {$_},\n";
     print "}\n";
    }
 };
close REFS;

# while (<>){
#    $compt++;
#    s/^\n$//;
#    s/((\w+), \w+), /\@Article{$2_$compt ,\n author = {$1},\n/;
#    s/«(.+)»/title = {$1},\n/;
#    s/pp\. (.+)\./pages = {$1},\n/;
#    s/, ([1-2]\d\d\d),/\nyear = {$1},\n/;
#    s/$/}\n/;
#    print;
#};
