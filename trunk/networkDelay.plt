set grid
set xlabel "Packets Per Second"
set ylabel "Average Delay"
plot "networkDelay.csv" using 1:2 title "Average Network Delay" with lines