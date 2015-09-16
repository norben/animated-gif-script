import javax.swing.JCheckBox;
import javax.swing.JFormattedTextField;
import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.JTabbedPane;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JTextField;
import java.awt.event.ActionListener;
import java.awt.event.ActionEvent;
import java.awt.EventQueue;
import java.awt.GridLayout;
import java.io.File;
import java.io.IOException;
import java.lang.Process;
import java.text.NumberFormat;

public class AnimatedGifGUI extends JFrame {

  static final long serialVersionUID = 40L;

  public static void main(String[] args) {
    EventQueue.invokeLater(new Runnable() {
      public void run() {
        new AnimatedGifGUI().setVisible(true);
      }
    });
  }

  public AnimatedGifGUI() {

    final AnimatedGifProperties agp = new AnimatedGifProperties();

    setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
    setLocationRelativeTo(null);
    setSize(600,400);
    setTitle("Animated Gif GUI");

    JPanel propPanel = new JPanel();
    GridLayout propGrid = new GridLayout(0, 2);
    propPanel.setLayout(propGrid);

    JLabel durationJL = new JLabel("duration");
    JLabel freqJL = new JLabel("freq");
    JLabel importExecutionPathJL = new JLabel("importExecutionPath");
    JLabel convertExecutionPathJL = new JLabel("convertExecutionPath");
    JLabel destinationFolderJL = new JLabel("destinationFolder");
    JLabel testImageNameJL = new JLabel("testImageName");
    JLabel imageSuffixJL = new JLabel("imageSuffix");
    JLabel imageExtensionJL = new JLabel("imageExtension");
    JLabel deleteTemporaryImagesJL = new JLabel("deleteTemporaryImages");

    NumberFormat intFormat = NumberFormat.getNumberInstance();
    intFormat.setParseIntegerOnly(true);
    intFormat.setMinimumIntegerDigits(1);

    final JFormattedTextField durationJTF = new JFormattedTextField(intFormat);
    durationJTF.setText(agp.getProperty("duration"));
    final JFormattedTextField freqJTF = new JFormattedTextField(intFormat);
    freqJTF.setText(agp.getProperty("freq"));
    final JTextField importExecutionPathJTF = new JTextField(agp.getProperty("importExecutionPath"));
    final JTextField convertExecutionPathJTF = new JTextField(agp.getProperty("convertExecutionPath"));
    final JTextField destinationFolderJTF = new JTextField(agp.getProperty("destinationFolder"));
    final JTextField testImageNameJTF = new JTextField(agp.getProperty("testImageName"));
    final JTextField imageSuffixJTF = new JTextField(agp.getProperty("imageSuffix"));
    final JTextField imageExtensionJTF = new JTextField(agp.getProperty("imageExtension"));
    final JCheckBox deleteTemporaryImagesJCB = new JCheckBox("");
    deleteTemporaryImagesJCB.setSelected(agp.getProperty("deleteTemporaryImages").equals("0"));

    JButton propSave = new JButton("Save");
    JButton propLoad = new JButton("Load");

    durationJTF.setColumns(4);
    freqJTF.setColumns(2);
    importExecutionPathJTF.setColumns(20);
    convertExecutionPathJTF.setColumns(20);
    destinationFolderJTF.setColumns(35);
    testImageNameJTF.setColumns(10);
    imageSuffixJTF.setColumns(10);
    imageExtensionJTF.setColumns(5);

    propPanel.add(durationJL); propPanel.add(durationJTF);
    propPanel.add(freqJL); propPanel.add(freqJTF);
    propPanel.add(importExecutionPathJL); propPanel.add(importExecutionPathJTF);
    propPanel.add(convertExecutionPathJL); propPanel.add(convertExecutionPathJTF);
    propPanel.add(destinationFolderJL); propPanel.add(destinationFolderJTF);
    propPanel.add(testImageNameJL); propPanel.add(testImageNameJTF);
    propPanel.add(imageSuffixJL); propPanel.add(imageSuffixJTF);
    propPanel.add(imageExtensionJL); propPanel.add(imageExtensionJTF);
    propPanel.add(deleteTemporaryImagesJL); propPanel.add(deleteTemporaryImagesJCB);

    propPanel.add(propLoad);
    propPanel.add(propSave);

    propSave.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent event) {
        agp.setProperty("duration", durationJTF.getText());
        agp.setProperty("freq", freqJTF.getText());
        agp.setProperty("importExecutionPath", importExecutionPathJTF.getText());
        agp.setProperty("convertExecutionPath", convertExecutionPathJTF.getText());
        agp.setProperty("destinationFolder", destinationFolderJTF.getText());
        agp.setProperty("testImageName", testImageNameJTF.getText());
        agp.setProperty("imageSuffix", imageSuffixJTF.getText());
        agp.setProperty("imageExtension", imageExtensionJTF.getText());
        if (deleteTemporaryImagesJCB.isSelected()) {
          agp.setProperty("deleteTemporaryImages", "0");
        } else {
          agp.setProperty("deleteTemporaryImages", "1");
        }
        agp.save();
      };
    });

    propLoad.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent event) {
        agp.load();
        durationJTF.setText(agp.getProperty("duration"));
        freqJTF.setText(agp.getProperty("freq"));
        importExecutionPathJTF.setText(agp.getProperty("importExecutionPath"));
        convertExecutionPathJTF.setText(agp.getProperty("convertExecutionPath"));
        destinationFolderJTF.setText(agp.getProperty("destinationFolder"));
        testImageNameJTF.setText(agp.getProperty("testImageName"));
        imageSuffixJTF.setText(agp.getProperty("imageSuffix"));
        imageExtensionJTF.setText(agp.getProperty("imageExtension"));
        deleteTemporaryImagesJCB.setSelected(agp.getProperty("deleteTemporaryImages").equals("0"));
      };
    });

    JPanel animGifPanel = new JPanel();
    GridLayout animGifGrid = new GridLayout(0, 2);
    animGifPanel.setLayout(animGifGrid);

    JLabel scriptPathJL = new JLabel("Script Path");
    final JTextField scriptPathJTF = new JTextField("../manual_selection.sh");
    scriptPathJTF.setColumns(15);

    JLabel runScriptJL = new JLabel("");

    JButton runScriptJB = new JButton("Run script");
    runScriptJB.addActionListener(new ActionListener() {
      @Override
      public void actionPerformed(ActionEvent event) {
        File scriptFile = new File(scriptPathJTF.getText());
        if (!scriptFile.exists()) {
          System.out.println("Script File '" + scriptPathJTF.getText() + "' doesn't exist.");
        }
        else {
          File convertCommandFile = new File(convertExecutionPathJTF.getText());
          if (! convertCommandFile.exists()) {
            System.out.println("Command convert '" + convertExecutionPathJTF.getText() + "' not found.");
          }
          else {
            File importCommandFile = new File(importExecutionPathJTF.getText());
            if (! importCommandFile.exists()) {
              System.out.println("Command import '" + importExecutionPathJTF.getText() + "' not found.");
            }
            else {
              String command =  "bash -c \"" + scriptPathJTF.getText() + "\"";
              command = command + " -cc \"" + convertExecutionPathJTF.getText() + "\"";
              command = command + " -ci \"" + importExecutionPathJTF.getText() + "\"";
              command = command + " -if \"" + destinationFolderJTF.getText() + "\"";
              command = command + " -ti \"" + testImageNameJTF.getText() + "\"";
              command = command + " -is \"" + imageSuffixJTF.getText() + "\"";
              command = command + " -ie \"" + imageExtensionJTF.getText() + "\"";
              command = command + " -ds \"" + durationJTF.getText() + "\"";
              command = command + " -fs \"" + freqJTF.getText() + "\"";
              if (deleteTemporaryImagesJCB.isSelected()) {
                command = command + " -df \"0\"";
              }
              else {
                command = command + " -df \"1\"";
              }
              // System.out.println(command);
              try {
                Process p = Runtime.getRuntime().exec(command);
              }
              catch (IOException ioe) {
                ioe.printStackTrace();
              }
              finally {
                System.out.println("Animated gif capture finished.");
              }
            }
          }
        }
      };
    });

    animGifPanel.add(scriptPathJL);
    animGifPanel.add(scriptPathJTF);
    animGifPanel.add(scriptPathJTF);
    animGifPanel.add(runScriptJB);
    animGifPanel.add(runScriptJL);

    JTabbedPane tabbedPane = new JTabbedPane();
    tabbedPane.addTab("Properties", propPanel);
    tabbedPane.addTab("Create Animated Gif", animGifPanel);
    add(tabbedPane);

  }
}
