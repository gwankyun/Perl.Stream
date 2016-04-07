#! /usr/bin/perl
use 5.022;
use Data::Dumper;

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

sub ofArray {
	my @a = @_;
	if (@a == 0) {
		undef;
	}
	elsif (@a == 1) {
		my $first = $a[0];
		[$first, delay(sub { undef })];
	}
	else {
		my $last = $#a;
		my $first = $a[0];
		my @tail = @a[1..$last];
		[$first, delay(sub { ofArray(@tail) })];
	}
}

sub head {
	my $s = shift;
	$s->[0];
}

sub take {
	my $n = shift;
	my $s = shift;
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

my @a = (0..9);

#say ref($a);

my $s = ofArray(@a);

say Dumper($s);

#my $t = take(5, $s);

#say @{$t};