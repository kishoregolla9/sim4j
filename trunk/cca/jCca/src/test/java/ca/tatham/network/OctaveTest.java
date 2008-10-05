package ca.tatham.network;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;

import junit.framework.TestCase;

public class OctaveTest extends TestCase
{
  public void testToString() throws IOException
  {
    double[][] input = new double[][] { { 1, 2 }, { 3, 4 } };
    String output = Octave.toString(input);
    System.out.println(output);
    BufferedReader reader = new BufferedReader(new StringReader(output));
    assertEquals(" [1 ,  2]", reader.readLine());
    assertEquals(" [3 ,  4]", reader.readLine());
    assertNull(reader.readLine());
  }

  public void testIndexExpression()
  {
    double[][] input = new double[][] { { 1, 2 }, { 3, 4 } };
    double[][] result = Octave.indexExpression(input, "1", ":");
    assertEquals(1, result.length);
    result[0][0] = 1;
    result[0][1] = 2;
  }

  public void testRepmat() throws Exception
  {
    double[][] input = new double[][] { { 1, 2 }, { 3, 4 } };

    double[][] repmat = Octave.repmat(input, 1, 1);
    assertEquals(Octave.toString(repmat), 2, repmat.length);
    assertEquals(2, repmat[0].length);

    repmat = Octave.repmat(input, 2, 2);
    assertEquals(Octave.toString(repmat), 4, repmat.length);
    assertEquals(4, repmat[0].length);

  }
}
