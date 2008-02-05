package ca.carleton.sysc5801.sim4j;

import java.text.DecimalFormat;
import java.util.LinkedList;
import java.util.List;

public class Path
{
  private final Node m_start;
  private final List<Link> m_path = new LinkedList<Link>();
  private final MetricFunction m_function;

  public Path(Node start, MetricFunction function)
  {
    m_start = start;
    m_function = function;
  }

  public List<Link> getPath()
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
    result.deleteCharAt(result.length() - 1);
    result.append(") C=");
    result.append(DecimalFormat.getNumberInstance().format(
        getMetric(m_function)));
    return result.toString();

  }
}
