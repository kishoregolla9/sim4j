package ca.carleton.sysc5801.sim4j;

import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;

public class Packet
{
  private final int m_size;
  private final Node m_source;
  private final Node m_destination;
  private Iterator<Node> m_path;

  private final double m_startTime;

  Packet(Node source, Node destination, int size)
  {
    m_startTime = Simulation.getSimTime();
    m_source = source;
    m_destination = destination;
    m_size = size;
  }

  public int getSize()
  {
    return m_size;
  }

  public void setPath(List<Link> links)
  {
    List<Node> path = new LinkedList<Node>();
    Node node = getSource();
    for (Link link : links)
    {
      node = link.getOther(node);
      path.add(node);
    }
    m_path = path.iterator();
  }

  public Node getNextStop()
  {
    return m_path.next();
  }

  public Node getSource()
  {
    return m_source;
  }

  public Node getDestination()
  {
    return m_destination;
  }

  public double getStartTime()
  {
    return m_startTime;
  }

}
