package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Node
{
  private final int m_id;
  private final Map<Node, Link> m_links = new HashMap<Node, Link>();
  private final Map<Node, Path> m_routes = new HashMap<Node, Path>();

  Node(int id)
  {
    m_id = id;
  }

  public int getId()
  {
    return m_id;
  }

  public void setRoute(Node destination, Path route)
  {
    m_routes.put(destination, route);
  }

  public Path getRoute(Node destination)
  {
    return m_routes.get(destination);
  }

  public void addLink(Link link)
  {
    m_links.put(link.getOther(this), link);
  }

  public Collection<Link> getLinks()
  {
    return m_links.values();
  }

  public Link getLink(Node other)
  {
    return m_links.get(other);
  }

  public Collection<Node> getNeighbors()
  {
    Collection<Node> result = new ArrayList<Node>(getLinks().size());
    for (Link link : getLinks())
    {
      if (link.getI().equals(this))
      {
        result.add(link.getJ());
      }
      else
      {
        result.add(link.getI());
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
