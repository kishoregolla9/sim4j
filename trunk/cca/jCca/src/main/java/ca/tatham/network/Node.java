package ca.tatham.network;

import java.text.DecimalFormat;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.math.geometry.Vector3D;

public class Node
{
  private final Vector3D m_vector;
  private final Set<Node> m_neighbours = new HashSet<Node>(12);
  private final Map<Double, Double> m_connectivity = new HashMap<Double, Double>();

  public Node(double x, double y)
  {
    m_vector = new Vector3D(x, y, 0d);
  }

  public Vector3D getVector()
  {
    return m_vector;
  }

  public double x()
  {
    return m_vector.getX();
  }

  public double y()
  {
    return m_vector.getY();
  }

  public void addNeighbour(Node n)
  {
    m_neighbours.add(n);
  }

  public Set<Node> getNeighbours()
  {
    return m_neighbours;
  }

  public void setConnectivity(double radius, double connectivity)
  {
    m_connectivity.put(radius, connectivity);
  }

  public double getConnectivity(double radius)
  {
    return m_connectivity.get(radius);
  }

  /**
   * http://en.wikipedia.org/wiki/Floyd-Warshall_algorithm
   * 
   * @param maxHops
   * @return
   */
  public int[][] getShortestDistanceMatrix(int maxHops)
  {
    List<Node> local = new LinkedList<Node>();
    addNeighbors(local, maxHops);

    int[][] path = new int[local.size()][local.size()];
    for (int i = 0; i < local.size(); i++)
    {
      for (int j = 0; j < local.size(); j++)
      {
        path[i][j] = edgeCost(local.get(i), local.get(j));
      }
    }

    // The Floyd Algorithm
    for (int k = 0; k < local.size() - 1; k++)
    {
      for (int i = 0; i < local.size() - 1; i++)
      {
        for (int j = 0; j < local.size() - 1; j++)
        {
          path[i][j] = Math.min(path[i][j], path[i][k] + path[k][j]);
        }
      }
    }

    return path;
  }

  private void addNeighbors(Collection<Node> local, int maxHops)
  {
    for (Node neighbor : getNeighbours())
    {
      if (!local.contains(neighbor))
      {
        local.add(neighbor);
      }
    }
    if (--maxHops == 0)
    {
      return;
    }
    addNeighbors(local, maxHops);
  }

  private int edgeCost(Node i, Node j)
  {
    if (i.equals(j))
    {
      return 0;
    }
    if (i.getNeighbours().contains(j))
    {
      return 1;
    }
    return Integer.MAX_VALUE;
  }

  @Override
  public String toString()
  {
    return "(" + DecimalFormat.getInstance().format(x()) + ","
        + DecimalFormat.getInstance().format(y()) + ")";
  }
}
