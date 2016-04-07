#! /usr/bin/perl
use 5.022;
use Data::Dumper;

sub delay {
	my $s = shift;
	$s;
}

my $force = sub {
	(shift)->();
};

my $ref = sub {
	ref shift;
};

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

my $head = sub {
	($shift)->[0];
};

my $tail = sub {
	($shift)->[1];
};

my $derefAarray = sub {
	@{($shift)};
};

sub take {
	my $n = shift;
	my $s = shift;
	if ($n == 0) {
		undef;
	}
	elsif ($s->$tail()->$ref() == 'CODE') {
		undef;
	}
	else {
		my $head = $s->$head();
		my $tail = $s->$tail();
		[$head, take($n - 1, $tail)];
	}
}

my @a = (0..9);

#say ref($a);

my $s = ofArray(@a);

say Dumper($s);

my $t = take(5, $s);
say Dumper($s);
say $s->$ref();
#say @{$t};