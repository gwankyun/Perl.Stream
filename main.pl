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


my $derefArray = sub {
	@{(shift)};
};

sub take {
	my $n = shift;
	my $s = shift;
		#say '$s:1' . Dumper($s);
	if ($n == 0) {
		[];
	}
	elsif ($s->$isCode()) {
		[];
	}
	else {
		#say '$s:' . Dumper($s);
		my $h = $s->$head();
		my $t = $s->$tail();
		say Dumper($h);
		[$h, take($n - 1, $t->$force())->$derefArray()];
	}
}

my @a = (0..9);

#say ref($a);

my $s = ofArray(@a);

say Dumper($s);
say $s->$tail()->$ref();

my $t = take(5, $s);
say Dumper($t);
#say $s->$ref();
#say @{$t};