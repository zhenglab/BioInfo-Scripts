#!/usr/bin/perl
use warnings;
use strict;

my (%h, $filename);
my $dirname="/Users/ZhiAnJu/workspace/bioinfo/test/2/";

opendir (DIR, $dirname)|| die "Error in opening dir $dirname\n";

while (($filename=readdir(DIR))){

         open (FILE, "</Users/ZhiAnJu/workspace/bioinfo/test/2/".$filename)|| die "can not open the file $filename\n";
         open (OUT, ">/Users/ZhiAnJu/workspace/bioinfo/test/2/$filename.bak")|| die "can not open the $filename.bak\n";

           while (<FILE>){
                  print  OUT "$_";

}
close OUT;
close FILE;
}
close DIR;
