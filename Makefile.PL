
use strict;
use warnings;



use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "A NoSQL document store with full text search for Moose objects using ElasticSearch as a backend.",
  "AUTHOR" => "Clinton Gormley <drtech\@cpan.org>",
  "BUILD_REQUIRES" => {
    "CHI" => 0,
    "DateTime" => 0,
    "ElasticSearch::TestServer" => 0,
    "Test::Deep" => 0,
    "Test::Differences" => 0,
    "Test::Exception" => 0,
    "Test::Moose" => 0,
    "Test::More" => "0.96",
    "Test::Strict" => 0,
    "utf8" => 0
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
    "ElasticSearch" => "0.61",
    "ElasticSearch::SearchBuilder" => "0.16",
    "ElasticSearchX::UniqueKey" => "0.03",
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
  "VERSION" => "0.23",
  "test" => {
    "TESTS" => "t/*.t t/00_setup/*.t t/10_typemaps/*.t t/20_namespace/*.t t/30_domain/*.t t/40_view/*.t t/50_scope/*.t t/60_reindex/*.t t/65_bulk/*.t t/70_searchbuilder/*.t"
  }
);


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



