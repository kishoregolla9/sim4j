package ca.tatham.network.factory;

import ca.tatham.network.Network;

public class NetworkCreator
{

  public enum NetworkShape
  {
    SQUARE, RECTANGLE, C, L, LOOP
  }

  public enum NetworkError
  {
    GRID, RANDOM
  }

  public static Network getNetwork(NetworkShape shape, double percentError, int size, int n,
      double radioRange)
  {
    NetworkShapeFactory factory = getFactory(shape);
    return factory.getGrid(size, percentError, radioRange);
  }

  private static NetworkShapeFactory getFactory(NetworkShape shape)
  {
    switch (shape)
    {
    case SQUARE:
      return new SquareNetworkFactory();
    case RECTANGLE:
      return new RectangleNetworkFactory();
    case C:
      return new CNetworkFactory();
    case L:
      return new LNetworkFactory();
    case LOOP:
      return new LoopNetworkFactory();
    }
    throw new IllegalArgumentException("Unknown network shape: " + shape);
  }
}
