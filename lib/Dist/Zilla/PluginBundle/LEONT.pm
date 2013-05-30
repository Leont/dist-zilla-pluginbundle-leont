package Dist::Zilla::PluginBundle::LEONT;
use strict;
use warnings;

use Moose;
with qw/Dist::Zilla::Role::PluginBundle::Easy Dist::Zilla::Role::PluginBundle::PluginRemover Dist::Zilla::Role::PluginBundle::Config::Slicer/;

has install_tool => (
	is      => 'ro',
	isa     => 'Str',
	lazy    => 1,
	default => sub {
		my $self = shift;
		$self->payload->{install_tool};
	},
);

my @plugins_early = qw/
GatherDir
PruneCruft
ManifestSkip
MetaYAML
License
Readme
ExtraTests
ExecDir
ShareDir
Manifest

AutoPrereqs
MetaJSON
Repository
Bugtracker
MinimumPerl
Git::NextVersion

NextRelease
CheckChangesHasContent
/;

# AutoPrereqs should be before installtool (for BuildSelf), InstallGuide should be after it.
# UploadToCPAN should be after @Git

my @plugins_late = qw/
TestRelease
ConfirmRelease
UploadToCPAN

PodWeaver
PkgVersion
InstallGuide

PodSyntaxTests
PodCoverageTests
Test::Compile
/;

my @bundles = qw/Git/;

my %tools = (
	eumm => [ 'MakeMaker' ],
	mb   => [ 'ModuleBuild' ],
	mbc  => [ qw/ModuleBuild::Custom Meta::Dynamic::Config/ ],
	mbt  => [ 'ModuleBuildTiny' ],
	self => [ 'BuildSelf' ]
);

sub configure {
	my $self = shift;

	my $tool = $tools{ $self->install_tool };
	confess 'No known tool ' . $self->install_tool if not $tool;
	$self->add_plugins(@plugins_early);
	$self->add_plugins(@{$tool});
	$self->add_bundle("\@$_") for @bundles;
	$self->add_plugins(@plugins_late);
	return;
}

1;

# ABSTRACT: LEONT's dzil bundle

=head1 DESCRIPTION

This is currently identical to the following setup:

    [@Filter]
    -bundle = @Basic
    -remove = MakeMaker

    [AutoPrereqs]
    [MetaJSON]
    [MetaResources]
    [Repository]
    [Bugtracker]
    [MinimumPerl]
    [Git::NextVersion]
    
    [NextRelease]
    [CheckChangesHasContent]

    ($install_tool dependent modules)

    [PodWeaver]
    [PkgVersion]
    
    [PodSyntaxTests]
    [PodCoverageTests]
    [Test::Compile]
    
    [@Git]

The install_tool parameter can currently have 5 different values:

=over 4

=item * eumm

Use ExtUtils::MakeMaker

=item * mb

Use Module::Build

=item * mbc

Use Module::Build with the ModuleBuild::Custom plugin

=item * mbt

Use Module::Build::Tiny

=item * self

Use the installing module to bootstrap itself

=back

=begin Pod::Coverage

configure

=end Pod::Coverage

=cut

