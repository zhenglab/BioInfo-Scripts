#!/usr/bin/perl
use strict;
use warnings;

my $inpath="/Users/ZhiAnJu/workspace/parting/output/step2.tsv";   #dir to input, chane it when you use different equipment; 
my $outpath="/Users/ZhiAnJu/workspace/parting/output2/";#dir to output;

my @spe=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
my $k=@spe;
my @matrix;
print "There are $k species.\n";
###########加上>标记，便于下一步匹配########
open IN, "<$inpath"|| die "$!";
open OUT,">"."$outpath"."step1.tsv"||die "$!";
my $i=0;
foreach (<IN>){
my $str=$_;
	if (/.*consensus.+/){
	$str=~s/.*consensus/>$i consensus/;
	$i++;
	}
	print OUT "$str";
}
close IN;
close OUT;
my $num=$i;
print "$num\n";
##########输入文件，并加上标记#########
open IN,"<"."$outpath"."step1.tsv"|| die "$!";
undef $/;
my $content=<IN>;
close IN;
$content .=">$num";
##########计算矩阵##########
open OUT,">"."$outpath"."step2.tsv" || die "$!";
for($i=0;$i<$num;$i++){
	my $j=$i+1;
	if($content =~ />$i[\s\w]+>$j/s){
	my $str=$&;
		for(my $l=0;$l<$k;$l++){
		$matrix[$l][$i]=$str =~ s/$spe[$l]/$spe[$l]/g;
		}
	}
}
my $data=1;
for (my $i=0;$i<$k;$i++){
	print OUT "$spe[$i]:\t";
	my $a=1;
	for (my $j=0;$j<$num;$j++){
	print OUT "$matrix[$i][$j]\t";
	$a=$a*($matrix[$i][$j]);
	}
	print "$a\n";
	$data=$a*$data;
	print "$data\n";
	print OUT "\n";
}
#print "$data\n";
close OUT;
##########输出第一个组成测矩阵##########
open OUT,">"."$outpath"."step3.tsv" || die "$!";
for($i=0;$i<$k;$i++){
	print OUT "$spe[$i]:\t";
	for (my $m=0;$m<$num;$m++){
	my $n=$m+1;
		if($content =~ />$m[\s\w]+>$n/s){
		my $str=$&;
			if($str=~/.*$spe[$i]\w+\s[A-Z]{25}/){
			my $sss=$&;
				if($sss=~/[A-Z]{25}/){
				my $aaa =$&;
				print OUT "$aaa";
				}
			}
		}
	}
	print OUT "\n";
}