#!/usr/bin/perl -w
# Created @ 21.01.2012 by TheFox@fox21.at
# Polymorphic Perl Script
# Version: 1.1.0
# Generation: 0

use strict;
#use Time::HiRes qw(usleep);

$| = 1;


# Hex chars
# # = 23
# { = 7b
# } = 7d
# ; = 3b
# \n = 0a
# a = 61


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
	
	permute();
	
	print "\n\nend\n";
	
}

sub permute{
	print "permute $0\n";
	
	my $source = '';

	### CUT ###
	$source = '#!/usr/bin/perl -w
		# created



use strict;
$| = 1;

sub main{

numberRand(1, 1000) <= 500;
numberRand(1, 9999) <= 5000;


}

sub x9999{
	
}

x9999();

	';
	### CUT ###
	
	
	$source = fileRead($0);
	strTrim(\$source);
	
	# Read row by row.
	my $generation = 0;
	my $out = '';
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
				elsif($row =~ /G\x65n\x65ration: (\d+)/){
					$generation = 1 + int $1;
				}
			}
		}
		
	}
	print "genera\x74\x69on: $generation\n";
	
	
	
	
	# Collect subs.
	my %subs = ();
	while($out =~ /sub ([a-z0-9_]+)/ig){
		my $subname = $1;
		strTrim(\$subname);
		
		if($subname ne '' && !defined $subs{$subname}){
			#print "sub '$subname'\n";
			
			my $newname = '';
			#$newname = 'sub_'.numberRand(100, 999).'_'.$subname.'_'.numberRand(100, 999);
			$newname = strRand(numberRand(3, 64));
			$subs{$subname} = {
				'name' => $subname,
				'newname' => $newname,
				'content' => '',
				'mixpair' => '',
			};
			
		}
	}
	
	# Collect variables.
	my %vars = ();
	while($out =~ /([\$\%\x40])([a-z0-9_]+)/ig){
		
		my $vartype = $1;
		my $varname = $2;
		
		if( length $varname <= 2){
			#print "skip var: '$vartype' '$varname' \n";
			next;
		}
		
		if(!defined $vars{$varname}){
						
			my $newname = '';
			#$newname = 'var_'.numberRand(100, 999).'_'.$varname.'_'.numberRand(100, 999);
			#$newname = 'var_'.numberRand(100, 999).'_'.$varname;
			$newname = strRand(numberRand(3, 64));
			$vars{$varname} = {
				'name' => $varname,
				'newname' => $newname,
				'type' => $vartype,
			};
			
		}
		
	}
	
	# Mix subs
	my $out3 = '';
	my $level = 0;
	my $thisSubName = '';
	
	while(length $out > 0){
		my $char = substr $out, 0, 1;
		
		# {
		if($char eq "\x7b"){
			$level++;
			if($level == 0){
				$out = substr $out, 1;
				next;
			}
		}
		# }
		elsif($char eq "\x7d"){
			$level--;
			
			if($level == 0){
				if($thisSubName ne ''){
					$subs{$thisSubName}{'content'} .= $char;
				}
				$thisSubName = '';
				
				$out = substr $out, 1;
				next;
			}
		}
		
		if($level == 0){
			if($out =~ /^(sub [a-z0-9_]+[^\x7b]*\x7b)/i){
				$level++;
				
				my $substr = $1;
				
				$out = substr $out, length($1);
				
				if($substr =~ /^sub ([a-z0-9_]+)[^\x7b]*\x7b/i){
					$thisSubName = $1;
					$out3 .= "\x23\x23\x23SUB_".$thisSubName."\x23\x23\x23";
					
				}
				
				$subs{$thisSubName}{'content'} .= $substr;
				
				next;
			}
		}
		
		if($thisSubName ne ''){
			$subs{$thisSubName}{'content'} .= $char;
			
			# ; { }
			if($char =~ /[\x3b\x7b\x7d]/ && numberRand(1, 1000) <= 500){
				$subs{$thisSubName}{'content'} .= "\n";
			}
			
		}
		else{
			$out3 .= $char;
		}
		
		#print "out '".."'\n";
		$out = substr $out, 1;
		
	}
	
	
	
	my %newsubs = %subs;
	my $maxkeys = keys %newsubs;
	for my $subname ( sort{$a cmp $b} keys %subs){
		my $cont = $subs{$subname}{'content'};
		
		my $mixpairc = 0;
		while($subs{$subname}{'mixpair'} eq ''){
			my $r = numberRand(1, $maxkeys);
			
			
			my $subc = 0;
			for my $subname2 (keys %subs){
				$subc++;
				#print "\t\tsubname2 '$subname2' $subc\n";
				if($subc == $r){
					#print "\t\t\tsubname2 ok '$subname2' $subc\n";
					if($subs{$subname2}{'mixpair'} eq ''){
						$subs{$subname}{'mixpair'} = $subname2;
						$subs{$subname2}{'mixpair'} = $subname;
					}
					last;
				}
			}
			
			$mixpairc++;
			#print "\tmixpair $mixpairc '".$subs{$subname}{'mixpair'}."' \n";
			
			#sleep 1;
		}
		
		#print "sub '$subname' => '".$subs{$subname}{'mixpair'}."' \n";
		
		my $pair = $subs{$subname}{'mixpair'};
		$out3 =~ s/\x23\x23\x23SUB_$pair\x23\x23\x23/$cont/s;
		
	}
	
	
	#print "\nout\n$out3\n\n\n";exit(1);
	
	
	
	
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
	}
	
	# Substitute variables.
	my @varskeys = keys %vars;
	print "\nvars ".@varskeys."\n";
	for my $varname (reverse sort{
		length($a) <=> length($b)
	} @varskeys){
		my $newname = $vars{$varname}{'newname'};
		my $vartype = $vars{$varname}{'type'};
		
		$out3 =~ s/([\$\%\x40])$varname/$1$newname/sg;
		
		print "var $vartype '$vartype$varname' '$vartype$newname'\n";
		
	}
	
	# Mix numberz
	my @numbers = ();
	while($out3 =~ /[^\d]([0-9]{3,4})[^\d]/g){
		my $num = $1;
		if(!grep{$_ == $num} @numbers){
			my $numLen = length $num;
			my $min = '1'.('0' x ($numLen - 1));
			my $max = '9' x $numLen;
			my $newnum = numberRand($min, $max);
			
			push @numbers, $newnum;
			$out3 =~ s/$num/$newnum/sg;
			
		}
	}
	
	# Mix \n and \n
	numberRand(1, 1000) <= 500 ? $out3 =~ s/\\x0a/\\n/sg : $out3 =~ s/\\n/\\x0a/sg;
	numberRand(1, 1000) <= 500 ? $out3 =~ s/\\x09/\\t/sg : $out3 =~ s/\\t/\\x09/sg;
	
		
	#$out3 =~ s/;/;\n/sg;$out3 =~ s/\}/\}\n/sg;$out3 =~ s/\{/\{\n/sg;
	#$out3 =~ s/(sub [0-9a-z]+)/\n\n\n$1/sig;
	
	
	#print "\n\nout\n$out3\n";
	
	my $outPath = $0.'.pl';
	fileWrite($outPath, "\x23!/usr/bin/perl -w\n\x23 Created by TheFox\x40fox21.at\n\x23 Gener\x61tion: $generation\n\x23 ".time()."\n\n".$out3);
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
		return "TheFoxStrikesB\x61ck".numberRand(1, 999);
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
	
	$$strRef =~ s/^\t+//s;
	$$strRef =~ s/\t+$//s;
	
	$$strRef =~ s/\r//sg;
	
}



main();


# EOF
