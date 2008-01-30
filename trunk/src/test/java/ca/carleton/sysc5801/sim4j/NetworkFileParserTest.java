package ca.carleton.sysc5801.sim4j;

import java.io.File;
import java.io.IOException;
import java.util.Collection;

import junit.framework.Assert;

import org.junit.Test;

public class NetworkFileParserTest
{

  @Test
  public void testGetNetwork() throws IOException, NetworkException
  {
    File file = new File("./src/main/resources/ARPA.txt");
    NetworkFileParser parser = new NetworkFileParser(file);
    Network network = parser.getNetwork();
    Collection<Link> links = network.getLinks();
    Collection<Node> nodes = network.getNodes();
    Assert.assertEquals(26, links.size());
    Assert.assertEquals(21, nodes.size());
  }
}
