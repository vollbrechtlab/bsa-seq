#!/bin/bash

for file in `find sam -iname "*bam"`
do
  out=`basename $file | sed -e 's/sam.//g' -e 's/.bam//g'`
  outfile="cov/$out.cov"
  if [ ! -f "$outfile" ]
  then
    echo "Processing $file"
    echo -e "chr\tpos\tdepth" > $outfile
    samtools depth -q 20 -Q 50 -d 1000 $file >> $outfile
  else
    echo "The $outfile already exisits"
  fi
done

