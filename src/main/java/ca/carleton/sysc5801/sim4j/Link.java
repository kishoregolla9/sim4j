package ca.carleton.sysc5801.sim4j;

public class Link
{
  private final Node m_start;
  private final Node m_end;
  private final double m_capacity;
  private final double m_lengthInKm;

  public Link(Node i, Node j, double capacity, double km)
  {
    i.addLink(this);
    j.addLink(this);
    m_start = i;
    m_end = j;
    m_capacity = capacity;
    m_lengthInKm = km;
  }

  public Node getStart()
  {
    return m_start;
  }

  public Node getEnd()
  {
    return m_end;
  }

  public double getCapacity()
  {
    return m_capacity;
  }

  public double getLengthInKm()
  {
    return m_lengthInKm;
  }

  @Override
  public String toString()
  {
    return super.toString();
  }

  @Override
  public int hashCode()
  {
    return getStart().getId() ^ getEnd().getId();
  }

  @Override
  public boolean equals(Object obj)
  {
    Link that;
    return obj == this || obj instanceof Link
        && (that = (Link) obj).getStart().equals(this.getStart())
        && that.getEnd().equals(this.getEnd())
        && that.getCapacity() == this.getCapacity()
        && that.getLengthInKm() == this.getLengthInKm();
  }
}
