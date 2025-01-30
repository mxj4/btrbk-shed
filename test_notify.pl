#! /usr/bin/env perl

use v5.40;
use strict;
use warnings;

# Support Fedora's minimal Perl installation
BEGIN {
    my $script_path = $0;
    my ($script_dir) = $script_path =~ m{^(.*)/}; # extract the directory part
    $script_dir = '.' unless defined $script_dir;
    unshift @INC, "$script_dir/btrbk-shed/usr/share/btrbk-shed/site_perl"; # our modules
}

use Notify;

sub test {
  my $notify_id = Notify::start($ENV{NOTIFY_USER}, "start", "Test,\nline2.");
  say "Started a notification, notify_id is $notify_id.";
  for (reverse 1..5) {
    Notify::update ($ENV{NOTIFY_USER}, $notify_id, "update", "$_");
  }
  Notify::end($ENV{NOTIFY_USER}, $notify_id, "end", "Done.\nline2\nline3\n");
  say "Ended notification $notify_id.";
}

test();
