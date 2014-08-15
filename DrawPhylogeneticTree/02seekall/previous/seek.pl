#!/uer/bin/perl

#use strict;
use warnings;

my $inpath="/Users/ZhiAnJu/workspace/bioinfo/output/2/";   #dir to input, chane it when you use different equipment; 
my $outpath="/Users/ZhiAnJu/workspace/bioinfo/output/seekout/";#dir to output;
my @input=qw(DroMel DroSim DroSec DroYak DroEre DroAna DroPse DroPer DroWil DroMoj DroVir DroGri);
my $filelength=@infile;
print "number is $filelength\n";
############# whole scale data
my %alltag = ();
my %allsite = ();
my %num = ();
my @tagsiteli = [];
my @tagidli = [];
my $tagid = 0;
my ($aaa,$bbb);
my @aa;
my @bb;

############# whole loop
for (my $i=0;$i<$filelength;$i++){
my $str = "";
my $basenum = "";
print "copy genome sequence...\nfile:$input[$i]\n";
open IN,"<$inpath"."$input[$i]".".mfa" or die "Can't open input file: $!";
	foreach(<IN>){
		unless(/>$input[$i]_CAF\d+/){
		chomp;
		$str .= $_;
		}
	}

close IN;

############## enzyme info ######
my $bsaxi1 = "[A-Z]{8}AC[A-Z]{5}CTCC[A-Z]{6}";
my $bsaxi2 = "[A-Z]{6}GGAG[A-Z]{5}GT[A-Z]{8}";
my $bsaxilen =25;
############## extract tags
open OUT,">"."$outpath"."seek-repeat/"."$infile[$i]"."fa";
seekstag($bsaxi1,$bsaxilen);
seeksrevtag($bsaxi2,$bsaxilen);
close OUT;

sub seekstag(){
my $mode = $_[0];
my $len = $_[1];
my $pos;
my $startpoint;
my $tag;
my $oldid;
$oldid = $tagid;
print "subfunction: $mode..$len\n";
while (($str=~ /$mode/g)){
	$pos=pos($str);
	$startpoint = $pos - $len;
	$tag= substr($str,$startpoint,$len);
	$startpoint++;
	if(length($tag) >= $len){
		$tagid++;
		unless(/N/){
			print OUT ">"."$infile[$i]"."_tag"."$tagid\n$tag\n";
			$alltag{$tagid}=$tag;
			$allsite{$tagid}=$startpoint;
			$num{$tag}++;
			}	

		}		
	}
	@aa=keys %alltag; @bb=keys %allsite;
	$aaa=@aa;$bbb=@bb;
	print"loop: $tagid $aaa $bbb\n";

}

sub seeksrevtag(){

my $mode = $_[0];
my $len = $_[1];
my $pos;
my $startpoint;
my ($tag,$seq);
my $oldid;
$oldid = $tagid;
print "subfunction: $mode..$len\n";
while(($str =~ /$mode/g)){
	$pos = pos($str);
	$startpoint = $pos - $len;
	$tag = substr($str,$startpoint,$len);
	$seq = reverse $tag;
	$seq =~ tr/ACGTacgt/TGCAtgca/;     
	$startpoint++;
    	if(length($tag) >= $len){
        	$tagid++;
        	unless(/N/){
         		print OUT ">"."$infile[$i]"."_revtag"."$tagid\n$seq\n";
          		$alltag{$tagid} = $seq;
          		$allsite{$tagid} = $startpoint;
          		$num{$seq}++;
       			}
   		 }
	}
        @aa=keys %alltag; @bb=keys %allsite;
        $aaa=@aa;$bbb=@bb;
        print"loop: $tagid $aaa $bbb\n";

}


} #end os whole loop, don't delete
