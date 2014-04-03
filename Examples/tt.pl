#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Template; # This is required to use TemplateToolkit

binmode(STDOUT, ":utf8");          #treat as if it is UTF-8
binmode(STDIN, ":encoding(utf8)"); #actually check if it is UTF-8

my $tt = Template->new({
    INCLUDE_PATH => './Resources/views',
    START_TAG => quotemeta('{%'),
    END_TAG   => quotemeta('%}'),
    TRIM      => 1,
#    PRE_CHOMP  => 1,
#    POST_CHOMP => 1,
}) || die "$Template::ERROR\n";

my $vars = {
    'key' => 'toto',
    'title' => 'title',
    'authors' => [
        'Morel, Boris',
        'Zeiliger, Jérôme',
        'Foo, Bar',
        ],
};

print $tt->process('example.tt.bib', $vars)
    || die $tt->error(), "\n";
