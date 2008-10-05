package ca.tatham.network.cca;

import org.apache.commons.math.optimization.CostException;
import org.apache.commons.math.optimization.CostFunction;
import org.apache.commons.math.optimization.DirectSearchOptimizer;
import org.apache.commons.math.optimization.MultiDirectional;

public class CCA
{
  public static void cca(double[][] input, double[][] distance)
  {
    DirectSearchOptimizer optimizer = new MultiDirectional();
    CostFunction cost = new CostFunction()
    {
      @Override
      public double cost(double[] x) throws CostException
      {
        // E= 1/2 sum(i
        return 0;
      }

    };
    optimizer.minimize(cost, maxEvaluations, checker, vertices);
  }
}
