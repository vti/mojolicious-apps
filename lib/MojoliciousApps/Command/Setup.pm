package MojoliciousApps::Command::Setup;

use strict;
use warnings;

use base 'Mojo::Command';

use MojoliciousApps;

__PACKAGE__->attr(description => <<'EOF');
Setup application.
EOF
__PACKAGE__->attr(usage => <<"EOF");
usage: $0 setup
EOF

sub run {
    my $self   = shift;
    my $values = shift;

    my $app = MojoliciousApps->new;

    $app->couchdb->create_database(
        sub {
            my ($couchdb, $db, $error) = @_;

            warn $error if $error;
        }
    );

    return $self;
}

1;
