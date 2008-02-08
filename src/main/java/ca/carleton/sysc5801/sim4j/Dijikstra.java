package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
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
      throws NetworkException
  {
    // init temporary set to hold all nodes
    // result is the cost to every other node
    Map<Node, Double> temporary = new HashMap<Node, Double>();
    Map<Node, Double> permanent = new HashMap<Node, Double>();
    Node[] predecessor = new Node[getNetwork().getNodes().size() + 1];

    init(startNode, temporary, permanent, predecessor);
    Node minCostNode = startNode;
    while (temporary.size() > 0)
    {
      minCostNode = getMinimumCost(temporary);
      Double metric = temporary.get(minCostNode);
      permanent.put(minCostNode, metric);
      temporary.remove(minCostNode);
      update(temporary, predecessor, minCostNode, metric);
    }
    Map<Node, Path> result = new HashMap<Node, Path>();

    for (int id = 1; id <= getNetwork().getNodes().size(); id++)
    {
      Path path = new Path(startNode, FUNCTION);
      Node prev = getNode(id);
      result.put(prev, path);
      Node node = predecessor[id];
      LinkedList<Link> list = new LinkedList<Link>();
      while (!node.equals(startNode))
      {
        list.add(getNode(prev.getId()).getLink(node));
        prev = node;
        node = predecessor[prev.getId()];
      }
      list.add(getNode(prev.getId()).getLink(node));
      Collections.reverse(list);
      path.addLinks(list);

    }

    return result;
  }

  Node getNode(int id) throws NetworkException
  {
    Collection<Node> nodes = getNetwork().getNodes();
    for (Node node : nodes)
    {
      if (node.getId() == id)
      {
        return node;
      }
    }
    throw new NetworkException("Node " + id + " not found!");
  }

  private Node getMinimumCost(Map<Node, Double> temporary)
  {
    double min = Double.MAX_VALUE;
    Node result = null;
    for (Node node : temporary.keySet())
    {
      double possible = temporary.get(node);
      if (possible < min)
      {
        min = possible;
        result = node;
      }
    }
    return result;

  }

  private void init(Node startNode, Map<Node, Double> temporary,
      Map<Node, Double> permanent, Node[] predecessor)
  {
    for (Node node : getNetwork().getNodes())
    {
      temporary.put(node, Double.POSITIVE_INFINITY);
    }
    temporary.put(startNode, 0d);

    Path path = new Path(startNode, FUNCTION);
    path.addLink(new Link(startNode, startNode, 0, 0));
    predecessor[startNode.getId()] = startNode;
  }

  private void update(Map<Node, Double> temporary, Node[] predecessor, Node i,
      Double metric)
  {

    for (Link link : i.getLinks())
    {
      Node j = link.getOther(i);
      if (temporary.containsKey(j))
      {
        // d(j)
        double costSoFar = temporary.get(j);
        // d(i) + cij
        double potentialCost = metric + FUNCTION.getMetric(link);
        if (costSoFar > potentialCost)
        {
          temporary.put(j, potentialCost);
          predecessor[j.getId()] = i;
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
    long start = System.nanoTime();
    calculateShortestPaths();
    long end = System.nanoTime();
    System.out.println("Dijikstra Execution time: " + (end - start) / 1000000
        + " ms");

    calculateAverageDelays();
  }

  private void calculateAverageDelays() throws IOException
  {
    DelayCalculator delayCalculator = new DelayCalculator();

    double increment = 0.025d;
    int max = 5;
    FileWriter file = new FileWriter("networkDelay.csv");
    file.write("Packets Per Second,Average Delay\n");
    for (double d = 0; d < max; d += increment)
    {
      double delay = delayCalculator.getAverageDelay(getNetwork(), d);
      file.write(d + "," + delay + "\n");
    }
    file.close();

    for (Link link : getNetwork().getLinks())
    {
      double averageDelay = delayCalculator.getAverageDelay(link);
      System.out.println(link + " -- Average delay: " + averageDelay);
    }

  }

  private Network getNetwork()
  {
    return m_network;
  }

  void calculateShortestPaths() throws NetworkException
  {
    Map<Node, Map<Node, Path>> paths = new HashMap<Node, Map<Node, Path>>();
    for (Node startNode : getNetwork().getNodes())
    {
      paths.put(startNode, getShortestPaths(startNode));
    }

    for (Node startNode : paths.keySet())
    {
      System.out.println("Starting at " + startNode + " to...");
      Map<Node, Path> map = paths.get(startNode);
      for (Node desination : map.keySet())
      {
        Path path = map.get(desination);
        startNode.setPath(desination, path);
        System.out.println("\t" + desination + ": " + path);
      }
    }
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
