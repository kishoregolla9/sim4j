package ca.carleton.sysc5801.sim4j;

public class Link
{
  private static final double DELAY_PER_KM = 0.000005d;
  private final Node m_start;
  private final Node m_end;
  private final double m_capacity;
  private final double m_lengthInKm;
  private final PacketQueue m_packetQueue;

  public Link(Node i, Node j, double capacity, double km)
  {
    m_start = i;
    m_end = j;
    m_capacity = capacity;
    m_lengthInKm = km;
    i.addLink(this);
    j.addLink(this);

    m_packetQueue =
        new PacketQueue(new LinkPacketProcessor(), capacity, km * DELAY_PER_KM);
  }

  public Node getStart()
  {
    return m_start;
  }

  public Node getEnd()
  {
    return m_end;
  }

  public double getCapacity()
  {
    return m_capacity;
  }

  public double getLengthInKm()
  {
    return m_lengthInKm;
  }

  public Node getOther(Node node)
  {
    if (node.equals(getStart()))
    {
      return getEnd();
    }
    return getStart();
  }

  public void send(Packet packet)
  {
    if (!m_packetQueue.offer(packet))
    {
      Simulation.droppedPacket();
    }
  }

  public void tick(double timeIncrement)
  {
    m_packetQueue.tick(timeIncrement);
  }

  @Override
  public int hashCode()
  {
    return getStart().getId() | getEnd().getId() << 16;
  }

  @Override
  public boolean equals(Object obj)
  {
    Link that;
    return obj == this || obj instanceof Link
        && (that = (Link) obj).getStart().equals(this.getStart())
        && that.getEnd().equals(this.getEnd())
        && that.getCapacity() == this.getCapacity()
        && that.getLengthInKm() == this.getLengthInKm();
  }

  @Override
  public String toString()
  {
    return "Link: " + getStart() + " to " + getEnd() + "\t" + getLengthInKm()
        + "km\t" + getCapacity() + "bps";
  }

  private final class LinkPacketProcessor implements
      PacketQueue.PacketProcessor
  {
    @Override
    public void process(Packet packet)
    {
      Node nextStop = packet.getNextStop();
      nextStop.forward(packet);
    }
  }

}
