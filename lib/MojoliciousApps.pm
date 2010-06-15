package MojoliciousApps;

use strict;
use warnings;

use base 'Mojolicious';

__PACKAGE__->attr('config');
__PACKAGE__->attr('config_file');

sub test_mode {
    my $self = shift;

    $self->log->path(undef);
    $self->config_file('mojolicious_apps.test.json');
}

sub production_mode {
    my $self = shift;

    $self->log->level('error');
    $self->config_file('mojolicious_apps.json');
}

# This method will run once at server start
sub startup {
    my $self = shift;

    # Read config
    my $config = $self->plugin(
        json_config => (
            file    => $self->config_file,
            default => {couchdb => {database => 'mojolicious_apps_dev'}}
        )
    );

    $self->log->path(undef);

    $self->config($config);

    # Default charset
    $self->plugin(charset => {charset => 'utf-8'});

    # CouchDB
    $self->plugin(couchdb => $config->{couchdb});

    # Register controller
    $self->controller_class('MojoliciousApps::Controller');

    # Routes
    my $r = $self->routes;

    # Default route
    $r->route('/')->to('apps#list')->name('root');
}

1;
