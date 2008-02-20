package ca.carleton.sysc5801.sim4j;

public class DelayCalculator
{
  private static final int BITS_PER_BYTE = 8;
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
    if (gamma == 0)
    {
      return 0;
    }
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
    double propogationDelay = link.getLengthInKm() * Project.DELAY_PER_KM;
    double extraPacketsDueToDelays =
        (propogationDelay + Project.PROCESSING_DELAY) * flow / m_bytesPerPacket;
    double averageNumberOfPackets =
        numberOfPacketsOnLink + extraPacketsDueToDelays;
    return averageNumberOfPackets;
  }
}
