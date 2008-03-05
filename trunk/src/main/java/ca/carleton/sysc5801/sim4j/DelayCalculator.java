package ca.carleton.sysc5801.sim4j;

/**
 * A Helper class to calculate delays for a link or the entire network
 */
public class DelayCalculator
{
  final static double EPSILON = 0.00001d;

  public static double getAverageDelay(Network network, double dpq,
      double[][] flow)
  {
    double result = 0d;
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
            double fij =
                flow[i][j] * dpq * 8 * RoutingComparison.BYTES_PER_PACKET;
            if (fij < (1 - EPSILON) * link.getCapacity())
            {
              term1 = fij / (link.getCapacity() - fij);
            }
            else
            {
              term1 = fij * (1 - EPSILON) * link.getCapacity() / EPSILON;
            }

            double delays =
                link.getLengthInKm() * RoutingComparison.DELAY_PER_KM
                    + RoutingComparison.PROCESSING_DELAY;
            double term2 = delays * fij / RoutingComparison.BYTES_PER_PACKET;

            result += term1 + term2;
          }
        }
      }
    }
    int numNodes = network.getNodes().size();
    double gamma = numNodes * (numNodes - 1) * dpq;
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
  public static double getAverageDelay(Link link, double packetsPerSecond)
  {
    double flow = link.getFlowInBps() * packetsPerSecond;
    if (flow == 0)
    {
      double propogationDelay =
          link.getLengthInKm() * RoutingComparison.DELAY_PER_KM;
      return propogationDelay + RoutingComparison.PROCESSING_DELAY;
    }

    double gamma = flow / RoutingComparison.BYTES_PER_PACKET;
    double result = getAverageNumberOfPackets(link, packetsPerSecond) / gamma;
    return result;
  }

  /**
   * @param link
   * @return D of Fij
   */
  private static double getAverageNumberOfPackets(Link link,
      double packetsPerSecond)
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

    double propogationDelay =
        link.getLengthInKm() * RoutingComparison.DELAY_PER_KM;
    double extraPacketsDueToDelays =
        (propogationDelay + RoutingComparison.PROCESSING_DELAY) * flow
            / RoutingComparison.BYTES_PER_PACKET;
    double averageNumberOfPackets =
        numberOfPacketsOnLink + extraPacketsDueToDelays;
    return averageNumberOfPackets;
  }
}
