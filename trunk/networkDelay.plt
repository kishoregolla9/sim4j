set grid
set xlabel "Average Traffic [Packets Per Second]"
set ylabel "Average Delay [sec]"
set yrange [-5:5]
plot "networkDelay.csv" using 1:2 title "Average Network Delay" with lines
