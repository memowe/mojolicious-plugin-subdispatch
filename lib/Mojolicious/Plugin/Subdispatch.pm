package Mojolicious::Plugin::Subdispatch;
use Mojo::Base 'Mojolicious::Plugin';

use Mojo::UserAgent::Transactor;

our $VERSION = '0.01';

has app         => sub { die 'not registered!' };
has transactor  => sub { Mojo::UserAgent::Transactor->new };

sub _subdispatch {
    my ($self, $method, @args) = @_;

    # extract post data
    my $post_data = (uc $method eq 'POST' and ref $args[-1] eq 'HASH') ?
        pop @args : undef;

    # build request url
    my $url = $self->app->url_for(@args);

    # build transaction
    my $tx = $post_data ?
        $self->transactor->form($url, $post_data)
        : $self->transactor->tx($method, $url);

    # dispatch
    $self->app->handler($tx);

    return $tx;
}

# Mojo::UserAgent like interface
# we don't really need post_form, but Mojo::UA uses it.
{
    no strict 'refs';
    for my $name (qw(DELETE GET HEAD POST POST_FORM PUT)) {
        *{__PACKAGE__ . '::' . lc($name)} = sub {
            my $self = shift;
            my $method = $name eq 'POST_FORM' ? 'POST' : $name;
            return $self->_subdispatch($method => @_)->res;
        };
    }
}

sub register {
    my ($self, $app) = @_;
    $self->app($app);

    # add subdispatch helper
    $app->helper(subdispatch => sub {
        my $s = shift;

        # Mojo::UserAgent like interface usage
        return $self unless @_;

        # direct subdispatch call
        return $self->_subdispatch(@_);
    });
}

1;
__END__
