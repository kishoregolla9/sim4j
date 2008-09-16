package ca.tatham.network.factory;

import ca.tatham.network.Network;
import ca.tatham.network.Node;

public class LNetworkFactory implements NetworkShapeFactory
{

  @Override
  public Network createNetwork(int size, double radioRange)
  {
    Node[] network = new Node[size * size];
    double fraction = 0.3d;
    int index = 0;
    for (int i = 0; i < size; i++)
    {
      if (i < size * fraction)
      {
        for (int j = 0; j < size; j++)
        {
          network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j + (Math.random() - 0.5)
              * 0.4);
          index++;
        }
      }
      else
      {
        for (int j = 0; j < size * fraction; j++)
        {
          network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j + (Math.random() - 0.5)
              * 0.4);
          index++;
        }
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
