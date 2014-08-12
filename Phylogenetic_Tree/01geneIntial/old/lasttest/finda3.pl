#!/usr/bin/perl 
use strict;
use warnings;
use File::Find;

my $path="/Users/ZhiAnJu/workspace/bioinfo/test/";
my $filenum;
my @filedir;
my $i=0;
my @a;
my @fileout=qw( DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
my $str="";
################ find dir  ##########
sub wanted{
	if(-f $_ && $_ =~ /mavid.mfa/){
	$filedir[$i]=$File::Find::name;
	$i++;
	} 
}
find(\&wanted, $path);
$filenum=@filedir;
print"$filenum\n";
################  建立搜索规则   ########### 
for ($i=0;$i<$filenum;$i++){
#print"$filedir[$i]\n";
open IN, "<$filedir[$i]" || die "error: can't open infile: $filedir[$i]";
open OUT1, ">/Users/ZhiAnJu/workspace/bioinfo/output/"."$fileout[0]".".bat" || die "can't open it\n";
=cut
foreach (my $line = IN){
    if($line=~/A.*T/s){
	(my $copy = $1)=~ s/\s+//g;
	push @a,$copy;
    }
	print "$_\n" for @a;
}
my $b=@a;
print "num is $b\n";
#print OUT1 "$a[1]";
=cut
undef $/;
my $content = <IN>;
#print "$content";
if($content =~ m/>DroMel.*>/s){
my $temstr = $&;
chop $temstr;
$str .= $temstr ;
#print "$str";
#print OUT1 "$&";
}
}
print "$str\n";
print OUT1 "$str\n";
close IN;
close OUT1;

