#!/usr/bin/env perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Mojo;

use_ok('MojoliciousApps');

# Test
my $t = Test::Mojo->new(app => 'MojoliciousApps');
$t->get_ok('/')->status_is(200)->content_type_is('text/html')
  ->content_like(qr/Mojolicious Web Framework/i);
