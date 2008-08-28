package ca.tatham.network;

public class CShapeFactory
{
  public static Network getGrid(int size)
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
          network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j
              + (Math.random() - 0.5) * 0.4);
          index++;
        }
      } else
      {
        for (int j = 0; j < size * fraction; j++)
        {
          network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j
              + (Math.random() - 0.5) * 0.4);
          index++;
        }
        for (int j = (int) (size * (1 - fraction)); j < size; j++)
        {
          network[index] = new Node(i + (Math.random() - 0.5) * 0.4, j
              + (Math.random() - 0.5) * 0.4);
          index++;
        }
      }
    }
    return new Network(network);
  }
}
