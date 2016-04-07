#! /usr/bin/perl
use 5.022;

sub delay {
	my $s = shift;
	$s;
}

sub force {
	my $s = shift;
	$s->();
}

my $s = sub { 1 };
#say force($s);#測試force