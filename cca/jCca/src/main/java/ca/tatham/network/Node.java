package ca.tatham.network;

import java.text.DecimalFormat;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import org.apache.commons.math.geometry.Vector3D;

public class Node implements Comparable<Node>
{
  private final Vector3D m_vector;
  private final Set<Node> m_neighbours = new HashSet<Node>(12);

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

  public void doCca()
  {

  }

  /**
   * http://en.wikipedia.org/wiki/Floyd-Warshall_algorithm
   * http://www.fearme.com/misc/alg/node88.htmls
   * http://www.brpreiss.com/books/opus5/programs/pgm16_16.txt
   * 
   * @param graph
   *          the local neighbourhood to calculate on
   */
  public double[][] getShortestDistanceMatrix(List<Node> graph)
  {
    // Floyd's Algorithm
    int n = graph.size();
    double[][] distance = new double[n][n];
    for (int i = 0; i < n; ++i)
    {
      Arrays.fill(distance[i], Double.MAX_VALUE);
    }

    for (int i = 0; i < n; i++)
    {
      for (int j = 0; j < n; j++)
      {
        distance[i][j] = edgeCost(graph.get(i), graph.get(j));
      }
    }

    for (int i = 0; i < n; ++i)
    {
      for (int v = 0; v < n; ++v)
      {
        for (int w = 0; w < n; ++w)
        {
          if (distance[v][i] != Double.MAX_VALUE && distance[i][w] != Double.MAX_VALUE)
          {
            double d = distance[v][i] + distance[i][w];
            distance[v][w] = Math.min(distance[v][w], d);
            // if (distance[v][w] > d)
            // {
            // distance[v][w] = d;
            // }
          }
        }
      }
    }

    // for (int k = 0; k < n - 1; k++)
    // {
    // for (int i = 0; i < n - 1; i++)
    // {
    // for (int j = 0; j < n - 1; j++)
    // {
    // distance[i][j] = Math.min(distance[i][j], distance[i][k] +
    // distance[k][j]);
    // }
    // }
    // }

    return distance;
  }

  public List<Node> getLocalNetwork(int maxHops)
  {
    List<Node> localNeigbours = new LinkedList<Node>();
    localNeigbours.add(this);
    addNeighbors(localNeigbours, maxHops);
    Collections.sort(localNeigbours);
    return localNeigbours;
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

  private double edgeCost(Node i, Node j)
  {
    if (i.equals(j))
    {
      return 0;
    }
    if (i.getNeighbours().contains(j))
    {
      return 1;
    }
    return Double.POSITIVE_INFINITY;
  }

  @Override
  public String toString()
  {
    return "(" + DecimalFormat.getInstance().format(x()) + ","
        + DecimalFormat.getInstance().format(y()) + ")";
  }

  @Override
  public int compareTo(Node that)
  {
    if (this.x() < that.x())
    {
      return -1;
    }
    if (this.x() > that.x())
    {
      return +1;
    }
    if (this.y() < that.y())
    {
      return -1;
    }
    if (this.y() > that.y())
    {
      return +1;
    }
    return 0;
  }

  public double distanceTo(Node node)
  {
    if (node == null)
    {
      return 0;
    }
    Vector3D subtract = getVector().subtract(node.getVector());
    return subtract.getNorm();
  }
}
