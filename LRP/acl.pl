#!/usr/bin/perl
# Conversion BibTex pour les données du LRP

use strict;
use warnings;
use utf8;
use Data::Dumper;

binmode(STDOUT, ":utf8");          #treat as if it is UTF-8
binmode(STDIN, ":encoding(utf8)"); #actually check if it is UTF-8

use Template;

my $tt = Template->new({
                        INCLUDE_PATH => '../Resources/views',
                        START_TAG => quotemeta('{%'),
                        END_TAG   => quotemeta('%}'),
                        TRIM      => 1,
                        ENCODING     => 'utf8',
                       }) || die "Template::ERROR\n";


my $file = $ARGV[0];
my $data = slurp($file);

foreach (oneByOne($data)) {
  my $vars = extract($_);
  print $tt->process('acl.tt.bib', $vars, undef, {binmode => ':utf8'})
    || die $tt->error(), "\n";
}


sub slurp {
  my $file = shift;

  open my $fh, "<", $file
    || die;

  local $/ = undef;

  my $entireFile = <$fh>;

  $entireFile =~ s/^\n+$//mg;

  close $fh;
  return $entireFile;
}

sub oneByOne {
  my $data = shift;

  my @res = $data =~ m/^ACL[\d]{2}\.[^\n]+\n(.*?)ACL[\d]{2}\.[^\n]+\n/msg;

  return @res;
}

sub extract {
  my $ref = shift;
  $ref =~ s/^\n+//mg;

  my @lines = split /^/, $ref;
  
  my $hash = {
              'key' => calcKey(splitAuthors($lines[0]), $lines[1]),
              'authors' => splitAuthors($lines[0]),
              'title' => trim($lines[1]),
              'journal' => getJournal($lines[2]),
              'volume' => getVolume($lines[2]),
              'pages' => getPages($lines[2]),
              'date' => getDate($lines[2]),
              'rest' => $lines[2],
             };


  return $hash;
}

sub calcKey {
  my($authors, $title) = @_;

  return sprintf('__a__:%s__t__:%s', $authors->[0]{'lastname'}, wrap($title, 10));
}

sub splitAuthors {
  my $unformatted = shift;
  my $formatted = [];

  my @authors = split /,/, $unformatted;
  foreach (@authors) {
    my @format = split /\s/, trim($_);

    push @$formatted, {'lastname' => $format[1], 'givenname' => $format[0]};
  }

  return $formatted;
}

sub getJournal {
  my $string = shift;

  return $1 if $string =~ m/^([^,]+),/i;
}

sub getVolume {
  my $string = shift;

  return $1 if $string =~ m/((?:volume|vol\.?)[^,]+),/i
}

sub getPages {
  my $string = shift;

  return $1 if $string =~ m/((?:pp\.?|pages|page)[^,]+),/i;
  return $1 if $string =~ m/([\d]+-[\d]+),/;
}

sub getDate{
  my $string = shift;

  return $1 if $string =~ m/^.*,\s*((?:1|2)[\d]{3})/i;
}

sub trim {
  my $str = shift;

  $str =~ s/^[^\w]+//;
  $str =~ s/[^\w]+$//;

  return $str;
}

sub wrap {
  my ($string, $length) = @_;

  $string =~ s/\W/_/g;

  return $1 if $string =~ m/(^.{$length})/
    || die;
}
