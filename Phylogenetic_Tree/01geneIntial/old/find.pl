#!/usr/bin/perl 
use strict;
use warnings;
use File::Find;

my $path="/Users/ZhiAnJu/workspace/bioinfo/test/";
my @name;

find(\&wanted, $path);
sub wanted{
# if (-f $File::Find::name){
	#for(my $i=0;;$i++){
	#	$name[$i]=$File::Find::name;
	#	print"@name[$i]\n";
	#	}
	#my $num=@name;
	#print"$num\n";
#	print"$File::find::name\n";
#	}
-f $_ && print "$File::Find::name\n";
} 

