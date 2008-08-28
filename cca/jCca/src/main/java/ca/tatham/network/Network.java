package ca.tatham.network;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;

public class Network implements Iterable<Node>
{
  private Node[] m_nodes;

  public Network(Node[] nodes)
  {
    m_nodes = nodes;
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
