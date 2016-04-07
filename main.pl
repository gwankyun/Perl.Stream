#! /usr/bin/perl
use 5.022;
use Data::Dumper;

sub delay {
	my $s = shift;
	$s;
}

my $ref = sub {
	my $r = shift;
	if (ref $r) {
		ref $r;
	}
};

my $isCode = sub {
	my $r = shift;
	if (ref $r && $r->$ref() eq 'CODE') {
		1;
	}
	else {
		0;
	}
};

my $isArray = sub {
	my $r = shift;
	if (ref $r && $r->$ref() eq 'ARRAY') {
		1;
	}
	else {
		0;
	}
};

my $force = sub {
	my $c = shift;
	if ($c->$isCode()) {
		$c->();
	}
};

my $s = sub { 1 };
#say force($s);#測試force

my $derefArray = sub {
	@{(shift)};
};

my $ofArray;
$ofArray = sub {
	my $a = shift;
	if ($a->$derefArray() == 0) {
		undef;
	}
	elsif ($a->$derefArray() == 1) {
		my $first = $a->[0];
		[$first, delay(sub { undef })];
	}
	else {
		my @ar = $a->$derefArray();
		my $last = $#ar;
		my $first = $ar[0];
		my @tail = @ar[1..$last];
		[$first, delay(sub { [@tail]->$ofArray() })];
	}
};

my $defined = sub {
	defined shift;
};

my $head = sub {
	my $r = shift;
	if ($r->$isArray()) {
		$r->[0];
	}
};

my $isNot = sub {
	!shift;
};

my $tail = sub {
	my $s = shift;
	if ($s->$isArray()) {
		$s->[1];
	}
};




my $take;
$take = sub {
	my $s = shift;
	my $n = shift;
		#say '$s:1' . Dumper($s);
	if ($n == 0) {
		[];
	}
	elsif ($s->$isCode()) {
		[];
	}
	else {
		my $h = $s->$head();
		my $t = $s->$tail();
		say Dumper($h);
		[$h, $take->($t->$force(), $n - 1)->$derefArray()];
	}
};

my @a = (0..9);

#say ref($a);

my $s = [0..9]->$ofArray();

say Dumper($s);
say $s->$tail()->$ref();

my $t = $s->$take(5);
say Dumper($t);
#say $s->$ref();
#say @{$t};