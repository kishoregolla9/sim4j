package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

public class Dijikstra
{

  private static final DijikstraMetricFunction FUNCTION =
      new DijikstraMetricFunction();
  private final Network m_network;

  public Dijikstra(Network network)
  {
    m_network = network;
  }

  private Map<Node, Path> getShortestPaths(Node startNode)
  {
    // init temporary set to hold all nodes
    // result is the cost to every other node
    Map<Node, Double> temporary = new HashMap<Node, Double>();
    Map<Node, Double> permanent = new HashMap<Node, Double>();
    Map<Node, Path> predecessor = new HashMap<Node, Path>();

    init(startNode, temporary, permanent, predecessor);

    while (temporary.size() > 0)
    {
      Node node = getMinimumCost(temporary);
      Double metric = temporary.remove(node);
      permanent.put(node, metric);

      update(temporary, predecessor, node, metric);
    }
    return predecessor;
  }

  private Node getMinimumCost(Map<Node, Double> temporary)
  {
    double min = Double.MAX_VALUE;
    Node result = null;
    for (Node node : temporary.keySet())
    {
      Double possible = temporary.get(node);
      if (!possible.isInfinite() && possible.doubleValue() < min)
      {
        min = possible.doubleValue();
        result = node;
      }
    }
    return result;

  }

  private void init(Node startNode, Map<Node, Double> temporary,
      Map<Node, Double> permanent, Map<Node, Path> predecessor)
  {
    for (Node node : getNetwork().getNodes())
    {
      temporary.put(node, Double.POSITIVE_INFINITY);
    }
    temporary.put(startNode, 0d);

    for (Node node : getNetwork().getNodes())
    {
      predecessor.put(node, new Path(startNode, FUNCTION));
    }

    Path path = new Path(startNode, FUNCTION);
    path.addLink(new Link(startNode, startNode, 0, 0));
    predecessor.put(startNode, path);
  }

  private void update(Map<Node, Double> temporary, Map<Node, Path> predecessor,
      Node node, Double metric)
  {
    Path path;
    for (Link link : node.getLinks())
    {
      Node other = link.getOther(node);
      if (temporary.containsKey(other))
      {
        // d(j)
        double costSoFar = temporary.get(other);
        // d(i) + cij
        double potentialCost = metric + FUNCTION.getMetric(link);
        if (costSoFar > potentialCost)
        {
          temporary.put(other, potentialCost);
          path = predecessor.get(other);
          path.addLink(link);
        }
      }
    }
  }

  public static void main(String[] args) throws NetworkException, IOException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/small.txt"));
    Network network = parser.getNetwork();

    Dijikstra dijikstra = new Dijikstra(network);
    dijikstra.run();
  }

  private void run() throws NetworkException, IOException
  {
    calculateShortestPaths();
    calculateAverageDelays();
  }

  private void calculateAverageDelays() throws IOException
  {
    DelayCalculator delayCalculator = new DelayCalculator();

    double increment = 0.025d;
    double d = 0d;
    FileWriter file = new FileWriter("networkDelay.csv");
    file.write("Packets Per Second,Average Delay\n");
    for (int i = 0; i < 2 / increment; i++)
    {
      double delay = delayCalculator.getAverageDelay(getNetwork(), d);
      d += increment;
      file.write(d + "," + delay + "\n");
    }

    file.close();
  }

  private Network getNetwork()
  {
    return m_network;
  }

  private void calculateShortestPaths() throws NetworkException
  {
    long start = System.nanoTime();

    Map<Node, Map<Node, Path>> paths = new HashMap<Node, Map<Node, Path>>();
    for (Node startNode : getNetwork().getNodes())
    {
      paths.put(startNode, getShortestPaths(startNode));
    }

    long end = System.nanoTime();
    double metricSum = 0;
    int totalCount = 0;
    for (Node startNode : paths.keySet())
    {
      System.out.println("Starting at " + startNode + " to...");
      Map<Node, Path> map = paths.get(startNode);
      for (Node node : map.keySet())
      {
        Path path = map.get(node);
        metricSum += path.getMetric(FUNCTION);
        startNode.setRoute(node, path);
        totalCount++;
        System.out.println("\t" + node + ": " + path);
      }
    }
    double networkMetric = metricSum / totalCount;
    System.out.println("Network Metric Average: "
        + DecimalFormat.getNumberInstance().format(networkMetric));
    System.out.println("Dijikstra Execution time: " + (end - start) / 1000000
        + " ms");
  }

  static class DijikstraMetricFunction implements MetricFunction
  {

    @Override
    public double getMetric(Link link)
    {
      if (link.getCapacity() == 0)
      {
        return 0;
      }
      return 100000000 / link.getCapacity();
    }

  }

}
