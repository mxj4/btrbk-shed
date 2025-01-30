package Notify 0.01;

use v5.40;
use strict;
use warnings;

sub compile_dbus_msg ($notify_id, $summary, $body, $timeout = 0) {
    state $app_name = "btrbk-shed";
    # we don't want a icon in notification body,
    # this is different from desktop entry icon shown in notification header
    state $msg_icon_name = "";
    state $actions = "[]";
    # Quirk in Plasma desktop:
    # a hint of desktop-entry must be specified to make it visible in Notification History
    state $hints = qq({
        'desktop-entry': <'$app_name'>
    });
    # gdbus command is in glib2 package
    my $command = qq(
        gdbus call --session \
        --dest=org.freedesktop.Notifications \
        --object-path=/org/freedesktop/Notifications \
        --method=org.freedesktop.Notifications.Notify \
        "$app_name" $notify_id "$msg_icon_name" \
        "$summary" "$body" "$actions" "$hints" $timeout
    );
    $command =~ s/\s+/ /g; # Replace multiple whitespace with single space
    $command =~ s/^\s|\s$//g;  # Remove leading/trailing whitespace
    #say $command;
    return $command
}

# start a new notification and return notify id
sub start ($user, $summary, $body) {
    my $result = qx(systemd-run --user --machine=$user@.host --pipe ${\compile_dbus_msg(0, $summary, $body)});
    #say "$result";
    my ($notify_id) = $result =~ /\(uint32 (\d+),\)/;
    return $notify_id
}

# update the notification
sub update ($user, $notify_id, $summary, $body) {
    qx(systemd-run --user --machine=$user@.host ${\compile_dbus_msg($notify_id, $summary, $body)})
}

# end the notification in 10s
sub end ($user, $notify_id, $summary, $body) {
    qx(systemd-run --user --machine=$user@.host ${\compile_dbus_msg($notify_id, $summary, $body, 10000)})
}
