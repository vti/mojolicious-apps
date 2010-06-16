package MojoliciousApps::Command::Teardown;

use strict;
use warnings;

use base 'Mojo::Command';

use MojoliciousApps;

__PACKAGE__->attr(description => <<'EOF');
Teardown application.
EOF
__PACKAGE__->attr(usage => <<"EOF");
usage: $0 teardown
EOF

sub run {
    my $self   = shift;
    my $values = shift;

    my $app = MojoliciousApps->new;

    $app->couchdb->delete_database(
        sub {
            my ($couchdb, $error) = @_;

            warn $error if $error;

            Mojo::IOLoop->singleton->stop;
        }
    );

    Mojo::IOLoop->singleton->start;

    return $self;
}

1;
