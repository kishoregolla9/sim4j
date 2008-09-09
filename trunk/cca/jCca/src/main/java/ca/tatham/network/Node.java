package ca.tatham.network;

import java.text.DecimalFormat;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.commons.math.geometry.Vector3D;

public class Node
{
  private final Vector3D m_vector;
  private Set<Node> m_neighbours = new HashSet<Node>(12);
  private Map<Double, Double> m_connectivity = new HashMap<Double, Double>();

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

  public double[][] getShortestDistanceMatrix()
  {

  }

  @Override
  public String toString()
  {
    return "(" + DecimalFormat.getInstance().format(x()) + ","
        + DecimalFormat.getInstance().format(y()) + ")";
  }
}
