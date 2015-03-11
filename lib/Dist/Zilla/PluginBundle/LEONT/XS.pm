package Dist::Zilla::PluginBundle::LEONT::XS;

use Moose;

extends 'Dist::Zilla::PluginBundle::LEONT';

has '+install_tool' => (
	default => 'mb',
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

# ABSTRACT: Legacy plugin bundle for xs modules

