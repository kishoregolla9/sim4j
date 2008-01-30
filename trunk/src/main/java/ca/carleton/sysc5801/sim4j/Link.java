package ca.carleton.sysc5801.sim4j;

public class Link
{
  private final Node m_start;
  private final Node m_end;
  private final int m_capacity;
  private final int m_lengthInKm;

  public Link(Node i, Node j, int capacity, int length)
  {
    m_start = i;
    m_end = j;
    m_capacity = capacity;
    m_lengthInKm = length;
  }

  public Node getStart()
  {
    return m_start;
  }

  public Node getEnd()
  {
    return m_end;
  }

  public int getCapacity()
  {
    return m_capacity;
  }

  public int getLengthInKm()
  {
    return m_lengthInKm;
  }

}
