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
    NetworkFactory factory = getNetworkFactory(shape, percentError);
    return factory.createNetwork(size, radioRange);
  }

  private static NetworkFactory getNetworkFactory(NetworkShape shape, double percentError)
  {
    switch (shape)
    {
    case SQUARE:
      return new SquareNetworkFactory(percentError);
    case RECTANGLE:
      return new RectangleNetworkFactory(percentError);
    case C:
      return new CNetworkFactory(percentError);
    case L:
      return new LNetworkFactory(percentError);
    case LOOP:
      return new LoopNetworkFactory(percentError);
    }
    throw new IllegalArgumentException("Unknown network shape: " + shape);
  }
}
