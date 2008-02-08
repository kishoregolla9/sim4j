package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;
import java.util.Collection;

import org.junit.Assert;
import org.junit.Test;

public class NetworkFileParserTest
{

  @Test
  public void testGetNetwork() throws IOException, NetworkException
  {
    File file = new File("./src/main/resources/small.txt");
    NetworkFileParser parser = new NetworkFileParser(file);
    Network network = parser.getNetwork();
    Collection<Link> links = network.getLinks();
    Collection<Node> nodes = network.getNodes();
    Assert.assertEquals(4, links.size());
    Assert.assertEquals(4, nodes.size());

    for (Node next : network.getNodes())
    {
      for (Link link : next.getLinks())
      {
        System.out.println(link);
      }
    }
  }
}
