package ca.carleton.sysc5801.sim4j;

public class Simulation
{
  private static final double TIME_INCREMENT = 0.000005d;
  private static final int PACKET_SIZE = 1500;

  private static double m_simTime = 0d;
  private static int m_droppedPackets = 0;
  private static int m_receivedPackets = 0;

  private static double m_totalTravelTime = 0;

  public static void simulate(Network network)
  {
    int totalPackets = 0;
    for (Node src : network.getNodes())
    {
      for (Node dest : network.getNodes())
      {
        if (!src.equals(dest))
        {
          src.sendPacket(new Packet(src, dest, PACKET_SIZE));
          totalPackets++;
        }
      }
    }

    while (Simulation.getReceivedPackets() + Simulation.getDroppedPackets() < totalPackets)
    {
      for (Link link : network.getLinks())
      {
        link.tick(TIME_INCREMENT);
      }

      for (Node node : network.getNodes())
      {
        node.tick(TIME_INCREMENT);
      }
      m_simTime += TIME_INCREMENT;
    }

    System.out.println("Dropped Packets: " + getDroppedPackets());
    System.out.println("Received Packets: " + getReceivedPackets());

    System.out.println("Average packet travel time: "
        + (m_totalTravelTime / getReceivedPackets() + "sec")
        + m_totalTravelTime);

  }

  public static double getSimTime()
  {
    return m_simTime;
  }

  public static void droppedPacket()
  {
    m_droppedPackets++;
  }

  public static void recievedPacket(Packet packet)
  {
    m_receivedPackets++;
    m_totalTravelTime += getSimTime() - packet.getStartTime();
  }

  public static int getDroppedPackets()
  {
    return m_droppedPackets;
  }

  public static int getReceivedPackets()
  {
    return m_receivedPackets;
  }
}
