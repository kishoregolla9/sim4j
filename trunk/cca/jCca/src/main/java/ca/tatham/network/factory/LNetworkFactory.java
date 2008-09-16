package ca.tatham.network.factory;

import ca.tatham.network.Network;
import ca.tatham.network.Node;

public class LNetworkFactory extends AbstractNetworkFactory
{

  public LNetworkFactory(double percentError)
  {
    super(percentError);
  }

  @Override
  public Network createNetwork(int size, double radioRange)
  {
    Node[] network = new Node[size * size];
    double fraction = 0.3d;
    int index = 0;
    for (int x = 0; x < size; x++)
    {
      if (x < size * fraction)
      {
        for (int y = 0; y < size; y++)
        {
          network[index] = createNode(x, y);
          index++;
        }
      }
      else
      {
        for (int y = 0; y < size * fraction; y++)
        {
          network[index] = createNode(x, y);
          index++;
        }
      }
    }
    return new Network(network, radioRange);

  }
}
