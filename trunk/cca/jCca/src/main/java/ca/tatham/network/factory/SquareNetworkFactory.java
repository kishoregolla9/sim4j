package ca.tatham.network.factory;

import ca.tatham.network.Network;
import ca.tatham.network.Node;

class SquareNetworkFactory extends AbstractNetworkFactory
{

  SquareNetworkFactory(int size, double percentError)
  {
    super(size, percentError);
  }

  @Override
  public Network createNetwork(int size, double radioRange)
  {
    Node[] network = new Node[size * size];
    int index = 0;
    for (int x = 0; x < size; x++)
    {
      for (int y = 0; y < size; y++)
      {
        network[index] = createNode(x, y);
        index++;
      }
    }
    return new Network("Square", network, radioRange);
  }
}
