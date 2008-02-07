/**
 * 
 */
package ca.carleton.sysc5801.sim4j;

import java.util.LinkedList;

class PacketQueue
{
  private static final int BITS_PER_BYTE = 8;
  private final double m_bitRate;
  private final double m_delay;

  private PropogatingPacket m_current = null;
  private final LinkedList<PropogatingPacket> m_packets =
      new LinkedList<PropogatingPacket>();
  private final PacketProcessor m_processor;

  /**
   * 
   * @param processor
   *          what to do with the packet after complete
   * @param bitRate
   * @param delay
   *          processing delay
   */
  PacketQueue(PacketProcessor processor, double bitRate, double delay)
  {
    m_processor = processor;
    m_bitRate = bitRate;
    m_delay = delay;
  }

  double getDelay(int packetSize)
  {
    return m_delay + packetSize * BITS_PER_BYTE / m_bitRate;
  }

  boolean offer(Packet packet)
  {
    PropogatingPacket propogatingPacket =
        new PropogatingPacket(packet, getDelay(packet.getSize()));
    if (m_current == null)
    {
      m_current = propogatingPacket;
    }
    else
    {
      m_packets.add(propogatingPacket);
    }
    return true;
  }

  void tick(double seconds)
  {
    if (m_current != null)
    {
      m_current.timeLeft -= seconds;
      if (m_current.timeLeft <= 0)
      {
        Packet packet = m_current.packet;
        m_processor.process(packet);
        m_current = m_packets.get(0);
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