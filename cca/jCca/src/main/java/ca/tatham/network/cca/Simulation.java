package ca.tatham.network.cca;

import ca.tatham.network.NetworkFactory;
import ca.tatham.network.Node;
import ca.tatham.network.NetworkFactory.NetworkType;

public class Simulation
{
  public static void main(String[] args)
  {
    Node[] network = NetworkFactory.getNetwork(NetworkType.GRID_C_SHAPE, 5, 0);
  }
}
