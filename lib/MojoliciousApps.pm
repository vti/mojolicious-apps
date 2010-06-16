package MojoliciousApps;

use strict;
use warnings;

use base 'Mojolicious';

__PACKAGE__->attr('config');
__PACKAGE__->attr('config_file');

use Mojo::JSON::Any;

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

            # Read configuration from the file depending on the current mode
            file => $self->config_file,

            # Default development configuration
            default => {
                couchdb => {database => 'mojolicious_apps_dev'},

                # Default admin credentials
                admin => {
                    login    => 'vti',
                    password => 'vti'
                  }
            }
        )
    );

    $self->log->path(undef);
    $self->log->level($config->{loglevel} || 'debug');

    $self->config($config);

    # Default charset
    $self->plugin(charset => {charset => 'utf-8'});

    # Validator
    $self->plugin('validator');

    # CouchDB
    $self->plugin(couchdb => $config->{couchdb});
    $self->couchdb->json_class('Mojo::JSON::Any');

    # Tags
    $self->plugin('tag_helpers');

    # Helpers
    $self->renderer->add_helper(
        error => sub {
            my $self = shift;
            my $name = shift;

            my $string = '';

            my $errors = $self->stash('errors');
            if (keys %$errors && $errors->{$name}) {
                $string =
                  qq|<div class="form-error-message">$errors->{$name}</div>|;
            }

            return Mojo::ByteStream->new($string);
        }
    );

    # Register controller
    $self->controller_class('MojoliciousApps::Controller');

    # Routes
    my $r = $self->routes;

    # Routes namespace
    $r->namespace('MojoliciousApps::Controller');

    # Root / Application list
    $r->route('/')->to('apps#list')->name('root');
    $r->route('/apps')->to('apps#list')->name('root');

    my $admin = $r->bridge->to('auth#check');

    # Add new application
    $admin->route('/add')->to('apps#add')->name('add');

    # View application
    $r->route('/apps/:id')->to('apps#view')->name('view');

    $r->route('/login')->to('auth#login')->name('login');
    $r->route('/logout')->to('auth#logout');
}

1;
