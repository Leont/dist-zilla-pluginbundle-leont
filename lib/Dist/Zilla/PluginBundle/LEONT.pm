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

my @basics = qw/
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
TestRelease
ConfirmRelease
UploadToCPAN
/;

my @plugins = qw/
AutoPrereqs
MetaJSON
Repository
Bugtracker
MinimumPerl
Git::NextVersion

PodWeaver
PkgVersion
InstallGuide

PodSyntaxTests
PodCoverageTests
Test::Compile

NextRelease
CheckChangesHasContent
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

	$self->add_plugins(@basics);
	my $tool = $tools{ $self->install_tool };
	confess 'No known tool ' . $self->install_tool if not $tool;
	$self->add_plugins(@{$tool});
	$self->add_plugins(@plugins);
	$self->add_bundle("\@$_") for @bundles;
	return;
}

1;

# ABSTRACT: LEONT's dzil bundle

=head1 DESCRIPTION

This is currently identical to the following setup:

    [@Filter]
    -bundle = @Basic
    -remove = MakeMaker

	($install_tool dependent modules)

    [AutoPrereqs]
    [MetaJSON]
    [MetaResources]
    [Repository]
    [Bugtracker]
    [MinimumPerl]
    [Git::NextVersion]
    
    [PodWeaver]
    [PkgVersion]
    
    [PodSyntaxTests]
    [PodCoverageTests]
    [Test::Kwalitee]
    [Test::Compile]
    
    [NextRelease]
    [CheckChangesHasContent]
    [@Git]

The install_tool parameter can currently have 4 different values:

=over 4

=item * eumm

Use ExtUtils::MakeMaker

=item * mb

Use Module::Build

=item * mbc

Use Module::Build with the ModuleBuild::Custom plugin

=item * mbt

Use Module::Build::Tiny

=back

=begin Pod::Coverage

configure

=end Pod::Coverage

=cut

