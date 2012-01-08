package Mojolicious::Plugin::Subdispatch;
use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.01';

# Beer. Now there’s a temporary solution.
sub register {
    my ($self, $app) = @_;

    # add subdispatch helper
    $app->helper(subdispatch => sub {
        my ($s, $method, $path, @args) = @_;

        # build url
        my $url = $app->url_for($path, @args);

        # build transaction
        my $tx = $app->build_tx;
        $tx->req->method(uc $method);
        $tx->req->url($url);

        # dispatch
        $app->handler($tx);

        return $tx;
    });
}

1;
__END__
