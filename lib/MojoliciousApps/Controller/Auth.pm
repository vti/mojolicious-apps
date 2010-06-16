package MojoliciousApps::Controller::Auth;

use strict;
use warnings;

use base 'MojoliciousApps::Controller';

sub check {
    my $self = shift;

    return 1 if $self->is_admin;

    $self->render_forbidden;

    return 0;
}

sub login {
    my $self = shift;

    return $self->render_not_found if $self->is_admin;

    return unless $self->req->method eq 'POST';

    my $validator = $self->validator;
    $validator->field('login')->required(1);
    $validator->field('password')->required(1);

    my $ok = $validator->validate($self->req->params->to_hash);
    $self->stash(errors => $validator->errors), return unless $ok;

    my $login    = $validator->values->{login};
    my $password = $validator->values->{password};

    my $config = $self->app->config->{admin};

    unless ($login eq $config->{login} && $password eq $config->{password}) {
        $self->stash(errors => {login => 'Wrong login'});
        return;
    }

    $self->session->{admin} = 1;

    return $self->redirect_to('root');
}

sub logout {
    my $self = shift;

    return $self->render_not_found unless $self->is_admin;

    delete $self->session->{admin};
    $self->session->{expires} = 0;

    return $self->redirect_to('root');
}

1;
