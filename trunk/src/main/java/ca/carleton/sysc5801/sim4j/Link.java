package ca.carleton.sysc5801.sim4j;

public class Link
{
  private final Node m_i;
  private final Node m_j;
  private final double m_capacity;
  private final double m_lengthInKm;

  private int m_flow = 0;

  Link(Node i, Node j, double capacity, double km)
  {
    m_i = i;
    m_j = j;
    m_capacity = capacity;
    m_lengthInKm = km;
    i.addLink(this);
    j.addLink(this);
  }

  public Link(Link link)
  {
    this(new Node(link.getI()), new Node(link.getJ()), link.getCapacity(), link
        .getLengthInKm());
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
    m_flow = 0;
  }

  public void incrementFlow(double flow)
  {
    m_flow += flow;
  }

  public void multiplyFlow(double factor)
  {
    m_flow *= factor;
  }

  /**
   * @return flow in bits per second
   */
  public int getFlow()
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
