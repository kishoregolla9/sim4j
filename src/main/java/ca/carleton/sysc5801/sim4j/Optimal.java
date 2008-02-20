package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;

public class Optimal
{
  private static final PartialDeriviateMetricFunction PARTIAL_DERIVIATE_METRIC_FUNCTION =
      new PartialDeriviateMetricFunction();

  private final static double DELTA = 0.000001d;
  private final static double EPSILON = 0.0000001d;

  private final Network m_network;

  public Optimal(Network network)
  {
    m_network = network;
  }

  public Network getNetwork()
  {
    return m_network;
  }

  public void run() throws NetworkException, IOException
  {
    double averageTraffic = 1.0d * 1500 * 8;
    Dijkstra dijikstra = new Dijkstra(getNetwork());
    dijikstra.calculateShortestPaths(Project.METRIC_FUNCTION);
    getNetwork().resetFlow();
    getNetwork().addFlow(averageTraffic);
    double[][] flow = getNetwork().getTrafficFlowVector();
    double networkDelayDifference = 1d;

    double prevNetworkDelay = getAverageNetworkDelay(averageTraffic, flow);

    System.out.println("Network Delay: " + prevNetworkDelay);

    for (int iteration = 0; networkDelayDifference > DELTA; iteration++)
    {
      // System.out.println("Flow(" + iteration + ")");
      // write(flow);

      dijikstra.calculateShortestPaths(PARTIAL_DERIVIATE_METRIC_FUNCTION);
      getNetwork().resetFlow();
      getNetwork().addFlow(averageTraffic);
      double[][] v = getNetwork().getTrafficFlowVector();

      // System.out.println("V(" + iteration + ")");
      // write(v);

      double alpha = getAlpha(averageTraffic, flow, v);

      flow = getNextFlow(alpha, flow, v);
      double networkDelay = getAverageNetworkDelay(averageTraffic, flow);
      networkDelayDifference = Math.abs(prevNetworkDelay - networkDelay);
      prevNetworkDelay = networkDelay;
      System.out.println("Iteration: " + iteration + ": Network Delay "
          + networkDelay + " (Difference: " + networkDelayDifference + ")");
    }

  }

  private void write(double[][] flow)
  {
    System.out.print("  ");
    for (int j = 0; j < flow[0].length; j++)
    {
      System.out.print("    " + (j + 1) + "    ,");
    }
    System.out.println();
    for (int i = 0; i < flow.length; i++)
    {
      System.out.print(i + 1 + ":");

      for (int j = 0; j < flow.length; j++)
      {
        if (i == j || new Double(flow[i][j]).isNaN())
        {
          System.out.print("         ,");
        }
        else
        {
          System.out
              .print(new DecimalFormat("000000.00").format(flow[i][j]) + ',');
        }
      }
      System.out.println();
    }

  }

  private double getAlpha(double averageTraffic, double[][] f, double[][] v)
  {
    double best = Double.MAX_VALUE;
    double bestAlpha = 1;
    for (double alpha = 1; alpha >= 0d; alpha -= 0.001d)
    {
      double possible = getAverageNetworkDelay(alpha, averageTraffic, f, v);
      if (possible < best)
      {
        best = possible;
        bestAlpha = alpha;
        // System.out.println("!!!BETTER: " + alpha);
      }
      else
      {
        // System.out.println("Not better: " + alpha);
      }
    }

    System.out.println("ALPHA: " + bestAlpha);

    return bestAlpha;
  }

  private double getAverageNetworkDelay(double alpha, double averageTraffic,
      double[][] f, double[][] v)
  {
    double[][] nextF = getNextFlow(alpha, f, v);
    return getAverageNetworkDelay(averageTraffic, nextF);
  }

  private double getAverageNetworkDelay(double averageTraffic, double[][] flow)
  {
    double result = 0;
    for (int i = 0; i < flow.length; i++)
    {
      for (int j = 0; j < flow[i].length; j++)
      {
        if (i != j)
        {
          Link link = getNetwork().getLink(i + 1, j + 1);
          if (link != null)
          {
            double term1;
            if (flow[i][j] < (1 - EPSILON) * link.getCapacity())
            {
              term1 = flow[i][j] / (link.getCapacity() - flow[i][j]);
            }
            else
            {
              double term1a = flow[i][j] / EPSILON;
              double term1b = (1 - EPSILON) * link.getCapacity() / EPSILON;
              term1 = term1a * term1b;
            }

            double delays =
                link.getLengthInKm() * Project.DELAY_PER_KM
                    + Project.PROCESSING_DELAY;
            double term2 = delays * flow[i][j] / Project.BYTES_PER_PACKET;

            result += term1 + term2;
          }
        }
      }
    }
    int numNodes = getNetwork().getNodes().size();
    double gamma = numNodes * (numNodes - 1) * averageTraffic;
    result = result / gamma;
    return result;
  }

  private double[][] getNextFlow(double alpha, double[][] flow, double[][] v)
  {
    double[][] result = new double[flow.length][flow[0].length];
    for (int i = 0; i < flow.length; i++)
    {
      for (int j = 0; j < flow[i].length; j++)
      {
        if (flow[i][j] != Double.NaN)
        {
          result[i][j] = (1 - alpha) * flow[i][j] + alpha * v[i][j];
        }
      }
    }
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

  static class PartialDeriviateMetricFunction implements MetricFunction
  {

    @Override
    public double getMetric(Link link)
    {
      return getLinkMetricVector(link);
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

  }

}
