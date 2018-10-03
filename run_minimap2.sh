#!/bin/bash
mm2idx="/home/gokul/lab_data/mm2_idx/maize_b73_agp4.sr.mmi"
for file in `find filt/ -iname "*fq.gz"`
do
  base_name=`basename $file | sed 's/.fq.gz//g'`
  outfile=`find sam -iname "$base_name*" | sort | head -n 1`
  out="sam/$base_name.sam"
  echo $out
  if [ -z "$outfile" ]
  then
    echo "Processing $file"
    minimap2 -ax sr -t 8 $mm2idx $file > $out
  else
    echo "The $outfile exists remove to regenerate"
  fi
  # exit
done