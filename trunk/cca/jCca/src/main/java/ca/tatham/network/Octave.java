package ca.tatham.network;

import jmathlib.core.interpreter.Interpreter;
import jmathlib.core.interpreter.RootObject;
import jmathlib.core.tokens.Token;
import jmathlib.core.tokens.numbertokens.DoubleNumberToken;
import jmathlib.toolbox.jmathlib.matrix.min;
import jmathlib.toolbox.jmathlib.matrix.repmat;

public class Octave
{
  private final static Interpreter s_interpreter = new Interpreter(true);
  static
  {
    RootObject.setDebug(false);
  }

  public static double[][] scalar(double v)
  {
    return new double[][] { { v } };
  }

  public static double[][] execute(String[] variables, double[][][] values, String expr,
      String returnVar)
  {
    if (!(variables == null && values == null))
    {
      if (variables == null || values == null || variables.length != values.length)
      {
        throw new IllegalArgumentException("Variable names must match values!");
      }
    }

    synchronized (s_interpreter)
    {
      reportMemory("Before setting");
      if (variables != null && values != null)
      {
        for (int i = 0; i < variables.length; i++)
        {
          s_interpreter.setArray(variables[i], values[i], null);
        }
      }
      reportMemory("After setting");
      s_interpreter.executeExpression(expr);
      reportMemory("After exec");
      if (returnVar != null)
      {
        return s_interpreter.getArrayValueRe(returnVar);
      }
      return null;
    }
  }

  private static void reportMemory(String msg)
  {
    Runtime runtime = Runtime.getRuntime();
    long total = runtime.totalMemory() / 1024 / 1024;
    long used = (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024;
    System.out.println(msg + " " + used + "MB " + total + "MB total");

  }

  public static double[][] indexExpression(double[][] input, String a, String b)
  {
    String expr = "foo=temp( " + a + " , " + b + " )";
    return execute(new String[] { "temp" }, new double[][][] { input }, expr, "foo");
  }

  public static double[][] repmat(double[][] input, int x, int y)
  {
    DoubleNumberToken token = (DoubleNumberToken) new repmat().evaluate(new Token[] {
        new DoubleNumberToken(input), new DoubleNumberToken(x), new DoubleNumberToken(y) });

    return token.getReValues();
  }

  public static double[][] min(double[][] x, double[][] y)
  {
    Token[] operands;
    if (y == null)
    {
      operands = new Token[] { new DoubleNumberToken(x) };
    }
    else
    {
      operands = new Token[] { new DoubleNumberToken(x), new DoubleNumberToken(y) };
    }
    DoubleNumberToken token = (DoubleNumberToken) new min().evaluate(operands);
    return token.getReValues();
  }

  public static String toString(double[][] vector)
  {
    return new DoubleNumberToken(vector).toString();
  }
}
