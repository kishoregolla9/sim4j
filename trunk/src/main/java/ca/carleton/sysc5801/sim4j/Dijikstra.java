package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.Map;

public class Dijikstra
{
  private static final double TIME_INCREMENT = 0.000005d;
  private static final int PACKET_SIZE = 1500;
  private static final DijikstraMetricFunction FUNCTION =
      new DijikstraMetricFunction();
  private final Network m_network;

  public Dijikstra(Network network)
  {
    m_network = network;
  }

  public Map<Node, Map<Node, Path>> run()
  {
    Map<Node, Map<Node, Path>> paths = new HashMap<Node, Map<Node, Path>>();
    for (Node startNode : m_network.getNodes())
    {
      paths.put(startNode, getShortestPaths(startNode));
    }
    return paths;

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
    for (Node node : m_network.getNodes())
    {
      temporary.put(node, Double.POSITIVE_INFINITY);
    }
    temporary.put(startNode, 0d);

    for (Node node : m_network.getNodes())
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

  public static void main(String[] args) throws NetworkException
  {
    Network network = calculateShortestPaths();

    for (Node src : network.getNodes())
    {
      for (Node dest : network.getNodes())
      {
        src.sendPacket(new Packet(src, dest, PACKET_SIZE));
      }
    }

    for (double time = 0; time < 60; time += TIME_INCREMENT)
    {
      for (Link link : network.getLinks())
      {
        link.tick(TIME_INCREMENT);
      }

      for (Node node : network.getNodes())
      {
        node.tick(TIME_INCREMENT);
      }
    }

  }

  private static Network calculateShortestPaths() throws NetworkException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Dijikstra dijikstra = new Dijikstra(parser.getNetwork());
    long start = System.nanoTime();
    Map<Node, Map<Node, Path>> paths = dijikstra.run();
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
        totalCount++;
        System.out.println("\t" + node + ": " + path);
      }
    }
    double networkMetric = metricSum / totalCount;
    System.out.println("Network Metric Average: "
        + DecimalFormat.getNumberInstance().format(networkMetric));
    System.out.println("Dijikstra Execution time: " + (end - start) / 1000000
        + " ms");
    return parser.getNetwork();
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
