package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.text.DecimalFormat;

public class Project
{
  static final MetricFunction METRIC_FUNCTION = new CapacityMetricFunction();
  static final double DELAY_PER_KM = 0.000005d; // 5us/km
  static final double PROCESSING_DELAY = 0.001d; // 1ms

  public static final DecimalFormat FORMAT = new DecimalFormat("#0.00000");
  static final int BYTES_PER_PACKET = 1500;

  public static void main(String[] args) throws NetworkException, IOException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Network network = parser.getNetwork();

    Project project = new Project();
    project.runDijkstra(network);
    project.runOptimal(network);
  }

  private void runOptimal(Network network) throws NetworkException, IOException
  {
    Optimal optimal = new Optimal(network);

    long start = System.nanoTime();
    optimal.run();
    long end = System.nanoTime();

    writeResults("Optimal", network, (end - start) / 1000000);
  }

  private void runDijkstra(Network network) throws NetworkException,
      IOException
  {
    Dijkstra dijikstra = new Dijkstra(network);

    long start = System.nanoTime();
    dijikstra.calculateShortestPaths(METRIC_FUNCTION);
    long end = System.nanoTime();

    writeResults("Dijkstra", network, (end - start) / 1000000);
  }

  private void writeResults(String name, Network network, long execution)
      throws IOException
  {
    PrintStream out = new PrintStream(new File(name + ".txt"));

    out.println("***************************");
    out.println("Results for " + name);

    for (Node node : network.getNodes())
    {
      out.println("Starting at " + node + " to...");
      for (Node destination : network.getNodes())
      {
        Path path = node.getPath(destination);
        out.println("\t" + destination + ": " + path);
      }
    }

    calculateAverageDelays(name, out, network);

    out.println(name + " Execution time: " + execution + " ms");

    out.flush();
  }

  private void calculateAverageDelays(String name, PrintStream out,
      Network network) throws IOException
  {
    DelayCalculator delayCalculator = new DelayCalculator(BYTES_PER_PACKET);

    String sep = System.getProperty("line.separator");
    network.resetFlow();
    network.addFlow(1);

    double increment = 0.0005d;
    double max = 1.2d;
    FileWriter file = new FileWriter(name + ".csv");
    for (double d = increment; d < max; d += increment)
    {
      double delay = delayCalculator.getAverageDelay(network, d);
      delay /= 1000;
      file.write(FORMAT.format(d) + " " + FORMAT.format(delay) + sep);
    }
    file.close();

    out.println("*** Average Delay *** ");
    for (Link link : network.getLinks())
    {
      double averageDelay = delayCalculator.getAverageDelay(link, 1);
      out.println(getLinkString(link) + ": " + FORMAT.format(averageDelay));
    }
  }

  private String getLinkString(Link link)
  {
    String padding = "";
    if (link.getI().getId() < 10 && link.getJ().getId() < 10)
    {
      padding = "  ";
    }
    else if (link.getI().getId() < 10 || link.getJ().getId() < 10)
    {
      padding = " ";
    }

    return "Link: " + padding + link.getI().getId() + "-" + link.getJ().getId();

  }
}
