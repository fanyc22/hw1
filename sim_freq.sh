#!/bin/bash
# Program:
#     CPU frequency simulation
Target=Frequency_out       
Unit=MHz
Root=~/gem5-stable/"$Target"     # Target dictionary for stats.txt
Gem5=~/gem5-stable/build/ARM/gem5.debug # gem5 dictionary
Script=~/gem5-stable/configs/example/se.py  # config script dictionary 
Bench=queens                                 # benchmark name
i=1000 # frequency: MHz
CPUtype=timing 

touch ./MinorCPU.txt
echo "[" > ./TimingCPU_l2.txt

# mkdir $Root
while [ $i != 3100 ]                    # Max frequency: 3GHz = 3000MHz
do
    # Add your code here for gem5 simulation
    echo "Frequency: $i$Unit"
    touch $Root/MinorCPU_$i$Unit.txt
    # build/ARM/gem5.debug configs/example/se.py --cpu-type MinorCPU --caches --l2cache --l1d_size 8kB --l1i_size 8kB --l1d_assoc 4 --l1i_assoc 4 --l2_size 1MB --l2_assoc 8 --cacheline_size 64 --cpu-clock $i$Unit -n 1 -c ~/file/queens.o -o "8" > $Root/MinorCPU_$i$Unit.txt
    build/ARM/gem5.debug configs/example/se.py --cpu-type TimingSimpleCPU --caches --l2cache --l1d_size 8kB --l1i_size 8kB --l1d_assoc 4 --l1i_assoc 4 --l2_size 1MB --l2_assoc 8 --cacheline_size 64 --cpu-clock $i$Unit -n 1 -c ~/file/queens.o -o "8" > $Root/TimingCPU_$i$Unit.txt
    # 提取并打印 tick 数
    # tick=$(awk '/Exiting @ tick/ {print $4}' "$Root/MinorCPU_${i}Unit.txt")
    tick=$(grep "Exiting" "$Root/TimingCPU_${i}${Unit}.txt" | sed 's/.*Exiting @ tick \([0-9]\+\) .*/\1/')
    echo "Tick 数: $tick"
    echo "$tick ," >> ./TimingCPU_l2.txt
    i=$(($i+100))
done;
echo "finished"
exit 0