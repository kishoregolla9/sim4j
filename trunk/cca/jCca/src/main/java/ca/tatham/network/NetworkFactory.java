package ca.tatham.network;

public class NetworkFactory
{

  public enum NetworkType
  {
    RANDOM, GRID, RANDOM_C_SHAPE, GRID_C_SHAPE, RANDOM_RECTANGLE, GRID_RECTANGLE_20PERCENT_ERROR, RANDOM_L_SHAPE, GRID_L_SHAPE, RANDOM_LOOP, GRID_LOOP
  }

  public static Node[] getNetwork(NetworkType type, int size, int n)
  {
    switch (type)
    {
    case RANDOM:
      return new Node[0];
    case GRID:
      return new Node[0];
    case RANDOM_C_SHAPE:
      return new Node[0];
    case GRID_C_SHAPE:
      return CShapeFactory.getGrid(size);
    case RANDOM_RECTANGLE:
      return new Node[0];
    case GRID_RECTANGLE_20PERCENT_ERROR:
      return new Node[0];
    case RANDOM_L_SHAPE:
      return new Node[0];
    case GRID_L_SHAPE:
      return new Node[0];
    case RANDOM_LOOP:
      return new Node[0];
    case GRID_LOOP:
      return new Node[0];
    }

    return new Node[0];
  }
}
