package MojoliciousApps::Controller;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub couchdb { shift->helper('couchdb') }

1;
