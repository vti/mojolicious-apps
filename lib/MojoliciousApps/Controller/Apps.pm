package MojoliciousApps::Controller::Apps;

use strict;
use warnings;

use base 'MojoliciousApps::Controller';

sub list {
    my $self = shift;

    $self->pause;

    $self->couchdb->view_documents(
        default => all => sub {
            my ($couchdb, $documents, $error) = @_;

            return $self->render_exception if $error;

            $documents = [map { {id => $_->id, %{$_->params->{value}}} } @$documents];

            $self->stash(documents => $documents);

            return $self->finish;
        }
    );
}

sub view {
    my $self = shift;

    my $id = $self->param('id');

    $self->pause;

    $self->couchdb->load_document(
        $id => sub {
            my ($couchdb, $document, $error) = @_;

            return $self->render_exception if $error;

            return $self->render_not_found unless $document->rev;

            $self->stash(app => {id => $document->id, %{$document->params}});

            return $self->finish;
        }
    );
}

sub add {
    my $self = shift;

    # On GET render only the view
    return unless $self->req->method eq 'POST';

    my $validator = $self->validator;
    $validator->field('title')->required(1)->length(3, 30);
    $validator->field('description')->length(3, 255);

    my $ok = $validator->validate($self->req->params->to_hash);
    $self->stash(errors => $validator->errors), return unless $ok;

    # Pause transaction
    $self->pause;

    # Create new document object
    $self->couchdb->create_document(
        {params => $validator->values} => sub {
            my ($couchdb, $document, $error) = @_;

            # Render exception
            return $self->render_exception($error) if $error;

            # Redirect
            $self->redirect_to('view', id => $document->id);

            return $self->finish;
        }
    );
}

1;
