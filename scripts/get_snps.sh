genome="/home/gokul/lab_data/gen_fa/maize_v4/fa/maize_v4.chrs.fa"

for f in `find sam/ -iname "*bam" | sort -V`
do
	out=`echo $f | sed -e 's/.bam//g' -e 's/sam/mpileup/g'`
	echo $out $f
	if [ ! -f "$out.vcf.gz" ]
	then
		bcftools mpileup -Ou -f $genome -I --ff UNMAP --ff SECONDARY --ff QCFAIL --ff DUP -Q 20 -q 50 -d 250 $f | bcftools call -Ou -mv  | \
		bcftools filter -e 'DP<10' -Oz -o $out.vcf.gz && \
		bcftools index $out.$min_dep.vcf.gz
	fi
	
done

for f in `find mpileup/ -iname "*vcf.gz" | sort -V`
do
	out=`basename $f | sed -e 's/.vcf.gz//g' -e 's/[_.]/\t/g'`
	echo -en "$out\t"
	# if [ ! -f "$out.$min_dep.vcf.gz" ]
	# then
	# 	bcftools mpileup -Ou -f $genome -I --ff UNMAP --ff SECONDARY --ff QCFAIL --ff DUP -Q 20 -q 50 -d 250 $f | bcftools call -Ou -mv  | \
	# 	bcftools filter -e 'DP<10' -Oz -o $out.vcf.gz && \
	# 	bcftools index $out.$min_dep.vcf.gz
	# fi
	
done

