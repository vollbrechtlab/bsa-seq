for f in `find fastq -iname "*fq.gz"`
do
	out=`echo $f | sed -e 's/fastq/filt/g' -e 's/trial\(.\)./trial\1./g'`
	if [ ! -f $out ]
	then
	  fastq-mcf -t 0 -m 10 -X -H -q 20 -l 50 adapter.fa $f -o $out
  else
    echo "$out exists, please remove to recreate"
  fi
done
