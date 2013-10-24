
BEGIN {
  unless ($ENV{RELEASE_TESTING}) {
    require Test::More;
    Test::More::plan(skip_all => 'these tests are for release candidate testing');
  }
}

use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::NoTabsTests 0.04

use Test::More 0.88;
use Test::NoTabs;

my @files = (
    'lib/Elastic/Doc.pm',
    'lib/Elastic/Manual.pod',
    'lib/Elastic/Manual/Analysis.pod',
    'lib/Elastic/Manual/Attributes.pod',
    'lib/Elastic/Manual/Attributes/Unique.pod',
    'lib/Elastic/Manual/Intro.pod',
    'lib/Elastic/Manual/NoSQL.pod',
    'lib/Elastic/Manual/QueryDSL.pod',
    'lib/Elastic/Manual/QueryDSL/Filters.pod',
    'lib/Elastic/Manual/QueryDSL/Nested.pod',
    'lib/Elastic/Manual/QueryDSL/Queries.pod',
    'lib/Elastic/Manual/Reindex.pod',
    'lib/Elastic/Manual/Scaling.pod',
    'lib/Elastic/Manual/Scoping.pod',
    'lib/Elastic/Manual/Searching.pod',
    'lib/Elastic/Manual/Terminology.pod',
    'lib/Elastic/Model.pm',
    'lib/Elastic/Model/Alias.pm',
    'lib/Elastic/Model/Bulk.pm',
    'lib/Elastic/Model/Deleted.pm',
    'lib/Elastic/Model/Domain.pm',
    'lib/Elastic/Model/Index.pm',
    'lib/Elastic/Model/Meta/Class/Doc.pm',
    'lib/Elastic/Model/Meta/Class/Model.pm',
    'lib/Elastic/Model/Namespace.pm',
    'lib/Elastic/Model/Result.pm',
    'lib/Elastic/Model/Results.pm',
    'lib/Elastic/Model/Results/Cached.pm',
    'lib/Elastic/Model/Results/Scrolled.pm',
    'lib/Elastic/Model/Role/Doc.pm',
    'lib/Elastic/Model/Role/Index.pm',
    'lib/Elastic/Model/Role/Iterator.pm',
    'lib/Elastic/Model/Role/Model.pm',
    'lib/Elastic/Model/Role/Results.pm',
    'lib/Elastic/Model/Role/Store.pm',
    'lib/Elastic/Model/Scope.pm',
    'lib/Elastic/Model/SearchBuilder.pm',
    'lib/Elastic/Model/Store.pm',
    'lib/Elastic/Model/Trait/Exclude.pm',
    'lib/Elastic/Model/Trait/Field.pm',
    'lib/Elastic/Model/TypeMap/Base.pm',
    'lib/Elastic/Model/TypeMap/Common.pm',
    'lib/Elastic/Model/TypeMap/Default.pm',
    'lib/Elastic/Model/TypeMap/ES.pm',
    'lib/Elastic/Model/TypeMap/Moose.pm',
    'lib/Elastic/Model/TypeMap/Objects.pm',
    'lib/Elastic/Model/TypeMap/Structured.pm',
    'lib/Elastic/Model/Types.pm',
    'lib/Elastic/Model/UID.pm',
    'lib/Elastic/Model/View.pm'
);

notabs_ok($_) foreach @files;
done_testing;
