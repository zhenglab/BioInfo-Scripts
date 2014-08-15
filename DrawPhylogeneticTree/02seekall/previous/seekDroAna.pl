#extract tags from genome sequence and all tags to *--totaltags.dat and unique tags to *-tags
use strict;

my $input = "DroAna.mfa";
#sub seekstag();
#sub seeksrevtag();
############copy genome sequence
my $str = "";
my $basenum = 0;
print "copy genome sequence...\nfile: $input\n";
open IN,"<$input" or die "Can't open input file: $!";
foreach (<IN>){
    unless(/>DroAna_CAF\d+/){
    	chomp;
    #	chop;
	$str .= $_;
    }
}
close(IN);
$basenum = length($str);
print "total base number: $basenum" . "bp\ncopy complete.\n";

############enzyme info
my $bsaxi1 = "[A-Z]{8}AC[A-Z]{5}CTCC[A-Z]{6}";
my $bsaxi2 = "[A-Z]{6}GGAG[A-Z]{5}GT[A-Z]{8}";
my $bsaxilen = 25;
print "enzyme BsaXI.upper site: $bsaxi1\tlower site: $bsaxi2\tlength: $bsaxilen\n";

my $fspei1 = "[A-Z]{9}CCTGG[A-Z]{9}";      #len = 23
my $fspei2 = "[A-Z]{9}CCAGG[A-Z]{9}";      #len = 23
my $fspeilen12 = 23;
my $fspei3 = "[A-Z]{10}CCGG[A-Z]{10}";     #len = 24
my $fspeilen3 = 24;
print "enzyme FspEI.site1: $fspei1\t$fspeilen12\tsite2: $fspei2\tlength: $fspeilen12\tsite3: $fspei3\tlength: $fspeilen3\n";

############whole scale data
my %alltag = ();
my %allsite = ();
my %num = ();
my @tagsiteli = [];
my @tagidli = [];
my $tagid = 0;     
my ($aaa,$bbb);
my @aa;
my @bb;

############extract tags
open OUT,">bsaxi--tagsall.dat";
#print OUT "total base number: $basenum" . "bp\n\n";
#BsaXI upper
#print OUT "upper site: ";
#print  "BsaXI upper site...\n";
seekstag($bsaxi1,$bsaxilen);
#BsaXI lower
#print OUT "lower site: ";
#print  "BsaXI lower site...\n";
seeksrevtag($bsaxi2,$bsaxilen);
close OUT;

open OUT,">fspei--tagsall.dat";
print OUT "total base number: $basenum" . "bp\n\n";
#FspEI 1
print OUT "site1: ";
print  "FspEI site1...\n";
seeksrevtag($fspei1,$fspeilen12);
#FspEI 2
print OUT "site2: ";
print  "FspEI site2...\n";
seekstag($fspei2,$fspeilen12);
#FspEI 3
print OUT "site3: ";
print  "FspEI site3...\n";
seekstag($fspei3,$fspeilen3);
close OUT;

=A
open OUT,">num";
foreach $aaa(keys %num){
	if($aaa =~ /$bsaxi1/){
		print OUT "$aaa\t$num{$aaa}\n";
	}
}
@aa = keys %num;
$aaa = @aa;
print "num: $aaa..\n";
=cut		

############get rid of repeat
print "don't have repeats...\n";
my $c = 1;     #all tags num including repeats #debug variable
my $d = 1;     #all tags num excluding repeats #debug variable
my $bsa = 1;   #bsa tags num excluding repeats #debug variable
my ($key,$value);
my %singletag = ();
my %singlesite = ();
foreach $key(keys %alltag){
	$c++;
	$value = $alltag{$key};
	if($num{$value} == 1){
		$d++;if($value =~ /$bsaxi1/){$bsa++;}
		$singletag{$key} = $value;              #tagid-tagseq
		$singlesite{$key} = $allsite{$key};     #tagid-tagsite
	}
}
print "all: $c single: $d bsaxi: $bsa\n";
@aa = keys %alltag;@bb = keys %allsite;     #debug output
$aaa = @aa;$bbb = @bb;
print "all: $aaa..$bbb..\n";
@aa = keys %singletag;@bb = keys %singlesite;
$aaa = @aa;$bbb = @bb;
print "single: $aaa..$bbb..over.\n";        #debug output

############sort tags by startsite @tagseqli,@tagsiteli is the array
print "sort tags...\n";
@tagsiteli = sort {$a <=> $b} values %singlesite;               #tagsite
@tagidli = sort {$singlesite{$a} <=> $singlesite{$b}} keys %singlesite;     #tagid
my $lena = @tagsiteli;
my $lenb = @tagidli;
print "sum number of total single tags: $lena,$lenb\n";

############generate sorted tags file
my ($i,$j,$j1,$j2);
open OUT1,">bsa-tags";
open OUT2,">fsp-tags";
open OUT,">all-tags";

print "generating sorted tags file: bsa-tags fsp-tags all-tags\n";
for($i = 0;$i < $lena;$i++){
	$lenb = @tagidli[$i];     #tagid
	$value = $singletag{$lenb};     #tagseq
	#print "$value\n";sleep 1;
	if($value =~ /$bsaxi1/){
		$j1++;print OUT1 "$j1\t$value\t@tagsiteli[$i]\n";
	}
	else{
		$j2++;print OUT2 "$j2\t$value\t@tagsiteli[$i]\n";
	}
	$j++;print OUT "$j\t$value\t@tagsiteli[$i]\n";
}
close OUT;
close OUT1;
close OUT2;
print "complete.\n";

############subfunction  $mode,$len
sub seekstag(){
my $mode = @_[0];
my $len = @_[1];
my $pos;
my $startpoint;
my $tag;
my ($tagsum,$oldid);
$oldid = $tagid;
print "subfunction: $mode..$len\n";
#print OUT "$mode\n";
#print OUT "tag number\tsequence\tstartpoint\n";
while(($str =~ /$mode/g)){
    $pos = pos($str);
    $startpoint = $pos - $len;
    $tag = substr($str,$startpoint,$len);
    $startpoint++;
    if(length($tag) >= $len){
        $tagid++;    #    
	unless(/N/){     #
          print OUT ">DroAna_tag" . "$tagid\n$tag\n";
          $alltag{$tagid} = $tag;             #
	  $allsite{$tagid} = $startpoint;     #
          $num{$tag}++;                       #
        }
    }
}
$tagsum = $tagid - $oldid;
#print OUT "total tags: $tagsum";               #
#print OUT "\n\n";
@aa = keys %alltag;@bb = keys %allsite;
$aaa = @aa;$bbb = @bb;
print "loop: $tagid $aaa $bbb\n";
}

sub seeksrevtag(){
my $mode = @_[0];
my $len = @_[1];
my $pos;
my $startpoint;
my ($tag,$seq);     #
my ($tagsum,$oldid);
$oldid = $tagid;
print "subfunction: $mode..$len\n";
#print OUT "$mode\n";
#print OUT "tag number\tsequence\tstartpoint\n";
while(($str =~ /$mode/g)){
    $pos = pos($str);
    $startpoint = $pos - $len;
    $tag = substr($str,$startpoint,$len);
    $seq = reverse $tag;     #
    $seq =~ tr/ACGTacgt/TGCAtgca/;     #
    $startpoint++;
    if(length($tag) >= $len){
        $tagid++;        
	unless(/N/){
          print OUT ">DroAna_revtag" . "$tagid\n$seq\n";
          $alltag{$tagid} = $seq;             
	  $allsite{$tagid} = $startpoint;
          $num{$seq}++;     
        }
    }
}
$tagsum = $tagid - $oldid;
#print OUT "total tags: $tagsum";
#print OUT "\n\n";
@aa = keys %alltag;@bb = keys %allsite;
$aaa = @aa;$bbb = @bb;
print "loop: $tagid $aaa $bbb\n";
}





