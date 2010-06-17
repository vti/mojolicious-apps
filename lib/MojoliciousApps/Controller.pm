package MojoliciousApps::Controller;

use strict;
use warnings;

use base 'Mojolicious::Controller';

sub couchdb { shift->app->couchdb }

sub validator { shift->helper(validator => @_) }

sub is_admin {shift->session->{admin}}

sub render_forbidden { shift->render('forbidden', status => 403) }

sub render_not_found {
    my $self = shift;

    $self->SUPER::render_not_found;

    $self->finish;
}

1;
