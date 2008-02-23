set grid
set term windows

set xlabel "Average Traffic [Packets Per Second]"
set ylabel "Average Delay [ms]"
set yrange [0:5]
set xrange [0:2]
plot "target/ShortestPath.csv" using 1:2 title "Average Network Delay with Shorted Path" with lines
replot "target/noA1/ShortestPath.csv" using 1:2 title "Average Network Delay with Shorted Path with no A1" with lines
replot "target/noA2/ShortestPath.csv" using 1:2 title "Average Network Delay with Shorted Path with no A2" with lines
set term png size 1280,768
set output "target/ShortestPath.png"
replot

set term windows

