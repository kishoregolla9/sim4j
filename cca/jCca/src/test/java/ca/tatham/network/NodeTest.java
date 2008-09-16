package ca.tatham.network;

import java.util.List;

import junit.framework.TestCase;
import ca.tatham.network.factory.NetworkCreator;
import ca.tatham.network.factory.NetworkCreator.NetworkShape;

public class NodeTest extends TestCase
{
  public void testShortedDistanceMatrix()
  {
    Network network = NetworkCreator.getNetwork(NetworkShape.SQUARE, 0, 5, 1);
    Node[] nodes = network.getNodes();
    for (int n = 0; n < nodes.length; n++)
    {
      if (!nodes[n].getNeighbours().isEmpty())
      {
        System.out.println("*** Shorted Distance Matrix for " + nodes[n]);
        List<Node> local = nodes[n].getLocalNetwork(2);
        double[][] shortestDistanceMatrix = nodes[n].getShortestDistanceMatrix(local);
        for (int i = 0; i < shortestDistanceMatrix.length; i++)
        {
          for (int j = 0; j < shortestDistanceMatrix[i].length; j++)
          {
            System.out.println(local.get(i)
                + " to "
                + local.get(j)
                + ": "
                + (shortestDistanceMatrix[i][j] == Double.POSITIVE_INFINITY ? "none" : Double
                    .toString(shortestDistanceMatrix[i][j])));
          }
        }
        System.out.println();
      }
    }
  }
}
