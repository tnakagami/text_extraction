#!/usr/bin/perl

use utf8;
use strict;
use warnings;
use Clipboard;
use JSON;

# read configuration file
sub read_config {
    my $filepath = $_[0];
    my $config;

    # read file
    open my $handler, '<', $filepath or die 'Cannot open ' . $filepath . "\n";
    my $content = do { local $/; <$handler> };
    close $handler;
    # decode string to json object
    $config = decode_json($content);

    return $config;
}

# extract text from clipboard
sub extract_text {
    my ($text, @patterns) = @_;
    my @extracted = ();

    foreach my $pattern (@patterns) {
        my @matched = ($text =~ m/$pattern/gi);
        push(@extracted, join("\n", @matched));
    }

    return join("\n", @extracted);
}

# get environment variables
my $config_filepath = './config.json';
if (defined($ENV{TEXT_EXTRACTION_CONFIG})) {
    $config_filepath = $ENV{TEXT_EXTRACTION_CONFIG};
}

# ============
# main routine
# ============
eval {
    # preparation
    my $config = &read_config($config_filepath);
    my @patterns = @{$config->{'patterns'}};
    # read text from clipboard
    #my $text = Clipboard->paste();
    my $text = "hoge is inviting you to a Zoom meeting.\nJoin Zoom Meeting\nhttps://success.zoom.us//xxxx?pwd=ccc\nPassword: 123\n\n Topic: Sample Room\n\n One tap to join audio +000\nOr, Dial: +111\n         222\n         333\nMeeting ID: 987 654 321\n Meeting Password: 123\n\n Or, join by SIP\nhelper\@zoom.com";
    # extraction
    my $result = extract_text($text, @patterns);
    print $result . "\n";
    # write text to clipboard
    #Clipboard->copy($result);
};

# check exception
if ($@) {
    my $err = $@;
    print 'Error: ' . $err . "\n";
}
