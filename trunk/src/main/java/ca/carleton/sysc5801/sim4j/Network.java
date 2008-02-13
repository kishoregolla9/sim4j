package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Network
{
  private final Collection<Link> m_links;
  private final Map<Integer, Node> m_nodes;

  public Network(int initialCapacity)
  {
    m_links = new ArrayList<Link>(initialCapacity);
    m_nodes = new HashMap<Integer, Node>();
  }

  public void addLink(Link link)
  {
    m_links.add(link);
    m_nodes.put(link.getI().getId(), link.getI());
    m_nodes.put(link.getJ().getId(), link.getJ());
  }

  public Collection<Link> getLinks()
  {
    return m_links;
  }

  public Collection<Node> getNodes()
  {
    return m_nodes.values();
  }

  void addFlow(double flow)
  {
    for (Node node : getNodes())
    {
      for (Node destination : getNodes())
      {
        if (!node.equals(destination))
        {
          Path path = node.getPath(destination);
          for (Link link : path.getPath())
          {
            link.incrementFlow(flow);
          }
        }
      }
    }
  }

  double[][] getTrafficFlowVector()
  {
    double[][] result = new double[size()][size()];
    for (Node start : getNodes())
    {
      for (Node end : getNodes())
      {
        Link link = start.getLink(end);
        if (link != null)
        {
          result[start.getId() - 1][end.getId() - 1] = link.getFlow();
        }
      }
    }
    return result;
  }

  private int size()
  {
    return getNodes().size();
  }

  void resetFlow()
  {
    for (Link link : getLinks())
    {
      link.resetFlow();
    }
  }

  public Node getNode(int i)
  {
    return m_nodes.get(i);
  }

  public Link getLink(int i, int j)
  {
    return getNode(i).getLink(getNode(j));
  }

}
