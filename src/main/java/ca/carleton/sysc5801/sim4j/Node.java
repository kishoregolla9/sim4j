package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;

public class Node
{
  private final int m_id;
  private final Collection<Link> m_links = new HashSet<Link>();

  Node(int id)
  {
    m_id = id;
  }

  public int getId()
  {
    return m_id;
  }

  public void addLink(Link link)
  {
    m_links.add(link);
  }

  public Collection<Link> getLinks()
  {
    return m_links;
  }

  public Collection<Node> getNeighbors()
  {
    Collection<Node> result = new ArrayList<Node>(getLinks().size());
    for (Link link : getLinks())
    {
      if (link.getStart().equals(this))
      {
        result.add(link.getEnd());
      }
      else
      {
        result.add(link.getStart());
      }
    }
    return result;
  }

  @Override
  public boolean equals(Object obj)
  {
    return obj == this || obj instanceof Node
        && ((Node) obj).getId() == this.getId();
  }

  @Override
  public int hashCode()
  {
    return m_id;
  }

  @Override
  public String toString()
  {
    return "Node " + getId();
  }
}
