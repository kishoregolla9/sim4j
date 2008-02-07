package ca.carleton.sysc5801.sim4j;

public class DelayCalculator
{
  private static final int BYTES_PER_PACKET = 1500;
  private static final int BITS_PER_BYTE = 8;
  private static final double DELAY_PER_KM = 0.000005d; // 5us/km
  private static final double PROCESSING_DELAY = 0.001d; // 1ms

  public double getAverageDelay(Network network, double packetsPerSecond)
  {
    int numNodes = network.getNodes().size();
    double gamma = numNodes * (numNodes - 1) * packetsPerSecond;

    for (Node node : network.getNodes())
    {
      for (Node destination : network.getNodes())
      {
        if (!node.equals(destination))
        {
          Path path = node.getRoute(destination);
          for (Link link : path.getPath())
          {
            link.addFlow(packetsPerSecond * BYTES_PER_PACKET * BITS_PER_BYTE);
          }
        }
      }
    }

    double totalPackets = 0d;
    for (Link link : network.getLinks())
    {
      totalPackets += getAverageNumberOfPackets(link);
    }

    return totalPackets / gamma;
  }

  public double getAverageDelay(Link link)
  {
    double gamma = link.getFlow() / BYTES_PER_PACKET;
    double result = getAverageNumberOfPackets(link) / gamma;
    return result;
  }

  /**
   * @param link
   * @return D of Fij
   */
  private double getAverageNumberOfPackets(Link link)
  {
    double numberOfPacketsOnLinl =
        link.getFlow() / (link.getCapacity() - link.getFlow());
    double propogationDelay = link.getLengthInKm() * DELAY_PER_KM;
    double extraPacketsDueToDelays =
        (propogationDelay + PROCESSING_DELAY) * link.getFlow()
            / BYTES_PER_PACKET;
    double averageNumberOfPackets =
        numberOfPacketsOnLinl + extraPacketsDueToDelays;
    return averageNumberOfPackets;
  }
}
