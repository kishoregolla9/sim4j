package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.PrintStream;
import java.text.DecimalFormat;

/**
 * Main class to run the comparison of Shorted Path versus Optimal Routing.
 * <P>
 * Output files, located in the target directory include the following files
 * each for Optimal and Shortest Path (for a whole network, without link A1 and
 * without link A2):
 * <OL>
 * <LI><B>.csv</B>: Average network delay for varying average traffic in the
 * network from (almost) zero to 1.6</LI>
 * <LI><B>.txt</B>: Summary of output results (for d<sub>pq</sub>=1)
 * including
 * <UL>
 * <LI>algorithm execution time
 * <LI>average network delay,
 * <LI>average delay for each link (plus average link delay),
 * <LI>the route from each node to every other node.
 * </UL>
 * </OL>
 * </P>
 */
public class RoutingComparison
{
  // NETWORK CONSTANTS
  static final double DELAY_PER_KM = 0.000005d; // 5us/km
  static final double PROCESSING_DELAY = 0.001d; // 1ms
  static final int BYTES_PER_PACKET = 1500;

  static final MetricFunction SHORTEST_PATH_METRIC_FUNCTION =
      new CapacityMetricFunction();

  private static final double START = 0.00001d;
  private static final double INCREMENT = 0.025d;
  private static final double MAX = 1.5d;

  private static final String TXT = ".txt";
  private static final String CSV = ".csv";
  private static final String SEP = System.getProperty("line.separator");

  public static final DecimalFormat FORMAT = new DecimalFormat("#0.00000");
  public static final DecimalFormat EFORMAT = new DecimalFormat("#0.00E00");

  private static final String OUTPUT_DIRECTORY = "target";

  public static void main(String[] args) throws NetworkException, IOException
  {
    File dir = new File(getOutputDirectory());
    if (dir.exists())
    {
      deleteFiles(dir);
    }
    else
    {
      dir.mkdirs();
    }

    Network network = getNewNetwork("");
    run(network, "");

    network = getNewNetwork("_noA1");
    run(network, "_noA1");

    network = getNewNetwork("_noA2");
    run(network, "_noA2");

  }

  private static void deleteFiles(File dir)
  {
    dir.list(new FilenameFilter()
    {
      @Override
      public boolean accept(File dir, String name)
      {
        if (name.endsWith(CSV) || name.endsWith(TXT))
        {
          new File(dir, name).delete();
          return true;
        }
        return false;
      }
    });
  }

  private static Network getNewNetwork(String suffix) throws NetworkException
  {
    NetworkFileParser parser =
        new NetworkFileParser(
            new File("src/main/resources/ARPA" + suffix + TXT));
    Network network = parser.getNetwork();
    return network;
  }

  private static void run(Network network, String suffix)
      throws NetworkException, IOException
  {
    RoutingComparison project = new RoutingComparison();
    project.runShortestPath(network, suffix);
    project.runOptimal(network, suffix);
  }

  static String getOutputDirectory()
  {
    return OUTPUT_DIRECTORY;
  }

  private void runOptimal(Network network, String suffix)
      throws NetworkException, IOException
  {
    Optimal optimal = new Optimal(network);

    String name = "Optimal" + suffix;

    long start = System.nanoTime();
    double averageNetworkDelay = optimal.run(1d);
    long end = System.nanoTime();

    writeResults(name, network, nanosToMillis(start, end), averageNetworkDelay);

    FileWriter file =
        new FileWriter(new File(getOutputDirectory(), name + CSV));

    file.write("#AverageTraffic NetworkDelay MaximumLinkUtilization");
    file.write(SEP);

    for (double d = 0; d <= MAX; d += INCREMENT)
    {
      optimal = new Optimal(getNewNetwork(suffix));
      double delay = optimal.run(d == 0 ? START : d);
      // DelayCalculator.getAverageDelay(network, d, flow);
      double maxFlowOverCapacity = getMostUsedLink(d, network);
      file.write(FORMAT.format(d));
      file.write(" " + FORMAT.format(delay));
      file.write(" " + FORMAT.format(maxFlowOverCapacity));
      file.write(SEP);
      file.flush();
    }
    file.close();

  }

  public double getMostUsedLink(double dpq, Network network)
  {
    double best = 0d;

    for (Link link : network.getLinks())
    // for (int i = 0; i < flow.length; i++)
    // {
    // for (int j = 0; j < flow.length; j++)
    {
      // Link link = network.getLink(i + 1, j + 1);
      if (link != null)
      {
        double value = link.getFlow() / link.getCapacity();
        // double value =
        // flow[i][j] * dpq * 8 * RoutingComparison.BYTES_PER_PACKET
        // / link.getCapacity();
        if (value > best)
        {
          best = value;
        }
      }
      // }
    }
    return best;
  }

  private void runShortestPath(Network network, String suffix)
      throws NetworkException, IOException
  {
    Dijkstra dijikstra = new Dijkstra(network);

    long start = System.nanoTime();
    dijikstra.calculate(SHORTEST_PATH_METRIC_FUNCTION);
    long end = System.nanoTime();

    network.setAverageTraffic(1);

    String name = "ShortestPath" + suffix;
    double averageNetworkDelay =
        DelayCalculator.getAverageDelay(network, 1, network
            .getTrafficFlowVector());
    writeResults(name, network, nanosToMillis(start, end), averageNetworkDelay);

    FileWriter file =
        new FileWriter(new File(getOutputDirectory(), name + CSV));
    file.write("#AverageTraffic NetworkDelay MaximumLinkUtilization");
    file.write(SEP);

    for (double d = START; d <= MAX; d += INCREMENT)
    {
      network.setAverageTraffic(1);
      double[][] flow = network.getTrafficFlowVector();
      double delay = DelayCalculator.getAverageDelay(network, d, flow);
      double maxFlowOverCapacity = getMostUsedLink(d, network);
      file.write(FORMAT.format(d));
      file.write(" " + FORMAT.format(delay));
      file.write(" " + FORMAT.format(maxFlowOverCapacity));
      file.write(SEP);
      file.flush();
    }
    file.close();

  }

  private long nanosToMillis(long start, long end)
  {
    return (end - start) / 1000000;
  }

  private void writeResults(String name, Network network, long execution,
      double averageNetworkDelay) throws IOException
  {
    new File(getOutputDirectory()).mkdirs();
    PrintStream out =
        new PrintStream(new File(getOutputDirectory(), name + TXT));

    out.println("***************************");
    out
        .println("Results for " + name
            + "(for 1 packet/second average traffic)");
    out.println("***************************");
    out.println(name + " Execution time: " + execution + " ms");
    out.println("***************************");
    out.println("*** Average Network Delay:"
        + FORMAT.format(averageNetworkDelay));
    out.println("***************************");
    double total = 0;
    int numLinks = 0;
    for (Link link : network.getLinks())
    {
      double averageDelay = DelayCalculator.getAverageDelay(link, 1);
      out.println(getLinkString(link) + ": " + FORMAT.format(averageDelay));
      if (averageDelay > 0)
      {
        total += averageDelay;
        numLinks++;
      }
    }
    out.println("***************************");
    out.println("*** Average Link Delay:" + FORMAT.format(total / numLinks));

    out.println("***************************");
    out.println("*** Paths between each node to every other node:");

    for (Node node : network.getNodes())
    {
      out.println("Starting at " + node + " to...");
      for (Node destination : network.getNodes())
      {
        Path path = node.getPath(destination);
        out.println("\t" + destination + ": " + path);
      }
    }
    out.println("***************************");
    out.flush();
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
