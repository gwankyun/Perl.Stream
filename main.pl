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

sub take {
	my ($n, $s) = @_;
	if ($n == 0) {
		undef;
	}
	elsif (defined $s) {
		undef;
	}
	else {
		my $first = $s->[0];
		my $tail = $s->[1];
		[$first, take($n - 1, $tail)];
	}
}

my $a = [0..9];
say @{$a}[2..5];