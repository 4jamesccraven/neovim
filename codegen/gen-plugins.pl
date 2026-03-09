use strict;
use warnings;
use diagnostics;

use v5.16;

use JSON::PP;
use File::Basename;
use File::Spec;

my $PROJECT_ROOT = dirname(dirname(__FILE__));
my $PLUGINS_JSON = File::Spec->catfile($PROJECT_ROOT, 'plugins.json');

open(my $fh, '<', $PLUGINS_JSON) or die "Cannot open file: $!";
my $json_text = do { local $/; <$fh> };
close($fh);

my $plugins_json = decode_json($json_text);
my @plugin_names = map { $_->{gh} } values %$plugins_json;
my @lazy_fmt = map { "    { \"$_\" }," } @plugin_names;
@lazy_fmt = sort @lazy_fmt;

my $plug_file = "return {\n" . join("\n", @lazy_fmt) . "\n}";

print "$plug_file\n";
