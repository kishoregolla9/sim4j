package ca.carleton.sysc5801.sim4j;

import java.io.File;

import org.junit.Test;

public class DijikstraTest
{

  @Test
  public void testRun() throws NetworkException
  {
    NetworkFileParser parser =
        new NetworkFileParser(new File("src/main/resources/small.txt"));
    Dijikstra dijikstra = new Dijikstra(parser.getNetwork());
    dijikstra.run();
  }
}
