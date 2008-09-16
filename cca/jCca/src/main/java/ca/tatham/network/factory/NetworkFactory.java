package ca.tatham.network.factory;

import ca.tatham.network.Network;

interface NetworkFactory
{
  Network createNetwork(int size, double radioRange);
}
