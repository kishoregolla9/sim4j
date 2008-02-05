package ca.carleton.sysc5801.sim4j;

public class Simulation
{
  private static int m_simTime = 0;
  private static int m_droppedPackets = 0;

  public static int getSimTime()
  {
    return m_simTime;
  }

  public static void droppedPacket()
  {
    m_droppedPackets++;
  }
}
