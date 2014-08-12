#!/usr/bin/perl 
#use strict;
#use warnings;
use File::Find;
use Sort::Naturally;

my $inpath="/Users/ZhiAnJu/workspace/bioinfo/fly_CAF1.1/alignments/";#输入路径
my $outpath="/Users/ZhiAnJu/workspace/bioinfo/output/1/";#输出路径
my ($filenum,$spenum);
my (@filedir,@dirsort);
my $i=0;
my $j=0;
my @fileout=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
$spenum = @fileout;
print"$spenum\n";
################ find dir  ##########
sub wanted{
	if(-f $_ && $_ =~ /mavid.mfa/){
	$dirsort[$i]=$File::Find::name;
	$i++;
	} 
}
find(\&wanted, $inpath);
@filedir=nsort @dirsort;
$filenum=@filedir;
print"Number of files is $filenum.\n";
################  建立输出文件   ###########
for ($j=0;$j<$spenum;$j++)
{
my $o="OUT".$j;
open $o,  ">"."$outpath"."$fileout[$j]".".mfa" || die "$!";
}
################  输入文件   ###########
for ($i=0;$i<$filenum;$i++){
print"$filedir[$i]\n";
open IN, "<"."$filedir[$i]" || die "error: can't open infile: $filedir[$i]";
###############  将文件内容复制到$content  ########
undef $/;
my $content = <IN>;
$content =~ tr/-\n/01/; #将所有的-和\n替换为0和1；
$content =~ s/(1+)/1/g; #将连续的换行符替换为1个；
$content .=">";
#print"$content\n"; 
#############   匹配输出 ##########
for ($j=0;$j<$spenum;$j++){
my $p="OUT".$j;
if($content =~ />$fileout[$j]\w*>/s){ #\w表示字母和数字，这样就不会忽略掉>了；
my $str = $&;
$str =~ tr/01/-\n/; #反替换回来
chop $str;
#print "$str";
print $p "$str";} 
}
}
############ 关闭文件句柄 #############
close IN;
for ($j=0;$j<$spenum;$j++){
my $o="OUT".$j;
close $o;
}
