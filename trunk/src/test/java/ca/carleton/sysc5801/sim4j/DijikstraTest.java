package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.util.Map;

import org.junit.Test;

public class DijikstraTest
{

  @Test
  public void testRun() throws NetworkException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/small.txt"));
    Dijikstra dijikstra = new Dijikstra(parser.getNetwork());
    Map<Node, Map<Node, Path>> paths = dijikstra.run();
    for (Node startNode : paths.keySet())
    {
      System.out.println("Starting at " + startNode + " to...");
      Map<Node, Path> map = paths.get(startNode);
      for (Node node : map.keySet())
      {
        System.out.println("\t" + node + ": " + map.get(node));
      }
    }
  }
}
