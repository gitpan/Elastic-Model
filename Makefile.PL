
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A NoSQL document store with full text search for Moose objects using Elasticsearch as a backend.",
  "AUTHOR" => "Clinton Gormley <drtech\@cpan.org>",
  "BUILD_REQUIRES" => {
    "Test::Strict" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "Elastic-Model",
  "EXE_FILES" => [],
  "LICENSE" => "perl",
  "NAME" => "Elastic::Model",
  "PREREQ_PM" => {
    "Carp" => 0,
    "Class::Load" => 0,
    "Class::MOP" => 0,
    "Data::Dump" => 0,
    "Data::Dumper" => 0,
    "Devel::GlobalDestruction" => 0,
    "ElasticSearch::SearchBuilder" => "0.18",
    "ElasticSearchX::UniqueKey" => "0.03",
    "Elasticsearch" => "0.75",
    "Elasticsearch::Compat" => "0.02",
    "JSON" => 0,
    "List::MoreUtils" => 0,
    "List::Util" => 0,
    "MIME::Base64" => 0,
    "Moose" => "2.06",
    "Moose::Exporter" => 0,
    "Moose::Role" => 0,
    "Moose::Util" => 0,
    "Moose::Util::TypeConstraints" => 0,
    "MooseX::Types" => 0,
    "MooseX::Types::Moose" => 0,
    "MooseX::Types::Structured" => 0,
    "Scalar::Util" => 0,
    "Sub::Exporter" => 0,
    "Time::HiRes" => 0,
    "Try::Tiny" => 0,
    "Variable::Magic" => "0.51",
    "namespace::autoclean" => 0,
    "parent" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "CHI" => 0,
    "DateTime" => 0,
    "Test::Deep" => 0,
    "Test::Exception" => 0,
    "Test::Moose" => 0,
    "Test::More" => "0.96",
    "lib" => 0,
    "utf8" => 0
  },
  "VERSION" => "0.27",
  "test" => {
    "TESTS" => "t/*.t t/00_setup/*.t t/10_typemaps/*.t t/20_namespace/*.t t/30_domain/*.t t/40_view/*.t t/50_scope/*.t t/60_reindex/*.t t/65_bulk/*.t t/70_searchbuilder/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



