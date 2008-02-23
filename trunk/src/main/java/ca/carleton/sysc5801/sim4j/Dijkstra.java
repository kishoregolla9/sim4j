package ca.carleton.sysc5801.sim4j;

import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

public class Dijkstra
{
  private final Network m_network;

  public Dijkstra(Network network)
  {
    m_network = network;
  }

  /**
   * @param startNode
   * @return a map of paths starting at the given startNode, to the destination
   *         that is the key of the map
   * @throws NetworkException
   */
  Map<Node, Path> calculate(Node startNode, MetricFunction function)
      throws NetworkException
  {
    // init temporary set to hold all nodes
    // result is the cost to every other node
    Map<Node, Double> temporary = new HashMap<Node, Double>();
    Map<Node, Double> permanent = new HashMap<Node, Double>();
    Node[] predecessor = new Node[getNetwork().getNodes().size() + 1];

    init(startNode, temporary, permanent, predecessor, function);
    Node minCostNode = startNode;
    while (temporary.size() > 0)
    {
      minCostNode = getMinimumCost(temporary);
      Double metric = temporary.get(minCostNode);
      permanent.put(minCostNode, metric);
      temporary.remove(minCostNode);
      update(temporary, predecessor, minCostNode, metric, function);
    }
    Map<Node, Path> result = new HashMap<Node, Path>();

    for (int id = 1; id <= getNetwork().getNodes().size(); id++)
    {
      Path path = new Path(startNode, function);
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
      Map<Node, Double> permanent, Node[] predecessor, MetricFunction function)
  {
    for (Node node : getNetwork().getNodes())
    {
      temporary.put(node, Double.POSITIVE_INFINITY);
    }
    temporary.put(startNode, 0d);

    Path path = new Path(startNode, function);
    path.addLink(new Link(startNode, startNode, 0, 0));
    predecessor[startNode.getId()] = startNode;
  }

  private void update(Map<Node, Double> temporary, Node[] predecessor, Node i,
      Double metric, MetricFunction function)
  {

    for (Link link : i.getLinks())
    {
      Node j = link.getOther(i);
      if (temporary.containsKey(j))
      {
        // d(j)
        double costSoFar = temporary.get(j);
        // d(i) + cij
        double potentialCost = metric + function.getMetric(link);
        if (costSoFar > potentialCost)
        {
          temporary.put(j, potentialCost);
          predecessor[j.getId()] = i;
        }
      }
    }
  }

  private Network getNetwork()
  {
    return m_network;
  }

  /**
   * Run Dijkstra with the given metric function. Sets the paths on each node in
   * the network based on Dijkstra.
   * 
   * @param function
   * @throws NetworkException
   */
  void calculate(MetricFunction function) throws NetworkException
  {
    Map<Node, Map<Node, Path>> paths = new HashMap<Node, Map<Node, Path>>();
    for (Node startNode : getNetwork().getNodes())
    {
      paths.put(startNode, calculate(startNode, function));
    }

    for (Node startNode : paths.keySet())
    {
      Map<Node, Path> map = paths.get(startNode);
      for (Node destination : map.keySet())
      {
        Path path = map.get(destination);
        startNode.setPath(destination, path);
      }
    }
  }

}
