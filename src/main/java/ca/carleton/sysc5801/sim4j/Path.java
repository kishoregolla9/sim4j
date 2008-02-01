package ca.carleton.sysc5801.sim4j;

import java.util.LinkedList;

public class Path
{
  private final Node m_start;
  private final LinkedList<Link> m_path = new LinkedList<Link>();
  private final MetricFunction m_function;

  public Path(Node start, MetricFunction function)
  {
    m_start = start;
    m_function = function;
  }

  public LinkedList<Link> getPath()
  {
    return m_path;
  }

  public void addLink(Link node)
  {
    m_path.add(node);
  }

  public double getMetric(MetricFunction function)
  {
    double metric = 0;
    if (getPath().size() == 0)
    {
      return Double.POSITIVE_INFINITY;
    }
    for (Link link : getPath())
    {
      metric += function.getMetric(link);
    }
    return metric;
  }

  @Override
  public String toString()
  {
    StringBuilder result = new StringBuilder("(");
    Node node = m_start;
    for (Link link : getPath())
    {
      result.append(node.getId());
      result.append(",");
      node = link.getOther(node);
    }
    result.append(") C=");
    result.append(getMetric(m_function));
    return result.toString();

  }
}
