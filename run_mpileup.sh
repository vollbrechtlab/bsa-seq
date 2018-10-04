min_dep=$1
echo $min_dep
if ! [[ "$min_dep" =~ ^[0-9]+$ ]]
then
	echo "First argument must denote the minimum depth."
	echo "$min_dep is not a number. Please check your input"
	exit
fi

for f in `find sam/ -iname "*bam" | sort -V`
do
	out=`echo $f | sed -e 's/.bam//g' -e 's/sam/mpileup/g'`
	echo $out $f
	#nuc=`echo $out | sed 's/mpl$/nuc/g'`
	#| grep -v '+'
	if [ ! -f "$out.$min_dep.mpl" ]
	then
  	samtools mpileup -I --ff UNMAP --ff SECONDARY --ff QCFAIL --ff DUP -Q 20 -q 50 -d 1000 $f | awk "\$4>=$min_dep" | grep -v '\+' > $out.$min_dep.mpl
  	python mpileup_analysis.py $out.$min_dep.mpl $min_dep > $out.$min_dep.nuc
	fi
done
