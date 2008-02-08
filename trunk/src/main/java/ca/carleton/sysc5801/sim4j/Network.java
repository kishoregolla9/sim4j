package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;

public class Network
{
  private static final int BITS_PER_BYTE = 8;

  private final Collection<Link> m_links;
  private final Collection<Node> m_nodes;

  public Network(int initialCapacity)
  {
    m_links = new ArrayList<Link>(initialCapacity);
    m_nodes = new HashSet<Node>(initialCapacity * 2);
  }

  public void addLink(Link link)
  {
    m_links.add(link);
    m_nodes.add(link.getI());
    m_nodes.add(link.getJ());
  }

  public Collection<Link> getLinks()
  {
    return m_links;
  }

  public Collection<Node> getNodes()
  {
    return m_nodes;
  }

  void addFlow(double packetsPerSecond, int bytesPerPacket)
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
            link.addFlow(packetsPerSecond * bytesPerPacket * BITS_PER_BYTE);
          }
        }
      }
    }
  }

  void resetFlow()
  {
    for (Link link : getLinks())
    {
      link.resetFlow();
    }
  }

}
