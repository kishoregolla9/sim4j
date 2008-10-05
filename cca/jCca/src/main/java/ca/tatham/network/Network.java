package ca.tatham.network;

import java.util.Arrays;
import java.util.Iterator;

public class Network implements Iterable<Node>
{
  private final String m_label;
  private final Node[] m_nodes;
  private final double m_radioRange;

  public Network(String label, Node[] nodes, double radioRange)
  {
    m_label = label + "-Network (r=" + radioRange + ")";
    m_nodes = nodes;
    m_radioRange = radioRange;
    initNeighbours(nodes, radioRange);
  }

  private void initNeighbours(Node[] nodes, double radioRange)
  {
    int totalNeighbours = 0;
    for (int i = 0; i < nodes.length; i++)
    {
      for (int j = 0; j < nodes.length; j++)
      {
        if (i != j)
        {
          if (nodes[i] != null && nodes[j] != null && nodes[i].distanceTo(nodes[j]) <= radioRange)
          {
            nodes[i].addNeighbour(nodes[j]);
            nodes[j].addNeighbour(nodes[i]);
          }
        }
      }
      if (nodes[i] != null)
      {
        totalNeighbours += nodes[i].getNeighbours().size();
      }
    }
    System.out.println("Average connectivity (neighbours per node): " + (double) totalNeighbours
        / nodes.length);
  }

  public Node[] getNodes()
  {
    return m_nodes;
  }

  public Node getNode(int index)
  {
    return m_nodes[index];
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

  public boolean connectivityCheck(double r)
  {
    double[][] distances = new double[size()][size()];
    for (int i = 0; i < size(); i++)
    {
      for (int j = 0; j < size(); j++)
      {
        if (getNode(i) != null && getNode(j) != null && i != j)
        {
          distances[i][j] = getNode(i).distanceTo(getNode(j));
        }
      }
    }

    boolean[][] connectivity = new boolean[size()][size()];
    for (int i = 0; i < size(); i++)
    {
      for (int j = 0; j < size(); j++)
      {
        connectivity[i][j] = distances[i][j] <= r;
      }
    }

    boolean disconnect = true;
    double[][] distance_hop_count = new double[size()][size()];
    for (int i = 0; i < size(); i++)
    {
      for (int j = 0; j < size(); j++)
      {
        if (distances[i][j] < r)
        {
          distance_hop_count[i][j] = 1;
        }
        else
        {
          distance_hop_count[i][j] = 2 * size();
        }
      }
    } // get prepared to compute the shortest hop matrix for D

    for (int k = 0; k < size(); k++)
    {
      double[][] colon_k = Octave.indexExpression(distance_hop_count, ":", "" + k);
      double[][] k_colon = Octave.indexExpression(distance_hop_count, "" + k, ":");

      double[][] arg1 = Octave.execute(new String[] { "k", "N", "distance_hop_count" },
          new double[][][] { Octave.scalar(k), Octave.scalar(size()), distance_hop_count },
          "foo=repmat(distance_hop_count(:,k),[1 N])+repmat(distance_hop_count(k,:),[N 1])", "foo");
      distance_hop_count = Octave.min(distance_hop_count, arg1);
    } // compute the shortest hop matrix using Floyd algorithm

    for (int i = 0; i < size(); i++)
    {
      for (int j = 0; j < size(); j++)
      {
        if (distance_hop_count[i][j] == 2 * size())
        {
          disconnect = false;
        }
        break;
      }
    }

    return disconnect;

    // % use this to plot the network connectivity if needed
    // gplot(Connectivity, Network,'-o');
  }

  @Override
  public Iterator<Node> iterator()
  {
    return Arrays.asList(m_nodes).iterator();
  }

  @Override
  public String toString()
  {
    return m_label;
  }
}
