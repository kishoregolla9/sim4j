package ca.carleton.sysc5801.sim4j;

public class Link
{
  private final Node m_i;
  private final Node m_j;
  private final double m_capacity;
  private final double m_lengthInKm;

  private double m_flow = 0d;

  Link(Node i, Node j, double capacity, double km)
  {
    m_i = i;
    m_j = j;
    m_capacity = capacity;
    m_lengthInKm = km;
    i.addLink(this);
    j.addLink(this);
  }

  public Node getI()
  {
    return m_i;
  }

  public Node getJ()
  {
    return m_j;
  }

  public double getCapacity()
  {
    return m_capacity;
  }

  public double getLengthInKm()
  {
    return m_lengthInKm;
  }

  public Node getOther(Node node)
  {
    if (node.equals(getI()))
    {
      return getJ();
    }
    return getI();
  }

  public void resetFlow()
  {
    m_flow = 0d;
  }

  public void addFlow(double bps)
  {
    m_flow += bps;
  }

  /**
   * @return flow in bits per second
   */
  public double getFlow()
  {
    return m_flow;
  }

  @Override
  public int hashCode()
  {
    return getI().getId() | getJ().getId() << 16;
  }

  @Override
  public boolean equals(Object obj)
  {
    Link that;
    return obj == this || obj instanceof Link
        && (that = (Link) obj).getI().equals(this.getI())
        && that.getJ().equals(this.getJ())
        && that.getCapacity() == this.getCapacity()
        && that.getLengthInKm() == this.getLengthInKm();
  }

  @Override
  public String toString()
  {
    return "Link: " + getI() + " to " + getJ() + "\t" + getLengthInKm()
        + "km\t" + getCapacity() + "bps";
  }

}
