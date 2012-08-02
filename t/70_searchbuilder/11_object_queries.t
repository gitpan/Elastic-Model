#!perl

use strict;
use warnings;

use Test::More;
use Test::Differences;
use Test::Exception;
use Elastic::Model::SearchBuilder;

use lib 't/lib';
our $es;
do 'es.pl';

use_ok 'MyApp' || print 'Bail out';

my $model = new_ok( 'MyApp', [ es => $es ], 'Model' );
ok $model->namespace('myapp')->index->create, 'Created index';
isa_ok my $domain = $model->domain('myapp'), 'Elastic::Model::Domain';

isa_ok
    my $user = $domain->new_doc( user => { id => 1, name => 'X' } ),
    'MyApp::User',
    'User';

isa_ok
    my $uid = $user->uid,
    'Elastic::Model::UID',
    'UID';

my @objs = ( $user, $uid );

my $a = Elastic::Model::SearchBuilder->new;

test_queries(
    'SCALAR',

    'Object', $user,
    {   bool => {
            must => [
                { term => { 'uid.index' => 'myapp' } },
                { term => { 'uid.type'  => 'user' } },
                { term => { 'uid.id'    => 1 } },
            ]
        }
    },

    'UID', $uid,
    {   bool => {
            must => [
                { term => { 'uid.index' => 'myapp' } },
                { term => { 'uid.type'  => 'user' } },
                { term => { 'uid.id'    => 1 } },
            ]
        }
    },
);

test_queries(
    'HASHREF - no key',
    'Object',
    { '' => $user },
    {   bool => {
            must => [
                { term => { 'uid.index' => 'myapp' } },
                { term => { 'uid.type'  => 'user' } },
                { term => { 'uid.id'    => 1 } },
            ]
        }
    },

    'UID',
    { '' => $uid },
    {   bool => {
            must => [
                { term => { 'uid.index' => 'myapp' } },
                { term => { 'uid.type'  => 'user' } },
                { term => { 'uid.id'    => 1 } },
            ]
        }
    },

);

test_queries(
    'HASHREF - key',
    'Object',
    { 'user' => $user },
    {   bool => {
            must => [
                { term => { 'user.uid.index' => 'myapp' } },
                { term => { 'user.uid.type'  => 'user' } },
                { term => { 'user.uid.id'    => 1 } },
            ]
        }
    },

    'UID',
    { 'user' => $uid },
    {   bool => {
            must => [
                { term => { 'user.uid.index' => 'myapp' } },
                { term => { 'user.uid.type'  => 'user' } },
                { term => { 'user.uid.id'    => 1 } },
            ]
        }
    },

);

test_queries(
    '= op', 'Object',
    { 'user' => { '=' => $user } },
    {   bool => {
            must => [
                { term => { 'user.uid.index' => 'myapp' } },
                { term => { 'user.uid.type'  => 'user' } },
                { term => { 'user.uid.id'    => 1 } },
            ]
        }
    },

    'UID',
    { 'user' => { '=' => $uid } },
    {   bool => {
            must => [
                { term => { 'user.uid.index' => 'myapp' } },
                { term => { 'user.uid.type'  => 'user' } },
                { term => { 'user.uid.id'    => 1 } },
            ]
        }
    },

);

test_queries(
    '!= op', 'Object',
    { 'user' => { '!=' => $user } },
    {   bool => {
            must_not => [ {
                    bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                }
            ]
        }
    },
    'UID',
    { 'user' => { '!=' => $uid } },
    {   bool => {
            must_not => [ {
                    bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                }
            ]
        }
    },
);

test_queries(
    'ARRAYREF',
    'Objects',
    { 'user' => \@objs },
    {   bool => {
            should => [ {
                    bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
                {   bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
            ]
        }
    },

    '= Objects',
    { 'user' => { '=' => \@objs } },
    {   bool => {
            should => [ {
                    bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
                {   bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
            ]
        }
    },
    '!= Objects',
    { 'user' => { '!=' => \@objs } },
    {   bool => {
            must_not => [ {
                    bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
                {   bool => {
                        must => [
                            { term => { 'user.uid.index' => 'myapp' } },
                            { term => { 'user.uid.type'  => 'user' } },
                            { term => { 'user.uid.id'    => 1 } },
                        ]
                    }
                },
            ]
        }
    }

);

done_testing();

#===================================
sub test_queries {
#===================================
    note "\n" . shift();
    while (@_) {
        my $name = shift;
        my $in   = shift;
        my $out  = shift;
        if ( ref $out eq 'Regexp' ) {
            throws_ok { $a->query($in) } $out, $name;
        }
        else {
            eval {
                eq_or_diff scalar $a->query($in), { query => $out }, $name;
                1;
            }
                or die "*** FAILED TEST $name:***\n$@";
        }
    }
}
