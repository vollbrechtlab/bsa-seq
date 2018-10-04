#!/usr/bin/python
import sys
import re

print "chr\tpos\tdep\tA\tC\tG\tT"#\tIns\tDel"

f = open(sys.argv[1], "r")
min_dep = int(sys.argv[2])
#regex_ins = re.compile("\*")
#regex_del =  re.compile(".\-")

for line in f:
    #print line
    tmp = line.split("\t")
    chr = tmp[0]
    pos = tmp[1]
    dep = tmp[3]
    nucs = tmp[4].upper()
#    nucs = regex_ins.sub('-', nucs)
#    nucs = regex_del.sub('-', nucs)
    a = nucs.count("A")
    c = nucs.count("C")
    g = nucs.count("G")
    t = nucs.count("T")
    # ins = nucs.count("*")
    # dels = nucs.count("-")
    if a + c + g + t > min_dep:
        print chr+"\t"+str(pos)+"\t"+str(dep)+"\t"+str(a)+"\t"+str(c)+"\t"+str(g)+"\t"+str(t)#+"\t"+str(ins)+"\t"+str(dels)
