#!/usr/bin/perl -w
# Created @ 21.01.2012 by TheFox@fox21.at
# Polymorphic Perl Script
# Version: 0.2.0

use strict;

$| = 1;


# Hex chars
# # = 23
# { = 7b
# } = 7d



# Variable blacklist
my @nameBlacklist = (
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
	
	my $source = '';
	
	#while(1){ print strRand(numberRand(1, 40))."\n"; }

	### CUT ###
	$source = '#!/usr/bin/perl -w
		# created



use strict;
$| = 1;

my $x = 0;
print "\t$x\n";

	';
	### CUT ###
	
	
	
	$source = fileRead($0);
	#$source = fileRead($0.'.pl');
	
	
	my $out = '';
	
	
	
	strTrim(\$source);
	
	
	# Read row by row.
	my $rowCounter = 0;
	my $cutter = 0;
	my @rows = split /\n/, $source;
	for my $row (@rows){
		$rowCounter++;
		
		if($rowCounter > 2){
			$row =~ s/^[ \t]+//;
			if($row =~ /\x23 CUT \x23/){
				$cutter = !$cutter;
			}
			if(!$cutter){
				if($row ne '' && $row !~ /^\x23/){
					
					#if($row !~ / $/){ $row .= ' '; }
					
					$out .= $row;
				}
			}
		}
	}
	
	#existrTrim();
	#print "\n\n";
	
	
	
	my $out3 = $out;
	#$out3 = cmdsexec($out2);
	
	# Collect subs.
	my %subs = ();
	while($out3 =~ /sub ([a-z0-9_]+)/ig){
		my $subname = $1;
		strTrim(\$subname);
		
		
		if(!defined $subs{$subname}){
			#print "sub '$subname'\n";
			
			my $newname = '';
			#$newname = 'sub_'.numberRand(100, 999).'_'.$subname.'_'.numberRand(100, 999);
			$newname = strRand(numberRand(2, 128));
			$subs{$subname} = {
				'name' => $subname,
				'newname' => $newname,
			};
			
			#$out3 =~ s/sub $subname/sub $newname/sg;
		}
	}
	
	# Collect variables.
	my %vars = ();
	while($out3 =~ /([\$\%\x40])([a-z0-9_]+)/ig){
		
		my $vartype = $1;
		my $varname = $2;
		
		#print "var coll: '$vartype' '$varname' \n";
		
		#if( ($vartype eq '$' && $varname =~ /^[ab0-9]$/) || $varname eq '_' || $varname eq '|' ){
		if( length $varname <= 2){
			print "skip var: '$vartype' '$varname' \n";
			next;
		}
		
		if(!defined $vars{$varname}){
						
			my $newname = '';
			#$newname = 'var_'.numberRand(100, 999).'_'.$varname.'_'.numberRand(100, 999);
			#$newname = 'var_'.numberRand(100, 999).'_'.$varname;
			$newname = strRand(numberRand(2, 128));
			$vars{$varname} = {
				'name' => $varname,
				'newname' => $newname,
				'type' => $vartype,
			};
			
			#print "\t\t\t\t\tnew: $newname\n";
		}
		#else{ print "\told: $vars{$varname}{'newname'}\n"; }
		#print "\n";
		
		#sleep 1;
	}
	print "\n";
	
	# TODO: Mix subs
	
	# Substitute subs.
	my @subskeys = keys %subs;
	print "\nsubs ".@subskeys."\n";
	for my $subname (reverse sort{
		length($a) <=> length($b)
	} @subskeys){
		my $newname = $subs{$subname}{'newname'};
		
		
		$out3 =~ s/sub $subname/sub $newname/g;
		print "sub1 'sub $subname' 'sub $newname'\n";
		
		$out3 =~ s/$subname\(/$newname\(/g;
		#print "sub1 '$subname(' '$newname('\n\n";
		
	}
	
	# Substitute variables.
	my @varskeys = keys %vars;
	print "\nvars ".@varskeys."\n";
	for my $varname (reverse sort{
		length($a) <=> length($b)
	} @varskeys){
		my $newname = $vars{$varname}{'newname'};
		my $vartype = $vars{$varname}{'type'};
		
		#if($vartype eq '%'){
		#	$out3 =~ s/\$$varname\{/\$$newname\{/sg;
		#	print "var $vartype '\$$varname\{' '\$$newname\{'\n";
		#}
		#$out3 =~ s/\Q$vartype\E$varname/$vartype$newname/sg;
		
		$out3 =~ s/([\$\%\x40])$varname/$1$newname/sg;
		
		print "var $vartype '$vartype$varname' '$vartype$newname'\n";
		
		#print "$out3\n\n"; sleep 1;
	}
	#replacePvarsAndLvars(\$out3, \%vars);
	
	
	numberRand(1, 9999) >= 5000 ? $out3 =~ s/\\x0a/\\n/sg : $out3 =~ s/\\n/\\x0a/sg;
	numberRand(1, 9999) >= 5000 ? $out3 =~ s/\\x09/\\t/sg : $out3 =~ s/\\t/\\x09/sg;
	
		
	#$out3 =~ s/;/;\n/sg;$out3 =~ s/\}/\}\n/sg;$out3 =~ s/\{/\{\n/sg;
	#$out3 =~ s/(sub [0-9a-z]+)/\n\n\n$1/sig;
	
	#$source =~ s/\r//sg;$s =~ s/\n//sg;
	
	#print "\n\nout\n$out3\n";
	
	my $outPath = $0.'.pl';
	fileWrite($outPath, "\x23!/usr/bin/perl -w\n\x23 Created by TheFox\x40fox21.at\n\x23 ".time()."\n\n".$out3);
	chmod 0755, $outPath;
	
	$outPath;
}

# Read a file
sub fileRead{
	my($path) = @_;
	my $content = '';
	
	open F, '<', $path;
	$content = join '', <F>;
	close F;
	
	$content;
}

# Write a file
sub fileWrite{
	my($path, $content) = @_;
	open F, '>', $path;
	print F $content;
	close F;
}

# Random number: min, max
sub numberRand{
	my($min, $max) = @_;
	int($min + int rand($max - $min + 1));
}

# Random string
sub strRand{
	my($len, $level) = @_;
	if(!defined $level){
		$level = 0;
	}
	if($level >= 98){
		return 'TheFoxStrikesBack';
	}
	
	my $retVal = '';
	
	my $nlen = $len;
	$nlen--;
	
	# Sub names can't have a number at the first char.
	$retVal .= chr((numberRand(1, 1000) <= 800 ? 97 : 65) + int rand 26);
	
	for(my $counter = 0; $counter < $nlen; $counter++){
		$retVal .= numberRand(1, 1000) <= 900 ? chr((numberRand(1, 1000) <= 800 ? 97 : 65) + int rand 26) : numberRand(1, 9);
	}
	
	
	if(grep{ $retVal =~ /$_/i } @nameBlacklist){
		$retVal = strRand($len, $level + 1);
	}
	
	$retVal;
}

# Trim String
sub strTrim{
	my($strRef) = @_;
	
	$$strRef =~ s/^ +//s;
	$$strRef =~ s/ +$//s;
	
	$$strRef =~ s/^\n+//s;
	$$strRef =~ s/\n+$//s;
	
	$$strRef =~ s/\r//sg;
	
}

# Merge two hashes to one
sub hashMerge{
	my($hashref1, $hashref2) = @_;
	my %retVal = ();
	
	for my $hashref ($hashref1, $hashref2){
		if(defined $hashref){
			my %hash = %{$hashref};
			for my $key (keys %hash){
				$retVal{$key} = $hash{$key};
			}
		}
	}
	
	%retVal;
}


main();


# EOF
