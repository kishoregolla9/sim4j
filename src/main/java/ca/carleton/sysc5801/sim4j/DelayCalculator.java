package ca.carleton.sysc5801.sim4j;

/**
 * A Helper class to calculate delays for a link or the entire network
 */
public class DelayCalculator
{
  private static final int BITS_PER_BYTE = 8;
  private final int m_bytesPerPacket;
  final static double EPSILON = 0.00001d;

  public DelayCalculator(int bytesPerPacket)
  {
    m_bytesPerPacket = bytesPerPacket;
  }

  public double getAverageDelay(Network network, double packetsPerSecond)
  {
    network.setAverageTraffic(1);
    return getAverageDelay(network, packetsPerSecond, network
        .getTrafficFlowVector());
    // double totalPackets = 0d;
    // for (Link link : network.getLinks())
    // {
    // totalPackets += getAverageNumberOfPackets(link, packetsPerSecond);
    // }
    //
    // int numNodes = network.getNodes().size();
    // double gamma = numNodes * (numNodes - 1) * packetsPerSecond;
    //
    // return totalPackets / gamma;
  }

  public static double getAverageDelay(Network network, double averageTraffic,
      double[][] flow)
  {
    double result = 0;
    for (int i = 0; i < flow.length; i++)
    {
      for (int j = 0; j < flow[i].length; j++)
      {
        if (i != j)
        {
          Link link = network.getLink(i + 1, j + 1);
          if (link != null)
          {
            double term1;
            double fij = flow[i][j];
            if (fij < (1 - EPSILON) * link.getCapacity())
            {
              term1 = fij / (link.getCapacity() - fij);
            }
            else
            {
              double term1a = fij / EPSILON;
              double term1b =
                  (1 - EPSILON) * (1 - link.getCapacity()) / EPSILON;
              term1 = term1a * term1b;
            }

            double delays =
                link.getLengthInKm() * Project.DELAY_PER_KM
                    + Project.PROCESSING_DELAY;
            double term2 = delays * fij / Project.BYTES_PER_PACKET;

            result += term1 + term2;
          }
        }
      }
    }
    int numNodes = network.getNodes().size();
    double gamma = numNodes * (numNodes - 1) * averageTraffic;
    result = result / gamma;
    return result;
  }

  /**
   * 
   * @param link
   * @param packetsPerSecond
   * @return the average delay per packet on this link, (which is just the
   *         propagation and processing delay if there is no flow allocated to
   *         this link)
   */
  public double getAverageDelay(Link link, double packetsPerSecond)
  {
    double flow = link.getFlowInBps() * packetsPerSecond;
    if (flow == 0)
    {
      double propogationDelay = link.getLengthInKm() * Project.DELAY_PER_KM;
      return propogationDelay + Project.PROCESSING_DELAY;
    }

    double gamma = flow / m_bytesPerPacket;
    double result = getAverageNumberOfPackets(link, packetsPerSecond) / gamma;
    return result;
  }

  /**
   * @param link
   * @return D of Fij
   */
  private double getAverageNumberOfPackets(Link link, double packetsPerSecond)
  {
    double flow = link.getFlowInBps() * packetsPerSecond;
    double numberOfPacketsOnLink;
    if (flow < (1 - EPSILON) * link.getCapacity())
    {
      numberOfPacketsOnLink = flow / (link.getCapacity() - flow);
    }
    else
    {
      numberOfPacketsOnLink =
          flow / EPSILON * (1 - EPSILON) * (1 - link.getCapacity()) / EPSILON;
    }

    double propogationDelay = link.getLengthInKm() * Project.DELAY_PER_KM;
    double extraPacketsDueToDelays =
        (propogationDelay + Project.PROCESSING_DELAY) * flow / m_bytesPerPacket;
    double averageNumberOfPackets =
        numberOfPacketsOnLink + extraPacketsDueToDelays;
    return averageNumberOfPackets;
  }
}
