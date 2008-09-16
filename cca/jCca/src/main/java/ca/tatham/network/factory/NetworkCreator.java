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

  public static Network getNetwork(NetworkShape shape, double percentError, int size,
      double radioRange)
  {
    NetworkFactory factory = getNetworkFactory(shape, size, percentError);
    return factory.createNetwork(size, radioRange);
  }

  private static NetworkFactory getNetworkFactory(NetworkShape shape, int size, double percentError)
  {
    switch (shape)
    {
    case SQUARE:
      return new SquareNetworkFactory(size, percentError);
    case RECTANGLE:
      return new RectangleNetworkFactory(size, percentError);
    case C:
      return new CNetworkFactory(size, percentError);
    case L:
      return new LNetworkFactory(size, percentError);
    case LOOP:
      return new LoopNetworkFactory(size, percentError);
    }
    throw new IllegalArgumentException("Unknown network shape: " + shape);
  }
}
