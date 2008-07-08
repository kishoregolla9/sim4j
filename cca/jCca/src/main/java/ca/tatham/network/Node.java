package ca.tatham.network;

public class Node
{
  private double m_x;
  private double m_y;

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

}
