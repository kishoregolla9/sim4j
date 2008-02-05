/**
 * 
 */
package ca.carleton.sysc5801.sim4j;

import java.util.LinkedList;

class PacketQueue
{
  private final double m_capacity;
  private final double m_delay;

  private double m_current = 0d;
  private final LinkedList<PacketQueue.PropogatingPacket> m_packets =
      new LinkedList<PacketQueue.PropogatingPacket>();
  private final PacketProcessor m_processor;

  PacketQueue(PacketProcessor processor, double capacity, double delay)
  {
    m_processor = processor;
    m_capacity = capacity;
    m_delay = delay;
  }

  double getDelay()
  {
    return m_delay;
  }

  boolean offer(Packet packet)
  {
    if (m_current + packet.getSize() < m_capacity)
    {
      m_current += packet.getSize();
      m_packets.add(new PacketQueue.PropogatingPacket(packet, getDelay()));
      return true;
    }
    return false;
  }

  void tick(double seconds)
  {
    for (PacketQueue.PropogatingPacket waitingPacket : m_packets)
    {
      waitingPacket.timeLeft -= seconds;
      if (waitingPacket.timeLeft <= 0)
      {
        Packet packet = waitingPacket.packet;
        m_current -= packet.getSize();
        m_processor.process(packet);
      }
    }
  }

  static class PropogatingPacket
  {
    Packet packet;
    double timeLeft;

    PropogatingPacket(Packet aPacket, double time)
    {
      packet = aPacket;
      timeLeft = time;
    }
  }

  public static interface PacketProcessor
  {
    void process(Packet packet);
  }

}