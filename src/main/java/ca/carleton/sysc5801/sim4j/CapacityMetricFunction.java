/**
 * 
 */
package ca.carleton.sysc5801.sim4j;

class CapacityMetricFunction implements MetricFunction
{

  @Override
  public double getMetric(Link link)
  {
    if (link.getCapacity() == 0)
    {
      return 0;
    }
    return 100000000 / link.getCapacity();
  }

}