#!/usr/bin/perl -w
# Created @ 21.01.2012 by TheFox@fox21.at
# Polymorphic Perl Script

use strict;

$| = 1;


# Hex chars
# # = 23
# { = 7b
# } = 7d



# Variable blacklist
my @bl = (
	'chdir',
	'chmod',
	'chr',
	'do',
	'else',
	'elsif',
	'file',
	'for',
	'grep',
	'if',
	'int',
	'lc',
	'map',
	'my',
	'no',
	'open',
	'ord',
	'print',
	'printf',
	'q',
	'qq',
	'qw',
	'rand',
	'sleep',
	'split',
	'sort',
	'stat',
	'sub',
	'time',
	'tr',
	'uc',
	'use',
	'while',
);


sub main{
	
	print "start\n\n";
	
	
	#while(1){ print "".strTrim()."\n"; sleep 1; }
	
	permute();
	
	print "\n\nend\n";
	
}

sub permute{
	print "permute $0\n";
	
	my $s = '';
	
	#while(1){ print strRand(numberRand(1, 40))."\n"; }

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
	strTrim(\$s);
	
	
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
	
	#existrTrim();
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
	
	# Collect subs.
	my %subs = ();
	while($o3 =~ /sub ([a-z0-9_]+)/ig){
		my $subname = $1;
		strTrim(\$subname);
		
		
		if(!defined $subs{$subname}){
			#print "sub '$subname'\n";
			
			my $newname = 'sub_'.numberRand(100, 999).'_'.$subname.'_'.numberRand(100, 999);
			$subs{$subname} = {
				'name' => $subname,
				'newname' => $newname,
			};
			
			#$o3 =~ s/sub $subname/sub $newname/sg;
		}
	}
	
	# Collect variables.
	my %vars = ();
	while($o3 =~ /([\$\%\x40])([a-z0-9_]+)/ig){
		
		my $vartype = $1;
		my $varname = $2;
		
		if( ($vartype eq '$' && $varname =~ /[ab0-9]/) || ($varname eq '_') ){
			next;
		}
		
		if(!defined $vars{$varname}){
						
			my $newname = '';
			#$newname = 'var_'.numberRand(100, 999).'_'.$varname.'_'.numberRand(100, 999);
			$newname = 'var_'.numberRand(1, 9).'_'.$varname;
			$vars{$varname} = {
				'name' => $varname,
				'newname' => $newname,
				'type' => $vartype,
			};
		}
	}
	
	# Substitute subs.
	my @subskeys = keys %subs;
	print "subs ".@subskeys."\n";
	for my $subname (reverse sort{
		length($a) <=> length($b)
	} @subskeys){
		my $newname = $subs{$subname}{'newname'};
		
		
		$o3 =~ s/sub $subname/sub $newname/g;
		print "sub1 'sub $subname' 'sub $newname'\n";
		
		$o3 =~ s/$subname\(/$newname\(/g;
		#print "sub1 '$subname(' '$newname('\n\n";
		
	}
	
	# Substitute variables.
	my @varskeys = keys %vars;
	print "vars ".@varskeys."\n";
	for my $varname (reverse sort{
		length($a) <=> length($b)
	} @varskeys){
		my $newname = $vars{$varname}{'newname'};
		my $vartype = $vars{$varname}{'type'};
		
		if($vartype eq '%'){
			$o3 =~ s/\$$varname\{/\$$newname\{/sg;
			#print "var1 $vartype '\$$varname\{' '\$$newname\{'\n";
		}
		$o3 =~ s/\Q$vartype\E$varname/$vartype$newname/sg;
		print "var1 $vartype '$vartype$varname' '$vartype$newname'\n";
		
		#print "$o3\n\n"; sleep 1;
	}
	#replacePvarsAndLvars(\$o3, \%vars);
		
	#$o3 =~ s/;/;\n/sg;
	#$o3 =~ s/\}/\}\n/sg;$o3 =~ s/\{/\{\n/sg;
	#$o3 =~ s/(sub [0-9a-z]+)/\n\n\n$1/sig;
	
	#$s =~ s/\r//sg;$s =~ s/\n//sg;
	
	#print "\n\nout\n$o3\n";
	
	my $f = $0.'.pl';
	fileWrite($f, "\x23!/usr/bin/perl -w\n\x23 Created by TheFox\x40fox21.at\n\x23 ".time()."\n\n".$o3);
	chmod 0755, $f;
	
	$f;
}

# Read a file
sub fileRead{
	my($f) = @_;
	my $s = '';
	
	open F, '<', $f;
	$s = join '', <F>;
	close F;
	
	$s;
}

# Write a file
sub fileWrite{
	my($f, $c) = @_;
	open F, '>', $f;
	print F $c;
	close F;
}

# Random number: min, max
sub numberRand{
	my($mi, $ma) = @_;
	int($mi + int rand($ma - $mi + 1));
}

# Random string
sub strRand{
	my($len) = @_;
	my $rv = '';
	
	my $nlen = $len;
	$nlen--;
	$rv .= chr((numberRand(1, 1000) <= 800 ? 97 : 65) + int rand 26);
	
	for(my $n = 0; $n < $nlen; $n++){
		$rv .= numberRand(1, 1000) <= 900 ? chr((numberRand(1, 1000) <= 800 ? 97 : 65) + int rand 26) : numberRand(1, 9);
	}
	
	
	if(grep{ $rv =~ /$_/i } @bl){
		$rv = strRand($len);
	}
	
	$rv;
}

# Trim String
sub strTrim{
	my($r) = @_;
	
	$$r =~ s/^ +//s;
	$$r =~ s/ +$//s;
	
	$$r =~ s/^\n+//s;
	$$r =~ s/\n+$//s;
}

# Merge two hashes to one
sub hashMerge{
	my($hr1, $hr2) = @_;
	my %rv222 = ();
	
	for my $hr ($hr1, $hr2){
		if(defined $hr){
			my %h = %{$hr};
			for my $k (keys %h){
				$rv222{$k} = $h{$k};
			}
		}
	}
	
	%rv222;
}



main();





# EOF
