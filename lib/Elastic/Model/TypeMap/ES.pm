package Elastic::Model::TypeMap::ES;
{
  $Elastic::Model::TypeMap::ES::VERSION = '0.06';
}

use strict;
use warnings;

use Elastic::Model::TypeMap::Base qw(:all);
use namespace::autoclean;

#===================================
has_type 'Elastic::Model::Types::UID',
#===================================
    deflate_via {
    sub {
        die "Cannot deflate UID as it not saved\n"
            unless $_[0]->from_store;
        $_[0]->read_params;
        }
    },

    inflate_via {
    sub {
        Elastic::Model::UID->new( from_store => 1, @{ $_[0] } );
        }
    },

    map_via {
    my %props = map {
        $_ => {
            type                         => 'string',
            index                        => 'not_analyzed',
            omit_norms                   => 1,
            omit_term_freq_and_positions => 1,
            index_name                   => "uid.${_}",
            }
    } qw(index type id routing);

    $props{routing}{index} = 'no';
    delete $props{routing}{index_name};

    return (
        type       => 'object',
        dynamic    => 'strict',
        properties => \%props,
        path       => 'just_name'
    );

    };

#===================================
has_type 'Elastic::Model::Types::Keyword',
#===================================
    map_via {
    type                         => 'string',
    index                        => 'not_analyzed',
    omit_norms                   => 1,
    omit_term_freq_and_positions => 1,
    };

#===================================
has_type 'Elastic::Model::Types::GeoPoint',
#===================================
    deflate_via {
    sub { $_[0] }
    },

    inflate_via {
    sub { $_[0] }
    },

    map_via { type => 'geo_point' };

#===================================
has_type 'Elastic::Model::Types::Binary',
#===================================
    deflate_via {
    require MIME::Base64;
    sub { MIME::Base64::encode_base64( $_[0] ) };

    },

    inflate_via {
    sub { MIME::Base64::decode_base64( $_[0] ) }
    },

    map_via { type => 'binary' };

#===================================
has_type 'Elastic::Model::Types::Timestamp',
#===================================
    deflate_via {
    sub { int( $_[0] * 1000 + 0.5 ) }
    },

    inflate_via {
    sub { sprintf "%.3f", $_[0] / 1000 }
    },

    map_via { type => 'date' };

1;

# ABSTRACT: Type maps for ElasticSearch-specific types


__END__
=pod

=head1 NAME

Elastic::Model::TypeMap::ES - Type maps for ElasticSearch-specific types

=head1 VERSION

version 0.06

=head1 DESCRIPTION

L<Elastic::Model::TypeMap::ES> provides mapping, inflation and deflation
for ElasticSearch specific types.

=head1 TYPES

=head2 Elastic::Model::Types::Keyword

Attributes of type L<Elastic::Model::Types/Keyword> are in/deflated
via L<Elastic::Model::TypeMap::Moose/Any> and are mapped as:

    {
        type                         => 'string',
        index                        => 'not_analyzed',
        omit_norms                   => 1,
        omit_term_freq_and_positions => 1,
    }

It is a suitable type to use for string attributes which should not
be analyzed, and will not be used for scoring. Rather they are suitable
to use as filters.

=head2 Elastic::Model::Types::UID

An L<Elastic::Model::UID> is deflated into a hash ref and reinflated
via L<Elastic::Model::UID/"new_from_store()">. It is mapped as:

    {
        type        => 'object',
        dynamic     => 'strict',
        path        => 'just_name',
        properties  => {
            index   => {
                type                         => 'string',
                index                        => 'not_analyzed',
                index_name                   => 'uid.index',
                omit_norms                   => 1,
                omit_term_freq_and_positions => 1,
            },
            type => {
                type                         => 'string',
                index                        => 'not_analyzed',
                index_name                   => 'uid.type',
                omit_norms                   => 1,
                omit_term_freq_and_positions => 1,
            },
            id   => {
                type                         => 'string',
                index                        => 'not_analyzed',
                index_name                   => 'uid.id',
                omit_norms                   => 1,
                omit_term_freq_and_positions => 1,
            },
            routing   => {
                type                         => 'string',
                index                        => 'no',
                omit_norms                   => 1,
                omit_term_freq_and_positions => 1,
            },
        }
    }

=head2 Elastic::Model::Types::GeoPoint

Attributes of type L<Elastic::Model::Types/"GeoPoint"> are mapped as
C<< { type => 'geo_point' } >>.

=head2 Elastic::Model::Types::Binary

Attributes of type L<Elastic::Model::Types/"Binary"> are deflated via
L<MIME::Base64/"encode_base64"> and inflated via L<MIME::Base64/"decode_base_64">.
They are mapped as C<< { type => 'binary' } >>.

=head2 Elastic::Model::Types::Timestamp

Attributes of type L<Elastic::Model::Types/"Timestamp"> are deflated
to epoch milliseconds, and inflated to epoch seconds (with floating-point
milliseconds). It is mapped as C<< { type => 'date' } >>.

=head1 AUTHOR

Clinton Gormley <drtech@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Clinton Gormley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

