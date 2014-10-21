package Elastic::Model::TypeMap::Moose;
{
  $Elastic::Model::TypeMap::Moose::VERSION = '0.14';
}

use strict;
use warnings;

use Elastic::Model::TypeMap::Base qw(:all);
use namespace::autoclean;

#===================================
has_type 'Any',
#===================================
    deflate_via { \&_pass_through },
    inflate_via { \&_pass_through },
    map_via { type => 'object', enabled => 0 };

#===================================
has_type 'Undef',
#===================================
    map_via { type => 'string', index => 'not_analyzed' };

#===================================
has_type 'Bool',
#===================================
    map_via { type => 'boolean', null_value => 0 };

#===================================
has_type 'Str',
#===================================
    map_via { type => 'string' };

#===================================
has_type 'Num',
#===================================
    map_via { type => 'float' };

#===================================
has_type 'Int',
#===================================
    map_via { type => 'long' };

#===================================
has_type 'ScalarRef',
#===================================
    deflate_via {
    sub { ${ $_[0] } }
    },

    inflate_via {
    sub { \$_[0] }
    },

    map_via { _content_handler( 'mapper', @_ ) };

#===================================
has_type 'CodeRef',
#===================================
    deflate_via {undef}, inflate_via {undef};

#===================================
has_type 'GlobRef',
#===================================
    deflate_via {undef}, inflate_via {undef};

#===================================
has_type 'FileHandle',
#===================================
    deflate_via {undef}, inflate_via {undef};

#===================================
has_type 'RegexpRef',
#===================================
    deflate_via {undef},
    inflate_via {undef},
    map_via { type => 'string', index => 'no' };

#===================================
has_type 'ArrayRef',
#===================================
    deflate_via { _flate_array( 'deflator', @_ ) },
    inflate_via { _flate_array( 'inflator', @_ ) },
    map_via { _content_handler( 'mapper', @_ ) };

#===================================
has_type 'HashRef',
#===================================
    deflate_via { _flate_hash( 'deflator', @_ ) },
    inflate_via { _flate_hash( 'inflator', @_ ) },
    map_via { type => 'object', enabled => 0 };

#===================================
has_type 'Maybe',
#===================================
    deflate_via { _flate_maybe( 'deflator', @_ ) },
    inflate_via { _flate_maybe( 'inflator', @_ ) },
    map_via { _content_handler( 'mapper', @_ ) };

#===================================
has_type 'Moose::Meta::TypeConstraint::Enum',
#===================================
    deflate_via { \&_pass_through },    #
    inflate_via { \&_pass_through },
    map_via {
    type                         => 'string',
    index                        => 'not_analyzed',
    omit_norms                   => 1,
    omit_term_freq_and_positions => 1
    };

#===================================
has_type 'Moose::Meta::TypeConstraint::Union',
#===================================
    deflate_via {undef},
    inflate_via {undef},
    map_via { type => 'object', enabled => 0 };

#===================================
has_type 'MooseX::Types::TypeDecorator',
#===================================
    deflate_via { _decorated( 'deflator', @_ ) },
    inflate_via { _decorated( 'inflator', @_ ) },
    map_via { _decorated( 'mapper', @_ ) };

#===================================
has_type 'Moose::Meta::TypeConstraint::Parameterized',
#===================================
    deflate_via { _parameterized( 'deflator', @_ ) },
    inflate_via { _parameterized( 'inflator', @_ ) },
    map_via { _parameterized( 'mapper', @_ ) };

#===================================
sub _pass_through { $_[0] }
#===================================

#===================================
sub _flate_array {
#===================================
    my $content = _content_handler(@_) or return;
    sub {
        [ map { $content->($_) } @{ shift() } ];
    };
}

#===================================
sub _flate_hash {
#===================================
    my $content = _content_handler(@_) or return;
    sub {
        my $hash = shift;
        +{ map { $_ => $content->( $hash->{$_} ) } keys %$hash };
    };
}

#===================================
sub _flate_maybe {
#===================================
    my $content = _content_handler(@_) or return;
    sub {
        return defined $_[0] ? $content->( $_[0] ) : undef;
    };
}

#===================================
sub _decorated {
#===================================
    my ( $type, $tc, $attr, $map ) = @_;
    $map->find( $type, $tc->__type_constraint, $attr );
}

#===================================
sub _parameterized {
#===================================
    my ( $type, $tc, $attr, $map ) = @_;
    my $types  = $type . 's';
    my $parent = $tc->parent;
    if ( my $handler = $map->$types->{ $parent->name } ) {
        return $handler->( $tc, $attr, $map );
    }
    $map->find( $type, $parent, $attr );
}

#===================================
sub _content_handler {
#===================================
    my ( $type, $tc, $attr, $map ) = @_;
    return $tc->can('type_parameter')
        ? $map->find( $type, $tc->type_parameter, $attr )
        : $type eq 'mapper' ? ( type => 'object', enabled => 0 )
        :                     \&_pass_through;
}

1;



=pod

=head1 NAME

Elastic::Model::TypeMap::Moose - Type maps for core Moose types

=head1 VERSION

version 0.14

=head1 DESCRIPTION

L<Elastic::Model::TypeMap::Moose> provides mapping, inflation and deflation
for the core L<Moose::Util::TypeConstraints> and L<MooseX::Type::Moose> types.
It is loaded automatically by L<Elastic::Model::TypeMap::Default>.

Definitions are inherited from parent type constraints, so a specific mapping
may be provided for L</Int> but the deflation and inflation is handled by
L</Any>.

=head1 TYPES

=head2 Any

No deflation or inflation is attempted - the value is passed unaltered. If it
is not a value that L<JSON::XS> can handle (eg a blessed value) then
deflation will fail.

It is mapped as: C<< { type => 'object', enabled => 0 } >>.

=head2 Item

Mapping and in/deflation via L</Any>.

=head2 Bool

In/deflation via L</Any>. It is mapped as:

    {
        type       => 'boolean',
        null_value => 0
    }

=head2 Maybe

An undef value is stored as a JSON C<null>. The mapping and in/deflation depend
on the content type, eg C<Maybe[Int]>.  A C<Maybe> without a content
type is mapped and in/deflated via L</Any>

=head2 Undef

Mapped as C<< { type => 'string', index => 'not_analyzed' } >>.
In/deflation via L</Any>.

=head2 Defined

Mapping and in/deflation via L</Any>.

=head2 Value

Mapping and in/deflation via L</Any>.

=head2 Str

Mapped as C<< { type => 'string' } >>. In/deflation via L</"Any">.

=head2 Enum

Values are passed through without inflation/deflation. Mapped as:

    {
        type                         => 'string',
        index                        => 'not_analyzed',
        omit_norms                   => 1,
        omit_term_freq_and_positions => 1
    }

=head2 Num

Mapped as C<< { type => 'float' } >>. In/deflation via L</Any>.

=head2 Int

Mapped as C<< { type => 'long' } >>. In/deflation via L</"Any">.

=head2 Ref

No delator, inflator or mapping provided.

=head2 ScalarRef

The scalar value is dereferenced on deflation, and converted back
to a scalar ref on inflation.  The mapping depends on the content type,
eg C<ScalarRef[Int]>.  A C<ScalarRef> without a content type is mapped
via L</Any>.

=head2 ArrayRef

An array ref is preserved on inflation/deflation. The mapping depends on the
content type, eg C<ArrayRef[Int]>.  An C<ArrayRef> without a content
type is mapped and in/deflated via L</Any>. For array refs with elements of
different types, see L<Elastic::Model::TypeMap::Structured/"Tuple">.

=head2 HashRef

A hash ref is preserved on inflation/deflation. It is not advisable to allow
arbitrary key names in indexed hashes, as you could end up generating many
(and conflicting) field mappings.  For this reason, HashRefs are mapped
as C<< { type => 'object', enabled => 0 } >>. In/deflation depends on the
content type (eg C<HashRef[Int>]). A C<HashRef> without a content type
is in/deflated via L</Any>.

If you need a hashref which is indexed, then rather use either an object or
L<Elastic::Model::TypeMap::Structure/"Dict">.

=head2 Ref

No delator, inflator or mapping provided.

=head2 RegexpRef

No delator or inflator is provided. It is mapped as:
C<< { type => 'string', index => 'no' } >>.

=head2 GlobRef

No delator, inflator or mapping provided.

=head2 FileHandle

No delator, inflator or mapping provided.

=head1 AUTHOR

Clinton Gormley <drtech@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Clinton Gormley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

# ABSTRACT: Type maps for core Moose types

