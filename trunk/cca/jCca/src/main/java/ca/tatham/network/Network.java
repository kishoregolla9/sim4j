package ca.tatham.network;

import java.util.Arrays;
import java.util.Iterator;

import org.apache.commons.math.geometry.Vector3D;

public class Network implements Iterable<Node>
{
  private Node[] m_nodes;
  private double m_radioRange;

  public Network(Node[] nodes, double radioRange)
  {
    m_nodes = nodes;
    m_radioRange = radioRange;
    initNeighbours(nodes, radioRange);
  }

  private void initNeighbours(Node[] nodes, double radioRange)
  {
    int total = 0;
    for (int i = 0; i < nodes.length; i++)
    {
      for (int j = 0; j < nodes.length; j++)
      {
        if (i != j)
        {
          if (nodes[i] != null && nodes[j] != null && distance(nodes[i], nodes[j]) < radioRange)
          {
            nodes[i].addNeighbour(nodes[j]);
            nodes[j].addNeighbour(nodes[i]);
          }
        }
      }
      if (nodes[i] != null)
      {
        total += nodes[i].getNeighbours().size();
      }
    }
    System.out.println("Average connectivity: " + total / nodes.length);
  }

  private double distance(Node node1, Node node2)
  {
    Vector3D subtract = node1.getVector().subtract(node2.getVector());
    return subtract.getNorm();
  }

  public double getRadioRange()
  {
    return m_radioRange;
  }

  public int size()
  {
    return m_nodes.length;
  }

  public double[][] getPoints()
  {
    double[][] result = new double[2][m_nodes.length];
    int i = 0;
    for (Node node : m_nodes)
    {
      if (node != null)
      {
        result[0][i] = node.x();
      }
      i++;
    }
    i = 0;
    for (Node node : m_nodes)
    {
      if (node != null)
      {
        result[1][i] = node.y();
      }
      i++;
    }
    return result;

  }

  @Override
  public Iterator<Node> iterator()
  {
    return Arrays.asList(m_nodes).iterator();
  }
}
