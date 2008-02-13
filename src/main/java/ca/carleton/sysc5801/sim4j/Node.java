package ca.carleton.sysc5801.sim4j;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Node
{
  private final int m_id;
  private final Map<Node, Link> m_links = new HashMap<Node, Link>();
  private final Map<Node, Path> m_paths = new HashMap<Node, Path>();

  Node(int id)
  {
    m_id = id;
  }

  public Node(Node i)
  {
    m_id = i.getId();
  }

  public int getId()
  {
    return m_id;
  }

  public void setPath(Node destination, Path path)
  {
    m_paths.put(destination, path);
  }

  public Path getPath(Node destination)
  {
    return m_paths.get(destination);
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
      if (!link.getJ().equals(link.getI()))
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
