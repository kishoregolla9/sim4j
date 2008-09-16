package ca.tatham.network.factory;

import ca.tatham.network.Network;
import ca.tatham.network.Node;

public class RectangleNetworkFactory implements NetworkShapeFactory
{
  @Override
  public Network createNetwork(int size, double radioRange)
  {
    Node[] network = new Node[size * size];
    int index = 0;
    for (int i = 0; i < size / 3; i++)
    {
      for (int j = 0; j < size * 4 / 3; j++)
      {
        network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j + (Math.random() - 0.5) * 0.4);
        index++;
      }
    }
    return new Network(network, radioRange);
  }

  @Override
  public Network getRandom(int size, double radioRange)
  {
    // TODO Auto-generated method stub
    return null;
  }

}
