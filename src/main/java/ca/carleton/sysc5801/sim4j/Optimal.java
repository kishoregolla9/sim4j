package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;

public class Optimal
{
  private static final PartialDeriviateMetricFunction PARTIAL_DERIVIATE_METRIC_FUNCTION =
      new PartialDeriviateMetricFunction();

  private final static double DELTA = 0.00001d;
  private final Network m_network;

  public Optimal(Network network)
  {
    m_network = network;
  }

  public Network getNetwork()
  {
    return m_network;
  }

  public double run(double dpq) throws NetworkException, IOException
  {
    Dijkstra dijikstra = new Dijkstra(getNetwork());
    double[][] flow =
        dijikstra.calculate(RoutingComparison.SHORTEST_PATH_METRIC_FUNCTION);

    double averageDelay =
        DelayCalculator.getAverageDelay(getNetwork(), dpq, flow);
    System.out.println("***Network Delay (dpq=" + dpq + "): " + averageDelay);

    // write(flow);
    double delayDifference = 1d;
    double prevNetworkDelay = averageDelay;

    for (int iteration = 0; delayDifference > DELTA; iteration++)
    {
      // System.out.println("Flow(" + iteration + ")");
      // write(flow);

      double[][] v = dijikstra.calculate(PARTIAL_DERIVIATE_METRIC_FUNCTION);

      // System.out.println("V(" + iteration + ")");
      // write(v);

      double alpha =
          getAlpha(new File(RoutingComparison.getOutputDirectory(), "alpha"
              + iteration + ".csv"), dpq, flow, v);

      flow = getNextFlow(alpha, flow, v);
      averageDelay = DelayCalculator.getAverageDelay(getNetwork(), dpq, flow);
      delayDifference = Math.abs(prevNetworkDelay - averageDelay);
      prevNetworkDelay = averageDelay;
      System.out.println("Iteration: " + iteration + ": Network Delay "
          + RoutingComparison.FORMAT.format(averageDelay) + " (Difference: "
          + RoutingComparison.FORMAT.format(delayDifference) + ")");
    }
    // write(flow);
    return averageDelay;
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

  private double getAlpha(File file, double dpq, double[][] f, double[][] v)
      throws IOException
  {
    // FileWriter out = new FileWriter(file);
    double best = Double.MAX_VALUE;
    double bestAlpha = 0;
    for (double alpha = 0; alpha <= 1d; alpha += 0.0001d)
    {
      double possible = getAverageNetworkDelay(alpha, dpq, f, v);
      if (possible > 0 && possible < best)
      {
        best = possible;
        bestAlpha = alpha;
      }
    }

    // System.out.println("ALPHA: " + RoutingComparison.FORMAT.format(bestAlpha)
    // + " (delay=" + RoutingComparison.EFORMAT.format(best) + ")");
    return bestAlpha;
  }

  private double getAverageNetworkDelay(double alpha, double averageTraffic,
      double[][] f, double[][] v)
  {
    double[][] nextF = getNextFlow(alpha, f, v);
    return DelayCalculator.getAverageDelay(getNetwork(), averageTraffic, nextF);
  }

  private double[][] getNextFlow(double alpha, double[][] flow, double[][] v)
  {
    double[][] result = new double[flow.length][flow[0].length];
    for (int i = 0; i < flow.length; i++)
    {
      for (int j = 0; j < flow[i].length; j++)
      {
        double fij = flow[i][j] * 8 * RoutingComparison.BYTES_PER_PACKET;
        if (fij != Double.NaN)
        {
          double vij = v[i][j] * 8 * RoutingComparison.BYTES_PER_PACKET;
          result[i][j] =
              ((1 - alpha) * fij + alpha * vij)
                  / (8 * RoutingComparison.BYTES_PER_PACKET);
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
    // optimal.run(1d);
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
      double term1;
      if (link.getFlowInBps() < (1 - DelayCalculator.EPSILON)
          * link.getCapacity())
      {
        term1 =
            link.getCapacity()
                / Math.pow(link.getCapacity() - link.getFlowInBps(), 2);
      }
      else
      {
        term1 =
            (1 - DelayCalculator.EPSILON) * (1 - link.getCapacity())
                / Math.pow(DelayCalculator.EPSILON, 2);
      }
      double pij = link.getLengthInKm() * RoutingComparison.DELAY_PER_KM;
      double ti = RoutingComparison.PROCESSING_DELAY;
      double term2 = (pij + ti) / RoutingComparison.BYTES_PER_PACKET;

      double result = term1 + term2;
      return result;

    }

  }

}
