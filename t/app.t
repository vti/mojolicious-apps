#!/usr/bin/env perl

BEGIN { $ENV{MOJO_MODE} = 'test' }

use strict;
use warnings;

use Test::More tests => 24;
use Test::Mojo;

use_ok('MojoliciousApps');
use_ok('MojoliciousApps::Command::Setup');
use_ok('MojoliciousApps::Command::Teardown');

MojoliciousApps::Command::Setup->new->run;

my $client = Mojo::Client->singleton;
$client->ioloop(Mojo::IOLoop->singleton);

my $t = Test::Mojo->new(client => $client, app => 'MojoliciousApps');

$t->get_ok('/')->status_is(200);

$t->get_ok('/apps')->status_is(200);

$t->get_ok('/add')->status_is(403);

$t->get_ok('/logout')->status_is(404);

$t->get_ok('/login')->status_is(200);

$t->post_form_ok('/login' => {login => 'vti', password => 'vti'})->status_is(302);

$t->get_ok('/login')->status_is(404);

$t->post_form_ok('/add' => {title => 'foo', description => 'bar'})->status_is(302);

$t->get_ok('/')->status_is(200)->content_like(qr/foo/);

$t->get_ok('/logout')->status_is(302);

MojoliciousApps::Command::Teardown->new->run;
