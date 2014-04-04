#!/usr/bin/perl
# Conversion BibTex pour les données du LRP

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Template;

my $file = $ARGV[0];
my $data = slurp($file);

my $ref = oneByOne($data);
my $vars = extract($ref);

print Dumper $vars;

sub slurp {
  my $file = shift;

  open my $fh, "<", $file
    || die;

  local $/ = undef;

  my $entireFile = <$fh>;

  close $fh;
  return $entireFile;
}

sub oneByOne {
  my $data = shift;

  return $1 if $data =~ m/^\@\n([^\@]+)$/m;
}

sub extract {
  my $ref = shift;

  my @lines = split /^/, $ref;

  my $hash = {
              'authors' => splitAuthors($lines[0]),
              'title' => $lines[1],
              'journal' => getJournal($lines[2]),
             };


  return $hash;
}

sub splitAuthors {
  return 'a';
}

sub getJournal {
  return 'b';
}
