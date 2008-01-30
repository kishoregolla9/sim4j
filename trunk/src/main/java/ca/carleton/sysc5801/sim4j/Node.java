package ca.carleton.sysc5801.sim4j;

public class Node
{
  private final int m_id;

  Node(int id)
  {
    m_id = id;
  }

  public int getId()
  {
    return m_id;
  }

  @Override
  public boolean equals(Object obj)
  {
    return obj == this || obj instanceof Node
        && ((Node) obj).getId() == this.getId();
  }

  @Override
  public int hashCode()
  {
    return m_id;
  }

  @Override
  public String toString()
  {
    return "Node " + getId();
  }
}
