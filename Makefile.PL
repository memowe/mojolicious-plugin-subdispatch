use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'Mojolicious::Plugin::Subdispatch',
    VERSION_FROM    => 'lib/Mojolicious/Plugin/Subdispatch.pm',
    AUTHOR          => 'Mirko Westermeier <mail@memowe.de>',
    PREREQ_PM       => {'Mojolicious' => '4.0'},
    META_MERGE      => {
        resources => {
            repository => 'https://github.com/memowe/mojolicious-plugin-subdispatch',
        },
    },
    test            => {TESTS => 't/*.t'}
);
