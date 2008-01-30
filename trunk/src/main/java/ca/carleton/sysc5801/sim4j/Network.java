package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;

public class Network
{
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
    m_nodes.add(link.getStart());
    m_nodes.add(link.getEnd());
  }

  public Collection<Link> getLinks()
  {
    return m_links;
  }

  public Collection<Node> getNodes()
  {
    return m_nodes;
  }

}
