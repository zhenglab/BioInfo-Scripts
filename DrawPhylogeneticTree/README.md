
### 软件使用说明

1. 01IntegrateGeneData.pl对果蝇的基因组数据进行整合，将获得的果蝇基因组数据（下载地址为http://www.mmnt.net/db/0/0/ftp.biostat.wisc.edu/pub/cdewey/data/fly_alignments/fly_CAF1.1.tar.gz ,具体数据为解压后的fly_CAF1.1/alignments文件夹下的4684个文件夹下的mavid.mfa文件）进行整合，将果蝇基因组原始数据按照物种进行合并，最终生成以果蝇12个物种名称命名的mfa文件，输入输出路径可以根据自己的需求进行修改，每个文件是当前物种的所有fasta序列；输入为alignments目录下的4684个文件夹内的mavid.mfa文件，输出为指定路径下的12个"物种.mfa"文件。

2. 02RestrictionEnzymeDigestion.pl对第一步生成的12个物种序列文件进行2bRAD酶切，酶切过后生成长度为25bp的短序列（酶切过程包括主链和辅链，分别用两个函数进行处理后形成相同的格式 ），去掉无效序列后以哈希表的方式保存数据，key是tagid，value是短序列，然后按照物种以及不同的tagid按照顺序排序，以fasta格式保存到allione.fa文件内；然后用ustacks进行进一步处理，将序列按照相似程度排列出来，生成allinone.tags.tsv文件。

3. 03ProcessTsvData.pl对第二步生成的allinone.tags.tsv文件进行如下处理：

  1. 去掉无关的标记和符号，只保留物种信息和序列信息；
  2. 去掉每一个consensus下没有包含12个物种的consensus，只保留大于12的consensus；

4. 04ProcessFastaData.pl对第三步的结果进行如下处理：

  1. 对每一组consensus加上'>'和数字标记，便于计数和匹配；
  2. 对标记的文件进行分析，生成一个二维矩阵（包括在每一组里同一物种的出现次数），12行对应12个物种，112列对应在每一组consensus内包含当前物种序列出现的次数；
  3. 序列拼接，选出每一个物种在每一组consensus下第一次出现的短序列，将它们拼接成一个长序列，格式为fasta格式。

5. 本步骤使用外部软clustalw和phylip进行处理（需要自行下载），用clustalw进行多序列比对，生成一个以.phy结尾的文件；用phylip对上一步的phy文件进行建树处理，生成进化树；用treeview看生成的进化树。
