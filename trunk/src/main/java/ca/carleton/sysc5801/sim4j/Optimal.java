package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;

public class Optimal
{
  private final static double DELTA = 0.001d;

  private final Network m_network;

  public Optimal(Network network)
  {
    m_network = network;
  }

  public Network getNetwork()
  {
    return m_network;
  }

  private void run() throws NetworkException, IOException
  {
    Dijikstra dijikstra = new Dijikstra(getNetwork());
    Node node0 = getNetwork().getNodes().iterator().next();
    dijikstra.getShortestPaths(node0);
    double iterationDifference = 1;
    for (int i = 0; iterationDifference > DELTA; i++)
    {

    }

  }

  /**
   * 
   * @param link
   * @return the partial derivative of D(Fij)
   */
  private double getLinkMetricVector(Link link)
  {
    double term1 =
        (link.getCapacity() - link.getFlow())
            / Math.pow(link.getCapacity() - link.getFlow(), 2);
    double term2 =
        (link.getLengthInKm() * Project.DELAY_PER_KM + Project.PROCESSING_DELAY)
            / Project.BYTES_PER_PACKET;

    double result = term1 + term2;
    return Math.floor(result);

  }

  public static void main(String[] args) throws NetworkException, IOException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Network network = parser.getNetwork();

    Optimal optimal = new Optimal(network);
    optimal.run();
  }

}
