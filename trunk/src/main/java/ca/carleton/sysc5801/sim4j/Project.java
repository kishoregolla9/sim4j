package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DecimalFormat;

public class Project
{
  public static final DecimalFormat FORMAT = new DecimalFormat("#0.00000");
  private static final int BYTES_PER_PACKET = 1500;

  public static void main(String[] args) throws NetworkException, IOException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/ARPA.txt"));
    Network network = parser.getNetwork();

    Project project = new Project();
    project.run(network);
  }

  private void run(Network network) throws NetworkException, IOException
  {
    Dijikstra dijikstra = new Dijikstra(network);

    long start = System.nanoTime();
    dijikstra.calculateShortestPaths();
    long end = System.nanoTime();
    System.out.println("Dijikstra Execution time: " + (end - start) / 1000000
        + " ms");
    System.out.flush();
    calculateAverageDelays(network);
  }

  private void calculateAverageDelays(Network network) throws IOException
  {
    DelayCalculator delayCalculator = new DelayCalculator(BYTES_PER_PACKET);

    String sep = System.getProperty("line.separator");

    network.addFlow();

    double increment = 0.0005d;
    double max = 1.2d;
    FileWriter file = new FileWriter("networkDelay.csv");
    for (double d = increment; d < max; d += increment)
    {
      double delay = delayCalculator.getAverageDelay(network, d);
      file.write(FORMAT.format(d) + " " + FORMAT.format(delay) + sep);
    }
    file.close();

    for (Link link : network.getLinks())
    {
      double averageDelay = delayCalculator.getAverageDelay(link, 1);
      System.out.println("Link: " + link.getI().getId() + "-"
          + link.getJ().getId() + " -- Average delay: "
          + FORMAT.format(averageDelay));
    }
  }

}
