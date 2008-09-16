package ca.tatham.network.factory;

import ca.tatham.network.Network;

public interface NetworkShapeFactory
{

  Network createNetwork(int size, double radioRange);

  Network getRandom(int size, double radioRange);

}
