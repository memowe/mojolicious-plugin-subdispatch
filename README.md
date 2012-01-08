Mojolicious::Plugin::Subdispatch
================================

This plugin creates a `subdispatch` helper, which helps you creating  a request
for your actions, and returns a transaction including the response object with
your fully rendered HTML content. It takes the same arguments as `url_for`.

    plugin 'Subdispatch';

    [web app stuff...]

    my $html = app->subdispatch(GET => 'route_name', foo => 'bar')->res->body;

This is an early version and may change without warning. I'll use it to create
static HTML pages from a Mojolicious blog, but if you find another good way
to use it, please let me know!

Author
------

(c) Mirko Westermeier, <mail@memowe.de>

Licensed under the same terms as Perl itself.
