#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Template; # This is required to use TemplateToolkit

my $tt = Template->new({
    INCLUDE_PATH => './Resources/views/example.tt.bib',
    INTERPOLATE  => 1,
}) || die "$Template::ERROR\n";
