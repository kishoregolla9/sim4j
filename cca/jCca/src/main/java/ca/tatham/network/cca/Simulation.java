package ca.tatham.network.cca;

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

  private static final double NODE_PERCENT_ERROR = 100;

  public Simulation()
  {
    super("CCA Simulation");
    double radioRange = 2.5;
    Network network = NetworkCreator.getNetwork(NetworkCreator.NetworkShape.SQUARE,
        NODE_PERCENT_ERROR, 25, radioRange);

    DefaultXYDataset dataset = new DefaultXYDataset();
    dataset.addSeries("Network", network.getPoints());

    JFreeChart chart = ChartFactory.createScatterPlot("Network", "", "", dataset,
        PlotOrientation.VERTICAL, false, true, false);
    final ChartPanel chartPanel = new ChartPanel(chart);
    chartPanel.setPreferredSize(new java.awt.Dimension(500, 270));
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
