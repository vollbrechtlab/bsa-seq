#!/bin/bash
mm2idx="/home/gokul/lab_data/mm2_idx/maize_b73_agp4.sr.mmi"
for file in `find filt/ -iname "*fq.gz"`
do
  out_sam="sam/"`basename $file | sed 's/fq.gz/sam/g'`
  out_bam="sam/"`basename $file | sed 's/fq.gz/bam/g'`
  echo $out
  if [ ! -f "$out_sam" ] && [ ! -f "$out_bam" ]
  then
    minimap2 -ax sr -t 8 $mm2idx $file > $out_sam
  else
    echo "The $out_bam$out_sam exists remove to regenerate"
  fi
  # exit
done