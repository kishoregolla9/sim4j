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
        System.out.println("*** Shorted Distance Matrix for " + nodes[n] + " ("
            + nodes[n].getNeighbours().size() + " neighbours)");
        List<Node> local = nodes[n].getLocalNetwork(2);
        double[][] shortestDistanceMatrix = nodes[n].getShortestDistanceMatrix(local);
        int v = 0;
        for (int i = 0; i < shortestDistanceMatrix.length; i++)
        {
          for (int j = 0; j < shortestDistanceMatrix[i].length; j++)
          {
            System.out.println(v++
                + ": "
                + local.get(i)
                + " to "
                + local.get(j)
                + ": "
                + (shortestDistanceMatrix[i][j] == Double.MAX_VALUE ? "none" : Double
                    .toString(shortestDistanceMatrix[i][j])));
          }
        }

        for (int i = 0; i < shortestDistanceMatrix.length; i++)
        {
          for (int j = 0; j < shortestDistanceMatrix[i].length; j++)
          {
            assertEquals(shortestDistanceMatrix[i][j], shortestDistanceMatrix[j][i]);
          }
        }

        System.out.println();
      }
    }

  }
}
