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
	
	
	#$s = fileRead($0);
	
	
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
	while($o3 =~ /sub ([^\x7b]+)/g){
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
	
	for my $subname (sort{
		length($a) > length($b)
	} keys %subs){
		my $newname = $subs{$subname}{'newname'};
		print "sub1 '$subname'\n";
		
		$o3 =~ s/sub $subname/sub $newname/g;
		$o3 =~ s/$subname\(/$newname\(/g;
	}
	
	for my $varname (sort{
		length($a) > length($b)
	} keys %vars){
		my $newname = $vars{$varname}{'newname'};
		my $vartype = $vars{$varname}{'type'};
		
		print "var1 $vartype '$varname' '$newname'\n";
		
		if($vartype eq '%'){
			$o3 =~ s/\$$varname\{/\$$newname\{/g;
		}
		$o3 =~ s/$vartype$varname/$vartype$newname/g;
	}
	#replacePvarsAndLvars(\$o3, \%vars);
		
	
	#$s =~ s/\r//sg;$s =~ s/\n//sg;
	
	print "\n\nout\n$o3\n";
	
	my $f = $0.'.pl';
	fileWrite($f, "#!/usr/bin/perl -w\n# Created by TheFox\@fox21.at\n\n".$o3);
	#chmod 0755, $f;
	
}

sub cmdsexec{
	
	my($cont, $ptype, $hpsubs, $hpvars, $plevel) = @_;
	
	
	if(!defined $ptype){
		$ptype = 'sub';
	}
	
	my %psubs = ();
	if(defined $hpsubs){
		%psubs = %{$hpsubs};
	}
	
	my %pvars = ();
	if(defined $hpvars){
		%pvars = %{$hpvars};
	}
	
	if(!defined $plevel){
		$plevel = 0;
	}
	
	
	my $rv = '';
	
	
	if($plevel >= 10){
		print STDERR "level can't be >= $plevel\n";
		exit(1);
	}
	
	
	t(\$cont);
	
	
	print "$plevel cmdsexec '$ptype' '$cont'\n\n";
	
	
	### CUT ###
#	if($plevel >= 2){
#		
#		for my $k (keys %pvars){
#			print "$plevel pvar $k $pvars{$k}{'newname'}\n";
#		}
#		
#		return '';
#	}
	### CUT ###
	
	
	
	
	
	
	
	my %cmds = ();
	my $cmdid = 0;
	
	my $level = 0;
	my $isStr = '';
	my $isLoop = 0;
	my $isLoopC = 0;
	my $isSub = 0;
	my $lastWasLoop = 0;
	
	my $contOut = '';
	
	my $n = 0;
	my $contlen = length $cont;
	for($n = 0; $n < $contlen; $n++){
		
		my $c = substr $cont, $n, 1;
		my $c2 = substr $cont, $n, 2;
		my $c3 = substr $cont, $n, 3;
		my $c4 = substr $cont, $n, 4;
		my $c5 = substr $cont, $n, 5;
		my $c7 = substr $cont, $n, 7;
		my $cn = ord $c;
		
		#print "cmdsexec '$c'  \n";
		
		my $cmdidInc = 0;
		
		
		if(!defined $cmds{$cmdid}){
			#print "new cmd $cmdid\n\n";
			
			$cmds{$cmdid} = '';
		}
		
		if(!$isStr){
			
			
			
			
			my $levelInc = 0;
			
			if($c eq '{'){
				$levelInc = 1;
				
				if($isLoop && $level == 0){
					$isLoopC++;
				}
			}
			elsif($c eq '('){
				$levelInc = 1;
				
				if($isLoop && $level == 0){
					$isLoopC++;
				}
			}
			
			elsif($c eq '}'){
				$levelInc = -1;
			}
			elsif($c eq ')'){
				$levelInc = -1;
			}
			
			elsif($c eq ';'){
				
				if($level == 0){
					#$cmdid++;
					#next;
					$cmdidInc = 1;
				}
				
			}
			
			
			if($c2 eq 'if'){
				$n++;
				if($level == 0){
					$cmdid++;
					#print "cmdid++ $cmdid\n\n";
				}
				$c = $c2;
				$isLoop = 1;
			}
			elsif($c5 eq 'elsif'){
				$n += 4;
				
				if($level == 0){
					$cmdid++;
				}
				$c = $c5;
				$isSub = 1;
			}
			elsif($c4 eq 'else'){
				$n += 3;
				
				if($level == 0){
					$cmdid++;
				}
				$c = $c4;
				$isSub = 1;
			}
			elsif($c4 eq 'sub '){
				$n += 3;
				
				if($level == 0){
					$cmdid++;
					#print "cmdid++ $cmdid\n\n";
				}
				$c = $c4;
				$isSub = 1;
			}
			elsif($c3 eq 'for'){
				$n += 2;
				
				if($level == 0){
					$cmdid++;
					#print "cmdid++ $cmdid\n\n";
				}
				$c = $c3;
				$isLoop = 1;
			}
			elsif($c7 eq 'for my '){
				$n += 6;
				
				if($level == 0){
					$cmdid++;
					#print "cmdid++ $cmdid\n\n";
				}
				#$cmds{$cmdid}{'cont'} .= $c7;
				$c = $c7;
				
				#$level++;
				$isLoop = 1;
				
				#$contOut = $cmds{$cmdid}{'cont'};
				#printf "char: $cmdid $level $isLoop '$contOut' \n";
				
				#next;
			}
			elsif($c5 eq 'while'){
				$n += 4;
				
				if($level == 0){
					$cmdid++;
				}
				$c = $c5;
				$isLoop = 1;
			}
			
			
			$level += $levelInc;
			if($levelInc == 1){
				#print "level inc\n\n";
				#print "\n";
			}
			elsif($levelInc == -1){
				#print "level deg\n\n";
				#print "\n";
				
				if($level == 0 && $isLoop && $isLoopC == 2){
					$isLoop = 0;
					$isLoopC = 0;
					$cmdidInc = 1;
				}
				elsif($level == 0 && $isSub){
					$isSub = 0;
					$cmdidInc = 1;
				}
				elsif($level == 0){
					#$cmdidInc = 1;
				}
			}
			
		}
		
		if($c eq '"' || $c eq "'"){
			if($c eq $isStr){
				$isStr = '';
			}
			elsif(!$isStr){
				$isStr = $c;
			}
			
			#next; # TODO: zeile weg
		}
		
		# TODO: zeile weg
		#if($c eq ' ' || $isStr){ next; }
		
		
		$cmds{$cmdid} .= $c;
		$contOut = $cmds{$cmdid};
		
		#if($cmdidInc){
			#printf "char: $cmdid $level $isLoop $isLoopC $isSub '$contOut' \n";
			#sleep 1;
		#}
		#sleep 1;
		
		if($cmdidInc){
			#print "cmdidInc $cmdidInc\n\n";
		}
		
		$cmdid += $cmdidInc;
		
	}
	
	#print "\n\n";
	
	
	my %subs = ();
	my @cmds2 = ();
	for my $cid (sort{$a <=> $b} keys %cmds){
		my $cmd = $cmds{$cid};
		
		$cmd =~ s/^ +//;
		$cmd =~ s/ +$//;
		#$cmd =~ s/;$//;
		
		if($cmd ne '' && $cmd ne ';'){
			#$cmd =~ s/;$//;
			#print "$plevel cmd: $cid '$cmd'\n";
			
			#if($cmd =~ /^my \$([a-z0-9]+)/i){
			if($cmd =~ /^sub ([a-z0-9]+)/i){
				my $sub = $1;
				if(!defined $subs{$sub}){
					$subs{$sub} = {
						'name' => $sub,
						#'newname' => rs(r(4, 40)),
						'newname' => $sub.'_'.r(100, 999),
					};
					
				}
			}
			
			push @cmds2, $cmd;
		}
	}
	
	
	#print "\n";
	my %vars = ();
	
	
	for my $cmd (@cmds2){
		
		my $newcmd = $cmd;
		t(\$newcmd);
		
		print "$plevel cmd '$newcmd'\n";
			
	}
	
	
	$rv;
}

sub replacePvarsAndLvars{
	
	my($hcmd, $hvars, $hpvars) = @_;
	
	my %vars = %{$hvars};
	my %pvars = ();
	
	if(defined $hpvars){
		%pvars = %{$hpvars};
	}
	
	#print "replacePvarsAndLvars '$hcmd' '$$hcmd' \n";
	
	my $varshrefc = 0;
	for my $varshref (\%vars, \%pvars){
		$varshrefc++;
		
		
		
		my $parse = 1;
		if($varshrefc >= 2){
			$parse = 0;
			
			if(!grep{
				my $newname = $vars{$_}{'newname'};
				#print "$plevel grep '$newcmd' '$newname'\n";
				
				$$hcmd =~ /$newname/ ? 1 : 0;
				
			} keys %vars){
				$parse = 1;
			}
		}
		
		
		$parse = 1;
		if($parse){
			my %svars = %{$varshref};
			for my $var (keys %svars){
				my $type = $svars{$var}{'type'};
				my $newname = $svars{$var}{'newname'};
				
				if($type eq '%'){
					$$hcmd =~ s/\$\Q$var\E\{/\$$newname\{/g;
					#print "\treplacePvarsAndLvars '\$$var' '\$$newname' \n";
				}
				$$hcmd =~ s/\Q$type$var\E/$type$newname/g;
				#print "\treplacePvarsAndLvars '$type$var' '$type$newname' \n";
			}
		}
	}
	
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
