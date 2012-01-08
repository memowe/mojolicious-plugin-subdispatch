#!/usr/bin/env perl

use strict;
use warnings;
use Test::More tests => 7;
use Mojolicious::Lite;
use Mojo::DOM;
use FindBin '$Bin';
use lib "$Bin/../lib";

# silence!
app->log->level('warn');

# plugin loads
use_ok('Mojolicious::Plugin::Subdispatch');

plugin 'Subdispatch';

get '/foo/:thing/baz' => sub {
    my $self = shift;
    $self->stash(yum => 'nom')
} => 'acshun';

# subdispatch '/foo/bar/baz'
my $tx = app->subdispatch(get => 'acshun', thing => 'bar');
isa_ok($tx, 'Mojo::Transaction', 'subdispatch return value');

# check request
is($tx->req->method, 'GET', 'right method');
is($tx->req->url->path, '/foo/bar/baz', 'right url');

# check response
is($tx->res->code, 200, 'right response status');
my $resd = Mojo::DOM->new($tx->res->body);
is($resd->at('title')->text, 'yum', 'right title');
is($resd->at('h1')->text, 'OM NOM NOM NOM!', 'right headline');

__DATA__

@@ acshun.html.ep
% layout 'wrap';
<h1>OM <%= uc join ' ' => ($yum) x 3 %>!</h1>

@@ layouts/wrap.html.ep
<!doctype html>
<html><head><title>yum</title></head><body><%= content %></body></html>
