#!/usr/bin/perl
use strict;
#use warnings;
use Sort::Naturally;

my $inpath="/Users/ZhiAnJu/workspace/Bioinfor/01genelntial/output/";   #dir to input, chane it when you use different equipment; 
my $outpath="/Users/ZhiAnJu/workspace/Bioinfor/output/02seekall/";#dir to output;
my $bsaxi1 = "[A-Z]{8}AC[A-Z]{5}CTCC[A-Z]{6}";
my $bsaxi2 = "[A-Z]{6}GGAG[A-Z]{5}GT[A-Z]{8}";
my $bsaxilen = 25;
#my $str="";
#my %alltag = ();
#my %num = ();
#my $tagid = 0;     
my ($aaa,$bbb);
my @aa;
my @bb;
my @input=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
my $inlength=@input;
print "Number of species is $inlength. \n";
my $i=0;
open OUT,">"."$outpath"."allinone.fa";  #only output one file;
for ($i=0;$i<$inlength;$i++){
	my %alltag = ();
	my %num = ();
	my $tagid = 0; 
	my $str="";
	my $indir="$inpath"."$input[$i]".".mfa";
	my $outdir="$outpath"."$input[$i]".".fa";
	open IN,"<$indir" or die "Can't open input file: $!";
	foreach (<IN>){
		unless (/>$input[$i]\w+/){
		chomp;
		$str .= $_;
		}
	}
	close IN;
	
	########## nonreverse ###########
	
	#open OUT,">$outdir" or die "Can't open input file: $!";  #out put different files;
	while($str =~ /$bsaxi1/g){
	my $pos = pos($str);
	my $startpoint = $pos - $bsaxilen;
	my $tag = substr($str,$startpoint,$bsaxilen);
	$startpoint++;
	if(length($tag) >= $bsaxilen){
		$tagid++;
		unless($tag =~ /N+/){
			#print OUT ">"."$input[$i]"."_tag"."$tagid\n$tag\n"; 
			$alltag{$tagid} = $tag;
			$num{$tag}++;
			}
		}
	}
	#@aa=keys %alltag;
	#$aaa=@aa;
	#print "loop $i: $tagid $aaa\n";
	
	##########  reverse ##########
	
	while($str =~ /$bsaxi2/g){
	my $pos = pos($str);
	my $startpoint = $pos - $bsaxilen;
	my $tag = substr($str,$startpoint,$bsaxilen);
	my $seq = reverse $tag;
	$seq =~ tr/ACGTacgt/TGCAtgca/;
	$startpoint++;
	if(length($seq) >= $bsaxilen){
		$tagid++;
		unless($seq =~ /N+/){
			#print OUT ">"."$input[$i]"."_revtag"."$tagid\n$seq\n";
			$alltag{$tagid} = $seq;
			$num{$seq}++;
			}
		}
	}
	@bb=keys %alltag;
	$bbb=@bb;
	print "loop $i: $tagid $bbb.\n";
	#close OUT;	
	
	########## get rid of repeat ##########
	
	my ($key,$value);
	my %singletag = ();
	foreach $key(nsort keys %alltag){
	$value=$alltag{$key};
	if($num{$value} == 1 ){
		$singletag{$key} = $value;
		print OUT ">"."$input[$i]"."_tag"."$key\n$value\n";
		}
	}
	my $ccc=keys %singletag;
	print "number of nonrepeat is $ccc.\n";
}
close OUT;