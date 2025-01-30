#! /usr/bin/env perl

use v5.40;
use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/btrbk-shed/usr/share/btrbk-shed";
use Notify;

sub test {
  my $notify_id = Notify::start($ENV{USER}, "start", "Test,\nline2.");
  say "Started a notification, notify_id is $notify_id.";
  for (reverse 1..5) {
    Notify::update ($ENV{USER}, $notify_id, "update", "$_");
    sleep(1);
  }
  Notify::end($ENV{USER}, $notify_id, "end", "Done.");
  say "Ended notification $notify_id.";
}

test();
