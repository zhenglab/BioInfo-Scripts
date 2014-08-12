#!/usr/bin/perl -w
$dirname = "/Users/ZhiAnJu/workspace/bioinfo/test";
opendir(DIR,$dirname)||die "Errot in opening dir $dirname\n";
while(($filename = readdir(DIR)))
{
print("$filename\n");
}
closedir(DIR);
