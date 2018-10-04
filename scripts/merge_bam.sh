#!/bin/bash

bam_files=`find sam -iname "*bam" | sed -e 's/sam.//g' -e 's/.bam//g' -e 's/.*[.]//g' | sort | uniq`

for file in $bam_files
do
  infiles=`find sam -iname "*$file*bam"`
  outfile="merged/$file.bam"
  samtools merge -@ 8 -l 9 $outfile $infiles && \
  samtools index $outfile

#   out=`basename $file | sed -e 's/sam.//g' -e 's/.bam//g'`
#   outfile="cov/$out.cov"
#   if [ ! -f "outfile" ]
#   then
#     echo -e "chr\tpos\tdepth" > $outfile
#     samtools depth -q 20 -Q 50 -d 1000 $file >> $outfile
#   fi
done

