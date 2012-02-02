#!/usr/bin/perl -w
# Created @ 21.01.2012 by TheFox@fox21.at
# Polymorphic Perl Script

use strict;

$| = 1;


# Hex chars
# # = 23
# { = 7b
# } = 7d


### CUT ###
# Variable blacklist
my @bl = qw(
	chdir
	chmod
	chr
	do
	else
	elsif
	file
	for
	grep
	if
	int
	lc
	map
	my
	no
	open
	ord
	print
	printf
	q
	qq
	qw
	rand
	sleep
	split
	sort
	stat
	sub
	time
	tr
	uc
	use
	while
);
### CUT ###

sub main{
	
	print "start\n\n";
	
	
	#while(1){ print "".t()."\n"; sleep 1; }
	
	permute();
	
	print "\n\nend\n";
	
}

sub permute{
	print "permute $0\n";
	
	my $s = '';
	
	#while(1){ print rs(r(1, 40))."\n"; }

	### CUT ###
	$s = '#!/usr/bin/perl -w
		# created

#my $n = 0;
#for(my $i = 0; $i < $n; $i++){
#	my $x = substr $i;
#	print "n = $i $n";
#	
#}

main();

sub main
 {
my $n = 0;
my $contlen = length $cont;
for($n = 0; $n < $contlen; $n++){
	print "n = $i $n";
}

my %h = ();
for my $k (keys %h){ print "$k $h{$k}"; }
}

main();

	';
	### CUT ###
	
	
	$s = fileRead($0);
	
	
	my $o = '';
	
	
	$s =~ s/\r//sg;
	t(\$s);
	
	
	my $rc = 0;
	my $cutter = 0;
	my @rows = split /\n/, $s;
	for my $row (@rows){
		
		$rc++;
		#$row =~ s/^([^\x23]*)$/$1/;
		
		
		if($rc > 2){
			$row =~ s/^[ \t]+//;
			
			
			if($row =~ /\x23 CUT \x23/){
				$cutter = !$cutter;
			}
			
			
			
			if(!$cutter){
				#print "r $rc '$row'\n";
				
				if($row ne '' && $row !~ /^\x23/){
					
					#map{ } @bl;
					#my @tbl = grep{
					#	$row !~ /^print / && $row !~ /^my /
					#	&& $row =~ /\$/ && $row =~ /$_/
					#} @bl;
					#if(@tbl){
					#	print STDERR "ERROR: Can't parse file in line $rc: '$row' (@tbl)\n";
					#	exit(1);
					#}
					
					
					if($row !~ / $/){
						$row .= ' ';
					}
					
					$o .= $row;
				}
			}
		}
		
	}
	
	#exit();
	#print "\n\n";
	
	
	my $level = 0;
	my $ol = length $o;
	
	
	my $o2 = '';
	
	my $cmdid = 0;
	my %cmds = ();
	
	
	for(my $n = 0; $n < $ol; $n++){
		
		my $c = substr $o, $n, 1;
		my $c4 = substr $o, $n, 4;
		my $cn = ord($c);
		
		if($cn != 10 && $cn != 9){
			
			#print $c;
			
			
			$o2 .= $c;
			
			
			
			
			
			if($c eq '{' || $c eq '('){
				#printf "c '%4s' %3d ".("\t" x $level)." '$c' \n", $c4, $cn;
				$level++;
				
			}
			elsif($c eq '}' || $c eq ')'){
				
				$level--;
				#printf "c '%4s' %3d ".("\t" x $level)." '$c' \n", $c4, $cn;
				
			}
			else{
				#printf "c '%4s' %3d ".("\t" x $level)." '$c' \n", $c4, $cn;
			}
			
			
			
		}
		
	}
	
	
	my $o3 = $o2;
	#$o3 = cmdsexec($o2);
	
	my %subs = ();
	while($o3 =~ /sub ([a-z0-9]+)/ig){
		my $subname = $1;
		t(\$subname);
		
		
		if(!defined $subs{$subname}){
			#print "sub '$subname'\n";
			
			my $newname = 'sub_'.r(100, 999).'_'.$subname.'_'.r(100, 999);
			$subs{$subname} = {
				'name' => $subname,
				'newname' => $newname,
			};
			
			#$o3 =~ s/sub $subname/sub $newname/sg;
		}
	}
	
	
	my %vars = ();
	while($o3 =~ /([\$%@])([a-z0-9_]+)/gi){
		
		my $vartype = $1;
		my $varname = $2;
		
		
		
		if(!defined $vars{$varname}){
			#print "var $vartype '$varname'\n";
			
			my $newname = 'var_'.r(100, 999).'_'.$varname.'_'.r(100, 999);
			$vars{$varname} = {
				'name' => $varname,
				'newname' => $newname,
				'type' => $vartype,
			};
		}
	}
	
	for my $subname (reverse sort{
		length($a) <=> length($b)
	} keys %subs){
		my $newname = $subs{$subname}{'newname'};
		print "sub1 '$subname'\n";
		
		$o3 =~ s/sub $subname/sub $newname/g;
		$o3 =~ s/$subname\(/$newname\(/g;
	}
	
	for my $varname (reverse sort{
		length($a) <=> length($b)
	} keys %vars){
		my $newname = $vars{$varname}{'newname'};
		my $vartype = $vars{$varname}{'type'};
		
		print "var1 $vartype '$varname' '$newname'\n";
		
		if($vartype eq '%'){
			$o3 =~ s/\$$varname\{/\$$newname\{/sg;
		}
		$o3 =~ s/\Q$vartype\E$varname/$vartype$newname/sg;
		
		#print "$o3\n\n"; sleep 1;
	}
	#replacePvarsAndLvars(\$o3, \%vars);
		
	
	#$s =~ s/\r//sg;$s =~ s/\n//sg;
	
	#print "\n\nout\n$o3\n";
	
	my $f = $0.'.pl';
	fileWrite($f, "#!/usr/bin/perl -w\n# Created by TheFox\x40fox21.at\n\n".$o3);
	#chmod 0755, $f;
	
}

sub fileRead{
	my($f) = @_;
	my $s = '';
	
	open F, '<', $f;
	$s = join '', <F>;
	close F;
	
	$s;
}

sub fileWrite{
	my($f, $c) = @_;
	open F, '>', $f;
	print F $c;
	close F;
}

# Random number: min, max
sub r{
	my($mi, $ma) = @_;
	int($mi + int rand($ma - $mi + 1));
}

# Random string
sub rs{
	my($len) = @_;
	my $rv = '';
	
	my $nlen = $len;
	$nlen--;
	$rv .= chr((r(1, 1000) <= 800 ? 97 : 65) + int rand 26);
	
	for(my $n = 0; $n < $nlen; $n++){
		$rv .= r(1, 1000) <= 900 ? chr((r(1, 1000) <= 800 ? 97 : 65) + int rand 26) : r(1, 9);
	}
	
	
	if(grep{ $rv =~ /$_/i } @bl){
		$rv = rs($len);
	}
	
	$rv;
}

# Trim
sub t{
	my($r) = @_;
	
	$$r =~ s/^ +//s;
	$$r =~ s/ +$//s;
	
	$$r =~ s/^\n+//s;
	$$r =~ s/\n+$//s;
}

# Merge two hashes to one
sub hashMerge{
	my($hr1, $hr2) = @_;
	my %rv = ();
	
	for my $hr ($hr1, $hr2){
		if(defined $hr){
			my %h = %{$hr};
			for my $k (keys %h){
				$rv{$k} = $h{$k};
			}
		}
	}
	
	%rv;
}



main();





# EOF
