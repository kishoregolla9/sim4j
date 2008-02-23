package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintStream;
import java.text.DecimalFormat;

/**
 * This is the main class to run the comparison of Shorted Path vs Optimal
 * Routing.
 * 
 */
public class Project
{
  static final MetricFunction METRIC_FUNCTION = new CapacityMetricFunction();
  static final double DELAY_PER_KM = 0.000005d; // 5us/km
  static final double PROCESSING_DELAY = 0.001d; // 1ms

  public static final DecimalFormat FORMAT = new DecimalFormat("#0.00000");
  static final int BYTES_PER_PACKET = 1500;

  DelayCalculator delayCalculator = new DelayCalculator(BYTES_PER_PACKET);

  public static void main(String[] args) throws NetworkException, IOException
  {
    new File(getOutputDirectory()).mkdirs();
    m_outputDirectory = "target";
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Network network = parser.getNetwork();

    run(network);

    m_outputDirectory = "target/noA1";
    network = parser.getNetwork();
    network.getLinks().remove(network.getLink(19, 20));
    run(network);

    m_outputDirectory = "target/noA2";
    network = parser.getNetwork();
    network.getLinks().remove(network.getLink(5, 6));
    run(network);

  }

  private static void run(Network network) throws NetworkException, IOException
  {
    Project project = new Project();
    project.runDijkstra(network);
    network.setAverageTraffic(1);
    project.runOptimal(network);
  }

  static String getOutputDirectory()
  {
    return m_outputDirectory;
  }

  private static String m_outputDirectory = "target";

  private void runOptimal(Network network) throws NetworkException, IOException
  {
    Optimal optimal = new Optimal(network);

    long start = System.nanoTime();
    double[][] flow = optimal.run();
    long end = System.nanoTime();

    writeResults("Optimal", network, nanosToMillis(start, end), flow);
  }

  private void runDijkstra(Network network) throws NetworkException,
      IOException
  {
    Dijkstra dijikstra = new Dijkstra(network);

    long start = System.nanoTime();
    dijikstra.calculate(METRIC_FUNCTION);
    long end = System.nanoTime();

    network.setAverageTraffic(1);

    String name = "ShortestPath";
    writeResults(name, network, nanosToMillis(start, end), network
        .getTrafficFlowVector());
    calculateAverageDelays(name, network);
  }

  private long nanosToMillis(long start, long end)
  {
    return (end - start) / 1000000;
  }

  private void writeResults(String name, Network network, long execution,
      double[][] flow) throws IOException
  {
    PrintStream out =
        new PrintStream(new File(getOutputDirectory(), name + ".txt"));

    out.println("***************************");
    out.println("Results for " + name);
    out.println("***************************");
    out.println("*** Average Delay (for 1 packet/second average traffic) *** ");
    out.println("*** Network Delay:"
        + DelayCalculator.getAverageDelay(network, 1, flow));

    double total = 0;
    int numLinks = 0;
    for (Link link : network.getLinks())
    {
      double averageDelay = delayCalculator.getAverageDelay(link, 1);
      out.println(getLinkString(link) + ": " + FORMAT.format(averageDelay));
      if (averageDelay > 0)
      {
        total += averageDelay;
        numLinks++;
      }
    }
    out.println("*** Average Link Delay:" + total / numLinks);

    out.println("***************************");

    for (Node node : network.getNodes())
    {
      out.println("Starting at " + node + " to...");
      for (Node destination : network.getNodes())
      {
        Path path = node.getPath(destination);
        out.println("\t" + destination + ": " + path);
      }
    }

    out.println(name + " Execution time: " + execution + " ms");
    out.flush();
  }

  private void calculateAverageDelays(String name, Network network)
      throws IOException
  {
    String sep = System.getProperty("line.separator");

    network.setAverageTraffic(1);

    double increment = 0.0001d;
    double max = 2d;
    FileWriter file =
        new FileWriter(new File(getOutputDirectory(), name + ".csv"));
    for (double d = increment; d < max; d += increment)
    {
      double delay = delayCalculator.getAverageDelay(network, d);
      file.write(FORMAT.format(d) + " " + FORMAT.format(delay) + sep);
    }
    file.close();

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
