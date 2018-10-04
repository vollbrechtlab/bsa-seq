#!/bin/bash

if [ ! -f "raw_reads.count" ]
then
echo -e "trial\tgeno\tpheno\tcount" > "raw_reads.count"
  for file in `find fastq -iname "*fq.gz"`
  do
    out=`echo $file | sed -e 's/fastq.//g' -e 's/.fq.gz//g' -e 's/[.|_]/\t/g' | tr '/' '\t'`
    echo -en "$out\t" >> raw_reads.count
    bioawk -c fastx 'BEGIN{counter=0;}{counter=counter+1;}END{print counter}' $file >> raw_reads.count
  done
fi

if [ ! -f "filt_reads.count" ]
then
  echo -e "trial\tgeno\tpheno\tcount" > "filt_reads.count"
    for file in `find filt -iname "*fq.gz"`
    do
      echo "$file"
      out=`basename $file | sed -e 's/filt.//g' -e 's/.fq.gz//g' -e 's/[.|_]/\t/g'`
      echo -en "$out\t" >> "filt_reads.count"
      bioawk -c fastx 'BEGIN{counter=0;}{counter=counter+1;}END{print counter}' $file >> "filt_reads.count"
    done
fi

if [ ! -f "filt_reads.length" ]
then
  echo -en "" > filt_reads.length
  for file in `find filt -iname "*fq.gz"`
  do
    out=`basename $file | sed -e 's/filt.//g' -e 's/.fq.gz//g' -e 's/[.|_]/\t/g'`
    bioawk -c fastx -v file="$out" '{print file"\t"length($seq)}' $file >> filt_reads.length
  done
fi

if [ ! -f "aligned_reads.count" ]
then
  echo -e "trial\tgeno\tpheno\tcount" > aligned_reads.count
  for file in `find sam -iname "*bam"`
  do
    out=`basename $file | sed -e 's/sam.//g' -e 's/.bam//g' -e 's/[.|_]/\t/g'`
    echo "Procssing $file"
    echo -en "$out\t" >> aligned_reads.count
    samtools view -F 2048 -F 4 -@ 8 -c $file >> aligned_reads.count
  done
fi
