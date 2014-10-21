package Elastic::Model::Meta::Class::Doc;
{
  $Elastic::Model::Meta::Class::Doc::VERSION = '0.10';
}

use Moose::Role;

use MooseX::Types::Moose qw(Maybe HashRef);
use Carp;
use namespace::autoclean;
use Variable::Magic qw(cast wizard);

my $wiz = wizard( map { $_ => \&_inflate } qw(fetch store exists delete) );
my %exclude = map { $_ => 1 } qw(uid _can_inflate _source);

#===================================
has 'mapping' => (
#===================================
    isa     => HashRef,
    is      => 'rw',
    default => sub { {} }
);

#===================================
has 'unique_keys' => (
#===================================
    is      => 'ro',
    isa     => Maybe [HashRef],
    lazy    => 1,
    builder => '_build_unique_keys'
);

#===================================
sub new_stub {
#===================================
    my ( $self, $uid, $source ) = @_;

    my $obj = $self->get_meta_instance->create_instance;

    croak "Invalid UID"
        unless $uid && $uid->isa('Elastic::Model::UID') && $uid->from_store;

    $obj->_set_uid($uid);
    $obj->_set_source($source) if $source;
    $obj->_can_inflate(1);
    cast %$obj, $wiz;
    return $obj;
}

#===================================
sub _build_unique_keys {
#===================================
    my $self = shift;
    my %keys;
    my %key_names;
    for my $attr ( $self->get_all_attributes ) {
        next unless $attr->can('unique_key');
        my $key = $attr->unique_key;
        next unless defined $key and length $key;

        croak "Duplicate unique_key ($key) in class ("
            . $self->original_class . ')'
            if $key_names{$key}++;

        $keys{ $attr->name } = $key;
    }
    return %keys ? \%keys : undef;
}

#===================================
sub _inflate {
#===================================
    my ( $obj, undef, $key ) = @_;
    return if $exclude{ $key || '' };
    $obj->_inflate_doc if $obj->{_can_inflate};
}

1;



=pod

=head1 NAME

Elastic::Model::Meta::Class::Doc - A meta-class for Docs

=head1 VERSION

version 0.10

=head1 DESCRIPTION

Extends the meta-class for classes which do L<Elastic::Model::Role::Doc>.
You shouldn't need to use anything from this class directly.

=head1 ATTRIBUTES

=head2 mapping

    \%mapping = $meta->mapping($mapping);

Used to store custom mapping config for a class.  Use the
L<Elastic::Doc/"has_mapping">  sugar instead of calling this method directly.

=head1 unique_keys

    \%unique_keys = $meta->unique_keys

Returns a hashref whose keys are the attribute names, and whose values are
the value specified in L<Elastic::Manual::Attributes/unique_key>.  If there
are no unique keys, returns C<undef>.

=head1 METHODS

=head2 new_stub()

    $stub_doc = $meta->new_stub($uid);
    $stub_doc = $meta->new_stub($uid, $source);

Creates a stub instance of the class, which auto-inflates when any accessor
is called.  If the C<$source> param is defined, then it is used to inflate
the attributes of the instance, otherwise the attributes are fetched from
ElasticSearch when an attribute is accessed.

=head1 AUTHOR

Clinton Gormley <drtech@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Clinton Gormley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

# ABSTRACT: A meta-class for Docs

