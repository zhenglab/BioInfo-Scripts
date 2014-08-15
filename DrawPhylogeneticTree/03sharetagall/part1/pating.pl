#!/usr/bin/perl
use strict;
use warnings;

my $inpath="/Users/ZhiAnJu/workspace/parting/";   #dir to input, chane it when you use different equipment; 
my $outpath="/Users/ZhiAnJu/workspace/parting/output/";#dir to output;

open OUT, ">"."$outpath"."step1.tsv" || die "$!";
open IN, "<"."$inpath"."allinone.tags.tsv" || die "$!";
my @spe=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
my $k=@spe;
print "$k\n";
my $i=0;
foreach(<IN>){
my $str=$_;
if (/.+consensus.+/){
$str=~ s/.+consensus/>$i consensus/;
$str=~ s/\W\d\W\d\W\d//;
$i++;
}
#{$str=substr($str,11);}
else{
$str=~ s/\d\W\d\W\d+\W+//;
$str=~ s/model.+\n//;
}
#{$str=substr($str,9);}
print OUT "$str";
}
close IN;
close OUT;
my $num=$i;
print "$num\n";
open IN, "<"."$outpath"."step1.tsv" || die "$!";
undef $/;
my $content=<IN>;
close IN;
open OUT,">"."$outpath"."step2.tsv" || die "$!";
#print "$content\n";
$content .=">$num";
my $str;
my $find=1;
for ($i=0;$i<$num;$i++){
	my $j=$i+1;
	if($content =~ />$i[\s\w]+>$j/s){
	$str = $&;
	#print OUT "$str\n";
	my $times;
		for (my $l=0;$l<$k;$l++){
			if($str=~/$spe[$l]/){
			$times++;
			}
		}
	if ($times>=$k){
		$find++;
		$str=~ s/>\d+//g;
		print OUT "$str";
		print "Find $find match.\n";
		}
	}
}
close OUT;
