package ca.tatham.network;

import java.util.HashMap;
import java.util.Map;

public class Node
{
  private double m_x;
  private double m_y;
  private Map<Double, Double> m_connectivity = new HashMap<Double, Double>();

  public Node(double x, double y)
  {
    m_x = x;
    m_y = y;
  }

  public double x()
  {
    return m_x;
  }

  public double y()
  {
    return m_y;
  }

  public void setConnectivity(double radius, double connectivity)
  {
    m_connectivity.put(radius, connectivity);
  }

  public double getConnectivity(double radius)
  {
    return m_connectivity.get(radius);
  }

}
