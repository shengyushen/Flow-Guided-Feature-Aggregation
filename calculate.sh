# extract all lines with SSY in head, they are printed by print_summary for all shapes
# and also remove the SSY head
cat $1|grep SSY|awk '{print substr($0,6,length($0)-6)}' > nossy
# remove empty lines
awk '{if(NF!=0) print}' nossy > noempty
# remove comma
cat noempty|awk -F, '{for(i=1;i<=NF;i=i+1) {printf $i };print ""}' > nocomma
#remove L in the end of all numbers
cat nocomma| awk '{for(i=1;i<=NF;i=i+1) {if(substr($i,length($i),1)=="L") {printf substr($i,1,length($i)-1)  " "} else {exit 1}};print ""}' > noL
# compute all fetures
# also consider they are 4 bye each word, 
# and also consider there are forward feature and backward delta
cat noL |awk '{prod=1;for(i=1;i<=NF;i=i+1) {prod=prod*$i};total=total+prod} END{print total*4*2}'
