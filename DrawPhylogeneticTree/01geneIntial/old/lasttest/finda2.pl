#!/usr/bin/perl 
#use strict;
use warnings;
use File::Find;

my $inpath="/Users/ZhiAnJu/workspace/bioinfo/fly_CAF1.1/alignments/";#输入文件目录
my $outpath="/Users/ZhiAnJu/workspace/bioinfo/output/1/";#输出文件目录
my ($filenum,$spenum);
my @filedir;
my $i=0;
my $j=0;
my @fileout=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
$spenum = @fileout;
print"species number is $spenum.\n";
################ find dir  ##########
sub wanted{
	if(-f $_ && $_ =~ /mavid.mfa/){
	$filedir[$i]=$File::Find::name;
	$i++;
	} 
}
find(\&wanted, $inpath);
$filenum=@filedir;
print"Number of files is $filenum.\n";
################  建立输出文件   ###########
for my $k (0..11)
{
my $o="OUT".$k;
open $o,  ">"."$outpath"."$fileout[$k]".".mfa" || die "$!";
}
################  建立搜索规则   ###########
for ($i=0;$i<$filenum;$i++){
#print"$filedir[$i]\n";
open IN, "<$filedir[$i]" || die "error: can't open infile: $filedir[$i]";
#open OUT1, ">/Users/ZhiAnJu/workspace/bioinfo/output/"."$fileout[0]".".bat" || die "$!";
###############  将文件内容复制到$content  ########
undef $/;
my $content = <IN>;
#############   匹配输出 ##########
for($j=0;$j<$spenum;$j++){
my $p="OUT".$j;
if($content =~ m/>$fileout[$j].*>/s){
my $str = $&;
chop $str;
chop $str;
print $p "$str";} 
}
}
close IN;
for my $l(0..11){
my $q="OUT".$l;
close $q;
}
