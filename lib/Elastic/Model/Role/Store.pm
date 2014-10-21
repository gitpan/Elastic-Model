package Elastic::Model::Role::Store;
{
  $Elastic::Model::Role::Store::VERSION = '0.24';
}

use Moose::Role;

use Elastic::Model::Types qw(ES);
use namespace::autoclean;

#===================================
has 'es' => (
#===================================
    isa      => ES,
    is       => 'ro',
    required => 1,
);

#===================================
sub search          { shift->es->search(@_) }
sub scrolled_search { shift->es->scrolled_search(@_) }
sub delete_by_query { shift->es->delete_by_query(@_) }
#===================================

#===================================
sub get_doc {
#===================================
    my ( $self, $uid, %args ) = @_;
    return $self->es->get(
        fields => [qw(_routing _parent _source)],
        %{ $uid->read_params },
        %args,
    );
}

#===================================
sub doc_exists {
#===================================
    my ( $self, $uid, %args ) = @_;
    return !!$self->es->exists( %{ $uid->read_params }, %args, );
}

#===================================
sub create_doc { shift->_write_doc( 'create', @_ ) }
sub index_doc  { shift->_write_doc( 'index',  @_ ) }
#===================================

#===================================
sub _write_doc {
#===================================
    my ( $self, $action, $uid, $data, %args ) = @_;
    return $self->es->$action(
        data => $data,
        %{ $uid->write_params },
        %args
    );
}

#===================================
sub delete_doc {
#===================================
    my ( $self, $uid, %args ) = @_;
    return $self->es->delete( %{ $uid->write_params }, %args );
}

#===================================
sub bulk {
#===================================
    my ( $self, %args ) = @_;
    return $self->es->bulk(%args);
}

1;



=pod

=head1 NAME

Elastic::Model::Role::Store - ElasticSearch backend for document read/write requests

=head1 VERSION

version 0.24

=head1 DESCRIPTION

All document-related requests to the ElasticSearch backend are handled
via L<Elastic::Model::Role::Store>.

=head1 ATTRIBUTES

=head2 es

    $es = $store->es

Returns the connection to ElasticSearch.

=head1 METHODS

=head2 get_doc()

    $result = $store->get_doc($uid, %args);

Retrieves the doc specified by the L<$uid|Elastic::Model::UID> from
ElasticSearch, by calling L<ElasticSearch/"get()">. Throws an exception
if the document does not exist.

=head2 doc_exists()

    $bool = $store->doc_exists($uid, %args);

Checks whether the doc exists in ElastciSearch. Any C<%args> are passed through
to L<ElasticSearch/exists()>.

=head2 create_doc()

    $result = $store->create_doc($uid => \%data, %args);

Creates a doc in the ElasticSearch backend and returns the raw result.
Throws an exception if a doc with the same L<$uid|Elastic::Model::UID>
already exists.  Any C<%args> are passed to L<ElasticSearch/"create()">

=head2 index_doc()

    $result = $store->index_doc($uid => \%data, %args);

Updates (or creates) a doc in the ElasticSearch backend and returns the raw
result. Any failure throws an exception.  If the L<version|Elastic::Model::UID/"version">
number does not match what is stored in ElasticSearch, then a conflict exception
will be thrown.  Any C<%args> will be passed to L<ElasticSearch/"index()">.
For instance, to overwrite a document regardless of version number, you could
do:

    $result = $store->index_doc($uid => \%data, version => 0 );

=head2 delete_doc()

    $result = $store->delete_doc($uid, %args);

Deletes a doc in the ElasticSearch backend and returns the raw
result. Any failure throws an exception.  If the L<version|Elastic::Model::UID/"version">
number does not match what is stored in ElasticSearch, then a conflict exception
will be thrown.  Any C<%args> will be passed to L<ElasticSearch/"delete()">.

=head2 bulk()

    $result = $store->bulk(
        actions     => $actions,
        on_conflict => sub {...},
        on_error    => sub {...},
        %args
    );

Performs several actions in a single request. Any %agrs will be passed to
L<ElasticSearch/bulk()>.

=head2 search()

    $results = $store->search(@args);

Performs a search, passing C<@args> to L<ElasticSearch/"search()">.

=head2 scrolled_search()

    $results = $store->scrolled_search(@args);

Performs a scrolled search, passing C<@args> to L<ElasticSearch/"scrolled_search()">.

=head1 AUTHOR

Clinton Gormley <drtech@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Clinton Gormley.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

# ABSTRACT: ElasticSearch backend for document read/write requests

