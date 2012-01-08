package Mojolicious::Plugin::Subdispatch;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

has app => sub { die 'not registered!' };

sub _subdispatch {
    my ($self, $method, @url_args) = @_;

    # build url
    my $url = $self->app->url_for(@url_args);

    # build transaction
    my $tx = $self->app->build_tx;
    $tx->req->method(uc $method);
    $tx->req->url($url);

    # dispatch
    $self->app->handler($tx);

    return $tx;
}

# Mojo::UserAgent like interface
{
    no strict 'refs';
    for my $name (qw(DELETE GET HEAD POST PUT)) {
        *{__PACKAGE__ . '::' . lc($name)} = sub {
            my $self = shift;
            return $self->_subdispatch($name => @_);
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
