#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 37;
use Mojolicious::Lite;
use Mojo::DOM;
use FindBin '$Bin';
use lib "$Bin/../lib";

# silence!
app->log->level('warn');

# plugin loads
use_ok('Mojolicious::Plugin::Subdispatch');

plugin 'Subdispatch';

any '/x/:thing/y' => sub {
    my $self = shift;
    $self->stash(method => $self->req->method)
} => 'acshun';

# PUT /x/foo/y (subdispatch)
my $tx = app->subdispatch(PUT => 'acshun', thing => 'foo');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'PUT', 'right method');
is($tx->req->url->path, '/x/foo/y', 'right url');
is($tx->res->code, 200, 'right response status');
my $resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is PUT/foo!', 'right headline');

# DELETE /x/bar/y (delete)
$tx = app->subdispatch->delete('acshun', thing => 'bar');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'DELETE', 'right method');
is($tx->req->url->path, '/x/bar/y', 'right url');
is($tx->res->code, 200, 'right response status');
$resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is DELETE/bar!', 'right headline');

# GET /x/baz/y (get)
$tx = app->subdispatch->get('acshun', thing => 'baz');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'GET', 'right method');
is($tx->req->url->path, '/x/baz/y', 'right url');
is($tx->res->code, 200, 'right response status');
$resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is GET/baz!', 'right headline');

# HEAD /x/quux/y (head)
$tx = app->subdispatch->head('acshun', thing => 'quux');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'HEAD', 'right method');
is($tx->req->url->path, '/x/quux/y', 'right url');
is($tx->res->code, 200, 'right response status');
$resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is HEAD/quux!', 'right headline');

# POST /x/om/y (post)
$tx = app->subdispatch->post('acshun', thing => 'om');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'POST', 'right method');
is($tx->req->url->path, '/x/om/y', 'right url');
is($tx->res->code, 200, 'right response status');
$resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is POST/om!', 'right headline');

# PUT /x/nom/y (put)
$tx = app->subdispatch->put('acshun', thing => 'nom');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');
is($tx->req->method, 'PUT', 'right method');
is($tx->req->url->path, '/x/nom/y', 'right url');
is($tx->res->code, 200, 'right response status');
$resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'This is PUT/nom!', 'right headline');

__DATA__

@@ acshun.html.ep
% layout 'wrap';
<h1>This is <%= "$method/$thing" %>!</h1>

@@ layouts/wrap.html.ep
<!doctype html>
<html><head><title>yum</title></head><body><%= content %></body></html>
