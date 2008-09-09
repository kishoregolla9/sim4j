package ca.tatham.network.factory;

import ca.tatham.network.Network;
import ca.tatham.network.Node;

public class NetworkFactory
{

  public enum NetworkType
  {
    RANDOM, GRID, RANDOM_C_SHAPE, GRID_C_SHAPE, RANDOM_RECTANGLE, GRID_RECTANGLE_20PERCENT_ERROR, RANDOM_L_SHAPE, GRID_L_SHAPE, RANDOM_LOOP, GRID_LOOP
  }

  public static Network getNetwork(NetworkType type, int size, int n, double radioRange)
  {
    Network network;
    switch (type)
    {
    case RANDOM:
      network = new Network(new Node[0], radioRange);
      break;
    case GRID:
      network = new Network(new Node[0], radioRange);
      break;
    case RANDOM_C_SHAPE:
      network = new Network(new Node[0], radioRange);
      break;
    case GRID_C_SHAPE:
      network = new CShapeFactory().getGrid(size, radioRange);
      break;
    case RANDOM_RECTANGLE:
      network = new Network(new Node[0], radioRange);
      break;
    case GRID_RECTANGLE_20PERCENT_ERROR:
      network = new Network(new Node[0], radioRange);
      break;
    case RANDOM_L_SHAPE:
      network = new Network(new Node[0], radioRange);
      break;
    case GRID_L_SHAPE:
      network = new Network(new Node[0], radioRange);
      break;
    case RANDOM_LOOP:
      network = new Network(new Node[0], radioRange);
      break;
    case GRID_LOOP:
      network = new Network(new Node[0], radioRange);
      break;
    default:
      network = new Network(new Node[0], radioRange);
      break;
    }

    return network;
  }
}
