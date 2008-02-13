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
    double averageTraffic = 1;
    Dijikstra dijikstra = new Dijikstra(getNetwork());
    dijikstra.calculateShortestPaths(Project.METRIC_FUNCTION);

    getNetwork().addFlow(averageTraffic);
    double[][] f = getNetwork().getTrafficFlowVector();
    double iterationDifference = 1;

    double prevAverageNetworkDelay = getAverageNetworkDelay(averageTraffic, f);

    for (int it = 0; iterationDifference > DELTA; it++)
    {
      getNetwork().resetFlow();
      dijikstra.calculateShortestPaths(new PartialDerivateMetricFunction());
      getNetwork().addFlow(averageTraffic);

      double[][] v = getNetwork().getTrafficFlowVector();
      double alpha = getAlpha(averageTraffic, f, v);

      f = getNextF(alpha, f, v);
      double networkDelay = getAverageNetworkDelay(averageTraffic, f);
      iterationDifference = prevAverageNetworkDelay - networkDelay;
      prevAverageNetworkDelay = networkDelay;
    }
  }

  private double getAlpha(double averageTraffic, double[][] f, double[][] v)
  {
    double best = Double.MAX_VALUE;
    double bestAlpha = 0;
    for (double alpha = 0; alpha < 1.0d; alpha += 0.001d)
    {
      double possible = getAverageNetworkDelay(alpha, averageTraffic, f, v);
      if (possible < best)
      {
        best = possible;
        bestAlpha = alpha;
      }
    }
    return bestAlpha;
  }

  private double getAverageNetworkDelay(double alpha, double averageTraffic,
      double[][] f, double[][] v)
  {
    double[][] nextF = getNextF(alpha, f, v);
    return getAverageNetworkDelay(averageTraffic, nextF);
  }

  private double getAverageNetworkDelay(double averageTraffic, double[][] nextF)
  {
    int numNodes = getNetwork().getNodes().size();
    double gamma = numNodes * (numNodes - 1) * averageTraffic;
    double result = 0;
    for (int i = 0; i < nextF.length; i++)
    {
      for (int j = 0; j < nextF.length; j++)
      {
        Link link = getNetwork().getLink(i + 1, j + 1);
        if (link != null)
        {
          double term1 = nextF[i][j] / (link.getCapacity() - nextF[i][j]);
          double term2 =
              (link.getLengthInKm() * Project.DELAY_PER_KM + Project.PROCESSING_DELAY)
                  * nextF[i][j] / Project.BYTES_PER_PACKET;
          result += term1 + term2;
        }
      }
    }

    result = result / gamma;
    return result;
  }

  private double[][] getNextF(double alpha, double[][] f, double[][] v)
  {
    double[][] result = new double[f.length][f.length];
    for (int i = 0; i < f.length; i++)
    {
      for (int j = 0; j < f.length; j++)
      {
        result[i][j] = (1 - alpha) * f[i][j] + alpha * v[i][j];
      }
    }
    return result;
  }

  /**
   * @param link
   * @return the partial derivative of D(Fij)
   */
  private double getLinkMetricVector(Link link)
  {
    double term1 =
        link.getCapacity() / Math.pow(link.getCapacity() - link.getFlow(), 2);
    double pij = link.getLengthInKm() * Project.DELAY_PER_KM;
    double ti = Project.PROCESSING_DELAY;
    double term2 = (pij + ti) / Project.BYTES_PER_PACKET;

    double result = term1 + term2;
    return result;

  }

  public static void main(String[] args) throws NetworkException, IOException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Network network = parser.getNetwork();

    Optimal optimal = new Optimal(network);
    optimal.run();
  }

  class PartialDerivateMetricFunction implements MetricFunction
  {

    @Override
    public double getMetric(Link link)
    {
      return getLinkMetricVector(link);
    }

  }

}
