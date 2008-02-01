package ca.carleton.sysc5801.sim4j;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * <table border="1">
 * <tr>
 * <td> Line 1</td>
 * <td colspan="4" align="center"> |N| </td>
 * </tr>
 * <td> Line 2 <br>
 * to |M| +1</td>
 * <td>i</td>
 * <td>j</td>
 * <td align="center">C<sub>ij</sub><br>
 * (Capacity in bps)</td>
 * <td align="center">l<sub>ij</sub><br>
 * (length in km)</td>
 * </tr>
 * </table>
 * 
 * @author BenTatham
 * 
 */
public class NetworkFileParser
{
  private final File m_file;
  private final Map<Integer, Node> m_nodes = new HashMap<Integer, Node>();

  NetworkFileParser(File file)
  {
    if (!file.canRead())
    {
      throw new IllegalArgumentException("Cannot read file: " + file);
    }
    m_file = file;

  }

  Network getNetwork() throws NetworkException
  {
    try
    {
      BufferedReader reader = new BufferedReader(new FileReader(m_file));
      String line = reader.readLine();
      int numNodes = Integer.parseInt(line.trim());
      Network network = new Network(numNodes * 3);
      while ((line = reader.readLine()) != null)
      {
        if (line == null)
        {
          throw new NetworkException(
              "Invalid file: could not find next link definition");
        }

        String[] split = line.trim().split("\\s+");
        Link link =
            new Link(getNode(Integer.parseInt(split[0])), getNode(Integer
                .parseInt(split[1])), Double.parseDouble(split[2]), Double
                .parseDouble(split[3]));

        network.addLink(link);

      }

      reader.close();
      return network;
    }
    catch (IOException e)
    {
      return null;
    }
  }

  private Node getNode(int id)
  {
    Node node = m_nodes.get(id);
    if (node == null)
    {
      node = new Node(id);
      m_nodes.put(id, node);
    }
    return node;

  }

}
