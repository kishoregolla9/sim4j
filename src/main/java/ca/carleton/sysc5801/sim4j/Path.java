package ca.carleton.sysc5801.sim4j;

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

  public void addLink(Link link)
  {
    m_path.add(link);
  }

  public void addLinks(List<Link> links)
  {
    m_path.addAll(links);
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
    String cost = Project.FORMAT.format(getMetric(m_function));
    StringBuilder result = new StringBuilder("C=");
    for (int i = 0; i < 4 - cost.indexOf('.'); i++)
    {
      result.append(' ');
    }
    result.append(cost);
    Node node = m_start;
    result.append(" (");
    for (Link link : getPath())
    {
      result.append(node.getId());
      result.append("->");
      node = link.getOther(node);
    }
    result.deleteCharAt(result.length() - 1);
    result.deleteCharAt(result.length() - 1);
    result.append(")");

    return result.toString();

  }

}
