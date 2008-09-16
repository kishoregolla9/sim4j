package ca.tatham.network;

import java.text.DecimalFormat;
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

  /**
   * http://en.wikipedia.org/wiki/Floyd-Warshall_algorithm
   * http://www.fearme.com/misc/alg/node88.htmls
   * http://www.brpreiss.com/books/opus5/programs/pgm16_16.txt
   */
  public double[][] getShortestDistanceMatrix(List<Node> localNeighbours)
  {
    double[][] path = new double[localNeighbours.size()][localNeighbours.size()];
    for (int i = 0; i < localNeighbours.size(); i++)
    {
      for (int j = 0; j < localNeighbours.size(); j++)
      {
        path[i][j] = edgeCost(localNeighbours.get(i), localNeighbours.get(j));
      }
    }

    // The Floyd Algorithm
    for (int k = 0; k < localNeighbours.size() - 1; k++)
    {
      for (int i = 0; i < localNeighbours.size() - 1; i++)
      {
        for (int j = 0; j < localNeighbours.size() - 1; j++)
        {
          path[i][j] = Math.min(path[i][j], path[i][k] + path[k][j]);
        }
      }
    }

    return path;
  }

  public List<Node> getLocalNetwork(int maxHops)
  {
    List<Node> localNeigbours = new LinkedList<Node>();
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
}
