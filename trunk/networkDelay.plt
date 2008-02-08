set grid
set xlabel "Average Traffic [Packets Per Second]"
set ylabel "Average Delay [sec]"
plot "networkDelay.csv" using 1:2 title "Average Network Delay" with lines
