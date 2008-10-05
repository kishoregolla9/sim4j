package ca.tatham.network.cca;

import java.awt.Dimension;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.xy.DefaultXYDataset;
import org.jfree.ui.ApplicationFrame;
import org.jfree.ui.RefineryUtilities;

import ca.tatham.network.Network;
import ca.tatham.network.factory.NetworkCreator;

public class Simulation extends ApplicationFrame
{
  private static final long serialVersionUID = 1069628856981539272L;

  private static final double NODE_PERCENT_ERROR = 0.3;

  public Simulation()
  {
    super("CCA Simulation");
    double radioRange = 1.5;
    Network network = NetworkCreator.getNetwork(NetworkCreator.NetworkShape.RECTANGLE,
        NODE_PERCENT_ERROR, 10, radioRange);

    while (network.connectivityCheck(radioRange))
    {
      System.out.println("Radio range :  " + radioRange + " OK");
      radioRange -= 0.1;
    }
    System.out.println("Minimum radio range is:  " + radioRange);

    DefaultXYDataset dataset = new DefaultXYDataset();
    dataset.addSeries("Node", network.getPoints());

    JFreeChart chart = ChartFactory.createScatterPlot(network.toString(), "X", "Y", dataset,
        PlotOrientation.VERTICAL, true, true, false);
    final ChartPanel chartPanel = new ChartPanel(chart);
    chartPanel.setPreferredSize(new Dimension(600, 600));
    setContentPane(chartPanel);
  }

  public static void main(String[] args)
  {
    Simulation simulation = new Simulation();
    simulation.pack();
    RefineryUtilities.centerFrameOnScreen(simulation);
    simulation.setVisible(true);
  }
}
