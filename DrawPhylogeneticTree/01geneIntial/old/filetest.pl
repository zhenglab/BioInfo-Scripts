#!/usr/bin/perl -w
use strict;

my ($dirname, $filename);
my $dirnameaa;
my $dirname="/Users/ZhiAnJu/workspace/bioinfo/test/";

opendir (DIR, $dirname)|| die "Error in opening dir $dirname\n";

while (($dirnamea=readdir(DIR))){
	opendir (DIRA,$dirnamea)|| die "Erroe in opening dir $dianamea\n";
	while(($filenema=readdir(DIRA))){

         open (FILE, "<$dirname"."$dirnamea".$filename)|| die "can not open the file $filename\n";
         open (OUT, ">$dirname"."$dirnamea".$filename/$filename.bak")|| die "can not open the $filename.bak\n";

           while (<FILE>){
                  print  OUT "$_";

}
}
close OUT;
close FILE;
}
closedir (DIRA);
closedir(DIR); 
