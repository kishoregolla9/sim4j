package ca.tatham.network.factory;

import ca.tatham.network.Node;

abstract class AbstractNetworkFactory implements NetworkFactory
{
  private final double m_percentError;

  AbstractNetworkFactory(double percentError)
  {
    m_percentError = percentError;
  }

  protected Node createNode(int x, int y)
  {
    return new Node(x + (Math.random() - 0.5) * m_percentError * 2, y + (Math.random() - 0.5)
        * m_percentError * 2);
  }
}
