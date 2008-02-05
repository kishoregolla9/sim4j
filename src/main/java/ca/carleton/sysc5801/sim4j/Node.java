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

  /** infinite queue, with 1ms delay */
  private final PacketQueue m_packetQueue =
      new PacketQueue(new NodePacketProcessor(), Double.MAX_VALUE, 0.001d);

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

  /**
   * Send a new packet from this node as the source
   * 
   * @param packet
   */
  public void sendPacket(Packet packet)
  {
    Path path = m_routes.get(packet.getDestination());
    packet.setPath(path.getPath());
    forward(packet);
  }

  /**
   * Begin processing this packet and forward it to the next node in the
   * packet's path after the processing delay
   * 
   * @param packet
   */
  public void forward(Packet packet)
  {
    if (packet.getDestination().equals(this))
    {
      System.out.println("Received packet from: " + packet.getSource());
    }
    else
    {
      m_packetQueue.offer(packet);
    }
  }

  public void tick(double timeIncrement)
  {
    m_packetQueue.tick(timeIncrement);
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

  private final class NodePacketProcessor implements
      PacketQueue.PacketProcessor
  {
    /**
     * Forward the packet to the next stop on its path.
     */
    @Override
    public void process(Packet packet)
    {
      Link link = getLink(packet.getNextStop());
      link.send(packet);
    }
  }

}
