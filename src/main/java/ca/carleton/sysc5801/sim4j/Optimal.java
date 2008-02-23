package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;

public class Optimal
{
  private static final PartialDeriviateMetricFunction PARTIAL_DERIVIATE_METRIC_FUNCTION =
      new PartialDeriviateMetricFunction();

  private final static double DELTA = 0.00000001d;
  private final Network m_network;

  public Optimal(Network network)
  {
    m_network = network;
  }

  public Network getNetwork()
  {
    return m_network;
  }

  public double[][] run() throws NetworkException, IOException
  {
    double averageTraffic = 1d;
    Dijkstra dijikstra = new Dijkstra(getNetwork());
    dijikstra.calculate(Project.METRIC_FUNCTION);

    getNetwork().setAverageTraffic(averageTraffic);
    double[][] flow = getNetwork().getTrafficFlowVector();

    System.out.println("***Network Delay: "
        + DelayCalculator.getAverageDelay(getNetwork(), averageTraffic, flow));

    write(flow);
    double networkDelayDifference = 1d;

    double prevNetworkDelay =
        DelayCalculator.getAverageDelay(getNetwork(), averageTraffic, flow);

    System.out.println("Network Delay: " + prevNetworkDelay);

    for (int iteration = 0; networkDelayDifference > DELTA; iteration++)
    {
      // System.out.println("Flow(" + iteration + ")");
      // write(flow);

      dijikstra.calculate(PARTIAL_DERIVIATE_METRIC_FUNCTION);
      getNetwork().setAverageTraffic(averageTraffic);
      double[][] v = getNetwork().getTrafficFlowVector();

      // System.out.println("V(" + iteration + ")");
      // write(v);

      double alpha =
          getAlpha(new File(Project.getOutputDirectory(), "alpha" + iteration
              + ".csv"), averageTraffic, flow, v);

      flow = getNextFlow(alpha, flow, v);
      double networkDelay =
          DelayCalculator.getAverageDelay(getNetwork(), averageTraffic, flow);
      networkDelayDifference = Math.abs(prevNetworkDelay - networkDelay);
      prevNetworkDelay = networkDelay;
      System.out.println("Iteration: " + iteration + ": Network Delay "
          + networkDelay + " (Difference: " + networkDelayDifference + ")");
    }
    return flow;
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

  private double getAlpha(File file, double averageTraffic, double[][] f,
      double[][] v) throws IOException
  {
    FileWriter out = new FileWriter(file);
    double best = Double.MAX_VALUE;
    double bestAlpha = 0;
    boolean gettingBetter = true;
    for (double alpha = 0; alpha <= 1d; alpha += 0.0001d)
    {
      double possible = getAverageNetworkDelay(alpha, averageTraffic, f, v);
      out.write(Project.FORMAT.format(alpha));
      out.write(" ");
      if (possible >= 0)
      {
        out.write(Project.FORMAT.format(possible));
      }
      out.write("\r\n");
      if (possible > 0 && possible < best)
      {
        best = possible;
        bestAlpha = alpha;
        if (!gettingBetter)
        {
          System.out.println("!!!BETTER: alpha=" + Project.FORMAT.format(alpha)
              + " (delay=" + Project.FORMAT.format(best) + ")");
          gettingBetter = true;
        }
      }
      else if (gettingBetter)
      {
        System.out.println("Not better: alpha=" + Project.FORMAT.format(alpha)
            + " (delay=" + Project.FORMAT.format(best) + ")");
        gettingBetter = false;
      }
    }

    System.out.println("ALPHA: " + Project.FORMAT.format(bestAlpha)
        + " (delay=" + Project.FORMAT.format(best) + ")");
    out.close();
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
      double pij = link.getLengthInKm() * Project.DELAY_PER_KM;
      double ti = Project.PROCESSING_DELAY;
      double term2 = (pij + ti) / Project.BYTES_PER_PACKET;

      double result = term1 + term2;
      return result;

    }

  }

}
