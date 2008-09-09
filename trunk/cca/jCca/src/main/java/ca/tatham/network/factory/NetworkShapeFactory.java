package ca.tatham.network.factory;

import ca.tatham.network.Network;

public interface NetworkShapeFactory
{

  Network getGrid(int size, double radioRange);

}
