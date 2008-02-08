package ca.carleton.sysc5801.sim4j;

public class DelayCalculator
{
  private static final int BITS_PER_BYTE = 8;
  private static final double DELAY_PER_KM = 0.000005d; // 5us/km
  private static final double PROCESSING_DELAY = 0.001d; // 1ms
  private final int m_bytesPerPacket;

  public DelayCalculator(int bytesPerPacket)
  {
    m_bytesPerPacket = bytesPerPacket;
  }

  public double getAverageDelay(Network network, double packetsPerSecond)
  {
    int numNodes = network.getNodes().size();
    double gamma = numNodes * (numNodes - 1) * packetsPerSecond;

    double totalPackets = 0d;
    for (Link link : network.getLinks())
    {
      totalPackets += getAverageNumberOfPackets(link, packetsPerSecond);
    }

    return totalPackets / gamma;
  }

  public double getAverageDelay(Link link, double packetsPerSecond)
  {
    double flow = getFlowInBps(link, packetsPerSecond);
    double gamma = flow / m_bytesPerPacket;
    double result = getAverageNumberOfPackets(link, packetsPerSecond) / gamma;
    return result;
  }

  private double getFlowInBps(Link link, double packetsPerSecond)
  {
    return link.getFlow() * BITS_PER_BYTE * m_bytesPerPacket * packetsPerSecond;
  }

  /**
   * @param link
   * @return D of Fij
   */
  private double getAverageNumberOfPackets(Link link, double packetsPerSecond)
  {
    double flow = getFlowInBps(link, packetsPerSecond);
    double numberOfPacketsOnLink = flow / (link.getCapacity() - flow);
    double propogationDelay = link.getLengthInKm() * DELAY_PER_KM;
    double extraPacketsDueToDelays =
        (propogationDelay + PROCESSING_DELAY) * flow / m_bytesPerPacket;
    double averageNumberOfPackets =
        numberOfPacketsOnLink + extraPacketsDueToDelays;
    return averageNumberOfPackets;
  }
}
