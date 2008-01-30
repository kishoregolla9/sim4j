package ca.carleton.sysc5801.sim4j;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;

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
      int numLinks = Integer.parseInt(line.trim());
      Network network = new Network(numLinks);
      for (int i = 0; i < numLinks; i++)
      {
        line = reader.readLine();
        if (line == null)
        {
          throw new NetworkException("Invalid file: could not find " + i + "th link definition");
        }

        String[] split = line.split("\\s+");
        Link link =
            new Link(new Node(Integer.parseInt(split[0])), new Node(Integer.parseInt(split[1])), Integer
                .parseInt(split[2]), Integer.parseInt(split[3]));

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

}
