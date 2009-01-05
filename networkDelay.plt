set term windows
set xlabel "Average Traffic [Packets Per Second]"
set ylabel "Average Network Delay [ms]"
set y2label ""
set yrange [0:1.1]
set xrange [0:1.6]
set xtics 0,0.1
set ytics 0,0.1
set grid xtics ytics

plot "target/ShortestPath.csv" using 1:2 title "Shorted Path" with linespoints
replot "target/ShortestPath_noA1.csv" using 1:2 title "Shorted Path with no A1" with linespoints
replot "target/ShortestPath_noA2.csv" using 1:2 title "Shorted Path with no A2" with linespoints

replot "target/Optimal.csv" using 1:2 title "Optimal" with linespoints
replot "target/Optimal_noA1.csv" using 1:2 title "Optimal with no A1" with linespoints
replot "target/Optimal_noA2.csv" using 1:2 title "Optimal with no A2" with linespoints

set term png size 1280,768
set output "target/RoutingComparison.png"
replot

pause -1 "Next..."
set term windows
clear

set y2label "Link Utilization (flow/capacity)"
set y2tics 0,0.1
set y2range [0:1.1]

plot "target/ShortestPath.csv" using 1:2 title "Shorted Path" with linespoints
replot "target/ShortestPath.csv" using 1:3 axes x1y2 title "Shortest Path Maximum Link Utilization" with linespoints

replot "target/Optimal.csv" using 1:2 title "Optimal" with linespoints
replot "target/Optimal.csv" using 1:3 axes x1y2 title "Optimal Maximum Link Utilization" with linespoints

set term png size 1280,768
set output "target/RoutingComparisonWithMaxUtilization.png"
replot

pause -1 "Next..."
set term windows
clear