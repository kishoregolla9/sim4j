package ca.tatham.network.factory;

import org.apache.commons.math.random.GaussianRandomGenerator;
import org.apache.commons.math.random.JDKRandomGenerator;

import ca.tatham.network.Node;

abstract class AbstractNetworkFactory implements NetworkFactory
{
  private final double m_percentErrorFromGrid;
  private final int m_size;

  protected AbstractNetworkFactory(int size, double percentError)
  {
    m_size = size;
    m_percentErrorFromGrid = percentError;
  }

  protected Node createNode(int x, int y)
  {
    if (m_percentErrorFromGrid >= 1)
    {
      return new Node((x + gridFudge()) % m_size, (y + gridFudge()) % m_size);
    }
    return new Node(x + gridFudge(), y + gridFudge());
  }

  private double gridFudge()
  {
    double random = new GaussianRandomGenerator(new JDKRandomGenerator()).nextNormalizedDouble();
    return (random - 0.5) * m_percentErrorFromGrid * 2;
  }
}
