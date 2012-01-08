Mojolicious::Plugin::Subdispatch
================================

This plugin creates a `subdispatch` helper, which helps you creating a request
for your actions, and returns a transaction including the response object with
your fully rendered HTML content. The interface has some similarities to 
Mojo::UserAgent: just use your request method (DELETE, GET, HEAD, POST, PUT) as
the method name and pass the same arguments as you would do for `url_for`:

    plugin 'Subdispatch';

    [web app stuff...]

    my $html = app->subdispatch->get('route_name', foo => 'bar')->res->body;

This is an early version and may change without warning. I'll use it to create
static HTML pages from a Mojolicious blog, but if you find another good way
to use it, please let me know!

TODO
----

`post_form` with a POST data hash

Author
------

(c) Mirko Westermeier, <mail@memowe.de>

Licensed under the same terms as Perl itself.
