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

my $n = 0;
for(my $i = 0; $i < $n; $i++){
	my $x = substr $i;
	print "n = $i $n";
	
}


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
	
	
	my $o3 = '';
	$o3 = cmdsexec($o2);
	
	
	
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
	
	
	
#	if($plevel >= 2){
#		
#		for my $k (keys %pvars){
#			print "$plevel pvar $k $pvars{$k}{'newname'}\n";
#		}
#		
#		return '';
#	}
	
	
	
	
	
	
	
	
	my %cmds = ();
	my $cmdid = 0;
	
	my $level = 0;
	my $isStr = '';
	my $isLoop = 0;
	my $isLoopC = 0;
	my $isSub = 0;
	my $lastWasLoop = 0;
	
	my $contOut = '';
	
	my $contlen = length $cont;
	for(my $n = 0; $n < $contlen; $n++){
		
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
		
		
		if($cmd =~ /^my ([\$\@\%])([a-z0-9]+)/i){
			#print "var\n";
			my $type = $1;
			my $var = $2;
			
			
			if(!defined $vars{$var}){
				
				my $newname = $var.'_'.r(100, 999);
				
				$vars{$var} = {
					'name' => $var,
					'newname' => $newname,
					'type' => $type,
				};
				#$newcmd =~ s/\Q$type$var\E/$type$newname/g;
				replacePvarsAndLvars(\$newcmd, \%vars, \%pvars);
				
				$rv .= $newcmd."\n";
				#print "$plevel new var: '$type' '$var' '$type$var' '$type$newname'\n";
				
			}
			
		}
		elsif($cmd =~ /^(if|elsif|while)(\([^\x7b]+)(\x7b)/){
			#print "$plevel if/while '$1' '$2' '$3'\n";
			
			my $subtype = $1;
			my $subpre = $2;
			
			$newcmd =~ s/^\Q$subtype$subpre\E\{//;
			$newcmd =~ s/\}$//;
			
			t(\$newcmd);
			
			
			replacePvarsAndLvars(\$subpre, \%vars, \%pvars);
			
			
			print "$plevel $subtype '$subpre' '$newcmd'  \n\n";
			
			#exit();
			
			my %newvars = hashMerge(\%vars, \%pvars);
			$rv .= $subtype.$subpre.'{'."\n".cmdsexec($newcmd, $subtype, \%subs, \%newvars, $plevel + 1)."\n".'}'."\n";
			
		}
		elsif($cmd =~ /^else\x7b/){
			#print "$plevel if/while '$1' '$2' '$3'\n";
			
			my $subtype = $1;
			my $subpre = $2;
			
			$newcmd =~ s/^else\x7b//;
			$newcmd =~ s/\x7d$//;
			
			t(\$newcmd);
			
			
			
			print "$plevel else '$newcmd'  \n\n";
			
			#exit();
			
			my %newvars = hashMerge(\%vars, \%pvars);
			$rv .= 'else{'."\n".cmdsexec($newcmd, $subtype, \%subs, \%newvars, $plevel + 1)."\n".'}'."\n";
			
		}
		elsif($cmd =~ /^sub /){
			#print "$plevel sub '$newcmd' \n";
			#for my $sub (keys %subs){
			#	my $newname = $subs{$sub}{'newname'};
			#	$newcmd =~ s/sub $sub/sub $newname/;
			#}
			
			my $subname = '';
			
			if($newcmd =~ s/sub ([^\{]+)\{//){
				$subname = $1;
			}
			
			if($subname ne ''){
				for my $subshref (\%subs, \%psubs){
					my %ssubs = %{$subshref};
					for my $subId (keys %ssubs){
						my $newname = $ssubs{$subId}{'newname'};
						$subname =~ s/$subId/$newname/g;
					}
				}
			}
			
			$newcmd =~ s/\}$//;
			
			t(\$newcmd);
			
			my %newvars = hashMerge(\%vars, \%pvars);
			
			#($cont, $ptype, $hpsubs, $hpvars, $level)
			#$rv .= 'sub '.$subname.'{'."\n".cmdsexec($newcmd, 'sub', \%subs, \%vars, $plevel + 1)."\n".'}';
			$rv .= 'sub '.$subname.'{'."\n".cmdsexec($newcmd, 'sub', \%subs, \%newvars, $plevel + 1)."\n".'}';
			
		}
		elsif($cmd =~ /^for/){
			
			my $forpre = '';
			my $forvar = '';
			
			if($newcmd =~ s/(for my [^\{]+)//){
				$forpre = $1;
				
				if($forpre =~ /for my \$([^\(]+)/){
					$forvar = $1;
				}
			}
			elsif($newcmd =~ s/(for.my .([^\{]+))// ){
				
				$forpre = $1;
				
				if($forpre =~ /for.my .([^=]+)/){
					$forvar = $1;
				}
				
			}
			elsif($newcmd =~ s/(for.[^\{]+)//){
				$forpre = $1;
				#print "exit '$1' \n";exit();
			}
			
			
			t(\$forvar);
			#print "$plevel for '$forpre' '$forvar'\n";
			
			
			my %newvars = hashMerge(\%vars, \%pvars);
			if($forvar ne ''){
				$newvars{$forvar} = {
					'name' => $forvar,
					'newname' => $forvar.'_'.r(100, 999),
					'type' => '$',
				};
			}
			#$forpre =~ s/\Q\$$forvar\E/\$$newname/g;
			
#			for my $var (keys %newvars){
#				my $type = $newvars{$var}{'type'};
#				my $newname = $newvars{$var}{'newname'};
#				if($type eq '%'){
#					$forpre =~ s/\$\Q$var\E\{/\$$newname\{/g;
#				}
#				$forpre =~ s/\Q$type$var\E/$type$newname/g;
#			}
			replacePvarsAndLvars(\$forpre, \%newvars);
			
			$newcmd =~ s/^\{//;
			$newcmd =~ s/\}$//;
			t(\$newcmd);
			
			print "$plevel for '$forpre' '$newcmd' \n";
			
			$rv .= $forpre.'{'."\n".cmdsexec($newcmd, 'for', \%subs, \%newvars, $plevel + 1)."\n".'}'."\n";
				
			
			
			
			
		}
		#elsif($cmd =~ /^while/){}
		else{
			
			
			for my $subshref (\%subs, \%psubs){
				my %ssubs = %{$subshref};
				for my $subId (keys %ssubs){
					my $newname = $ssubs{$subId}{'newname'};
					$newcmd =~ s/$subId\(/$newname\(/g;
					print "\t$plevel replace  sub1 '$subId(' '$newname(' '$newcmd'\n";
				}
			}
			
			
			replacePvarsAndLvars(\$newcmd, \%vars, \%pvars);
			
			
			print "$plevel misc '$newcmd' \n";
			
			
			
			#print "\n";
			
			$rv .= $newcmd."\n";
		}
		
		#print "\tcmd '$newcmd'\n\n";
		
		print "\n";
		
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
