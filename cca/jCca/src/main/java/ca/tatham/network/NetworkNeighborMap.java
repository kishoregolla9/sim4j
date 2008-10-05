package ca.tatham.network;

import java.util.List;

public class NetworkNeighborMap
{
  public double[][] getFullDistanceMatrix(Network x, Network y)
  {
    if (x.size() != y.size())
    {
      throw new IllegalArgumentException("Must be same size networks");
    }
    int p = x.size();
    int nxy = x.size() * y.size();
    double[][] z = new double[x.size()][y.size()];

    return z;
  }

  public static void permute(List unvisited, List visited)
  {
    if (unvisited.isEmpty())
    {
      System.out.println("Permutation: " + visited);
    }
    else
    {
      // System.out.println("Trace: "+visited+" "+unvisited);
      int l = unvisited.size();
      for (int i = 0; i < l; i++)
      {
        Object next = unvisited.remove(i);
        visited.add(next);
        permute(unvisited, visited);
        unvisited.add(i, next);
        visited.remove(next);
      }
    }
  }

}
