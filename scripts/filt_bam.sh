  for file in `find sam -iname "*bam"`
  do
    out=`basename $file | sed -e 's/sam/filt/g'`
    samtools view -F 2048 -F 4 -@ 8 -c sam/trial1.6792_mut.bam
 
  done