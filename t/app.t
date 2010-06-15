#!/usr/bin/env perl

BEGIN { $ENV{MOJO_MODE} = 'test' }

use strict;
use warnings;

use Test::More tests => 5;
use Test::Mojo;

use_ok('MojoliciousApps');
use_ok('MojoliciousApps::Command::Setup');
use_ok('MojoliciousApps::Command::Teardown');

MojoliciousApps::Command::Setup->new->run;

# Test
my $t = Test::Mojo->new(app => 'MojoliciousApps');

$t->get_ok('/')->status_is(200);

MojoliciousApps::Command::Teardown->new->run;
