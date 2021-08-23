## Alex Weber's bash shell script for
## segmentation using ROIanalysis.pl script
## August 2021

#!/bin/bash

if [ $# -lt 5 ]; then
    # TODO: print usage
    echo "This script requires five arguments:
output: path of output
T1w path: path of T1w.nii.gz file
SI location (I is negative)
RL location (R is negative)
AP location (A is negative)

So for example:
mrsmask.sh some/out/path path/to/T1w.nii.gz 43.4 -19.9 -30.6"
    exit 1
fi

out=$1
t1=$2
si=$3
rl=$4
ap=$5

fslmaths $t1 -mul 0 $out/zeromask

#chmod 444 $out/zeromask.nii.gz

## get vozel size
xxdim=$(fslhd $t1 | grep -w pixdim1 | awk '{print $2}')
yydim=$(fslhd $t1 | grep -w pixdim2 | awk '{print $2}')
zzdim=$(fslhd $t1 | grep -w pixdim3 | awk '{print $2}')


## Analysing ROI defined by Coord

xhalf=$(echo "${xxdim} /2" | bc -l | xargs printf "%0.1f")
yhalf=$(echo "${yydim} /2" | bc -l | xargs printf "%0.1f")
zhalf=$(echo "${zzdim} /2" | bc -l | xargs printf "%0.1f")

rn=$(echo "$rl - 10" | bc -l)
ln=$(echo "$rl + 10" | bc -l)
an=$(echo "$ap - 10" | bc -l)
pn=$(echo "$ap + 10" | bc -l)
in=$(echo "$si - 10" | bc -l)
sn=$(echo "$si + 10" | bc -l)

rnxhalf=$(echo "${rn} + ${xhalf}" | bc -l)
lnxhalf=$(echo "${ln} - ${xhalf}" | bc -l)
anyhalf=$(echo "${an} + ${yhalf}" | bc -l)
pnyhalf=$(echo "${pn} - ${yhalf}" | bc -l)
inzhalf=$(echo "${in} + ${zhalf}" | bc -l)
snzhalf=$(echo "${sn} - ${zhalf}" | bc -l)

echo "
new corrected coord:
x: "$rnxhalf":"$lnxhalf"
y: "$anyhalf":"$pnyhalf"
z: "$inzhalf":"$snzhalf""

3dmaskdump -dbox "$rnxhalf":"$lnxhalf" "$anyhalf":"$pnyhalf" "$inzhalf":"$snzhalf" -o $out/voxelroidata $t1

3dUndump -prefix $out/ROIfim.nii.gz -master $out/zeromask.nii.gz $out/voxelroidata