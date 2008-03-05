/**
 * 
 */
package ca.carleton.sysc5801.sim4j;

class CapacityMetricFunction implements MetricFunction
{

  private static final long MEGABIT_100 = 100000000L;

  @Override
  public double getMetric(Link link)
  {
    if (link.getCapacity() == 0)
    {
      return 0;
    }
    return MEGABIT_100 / link.getCapacity();
  }

}