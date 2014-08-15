#!/usr/bin/perl 
use strict;
use warnings;
use File::Find;

my $path="/Users/ZhiAnJu/workspace/bioinfo/fly_CAF1.1/alignments/";
my $num;
my @dir;
my $i=0;

#find(\&wanted, $path);
sub wanted{
	if(-f $_ && $_ =~ /mavid.mfa/){
#	print"$_\n";
	$dir[$i]=$File::Find::name;
#	print"$dir[$i]\n";
	$i++;
} 
}
find(\&wanted, $path);
$num=@dir;
#sort@dir;
for($i=0;$i<$num;$i++){
print "$dir[$i]\n";
}
