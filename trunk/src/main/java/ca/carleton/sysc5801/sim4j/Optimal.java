package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;

public class Optimal
{
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
    new Dijikstra(getNetwork()).calculateShortestPaths();
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
