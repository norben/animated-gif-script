import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Hashtable;
import java.util.Set;
import java.util.Iterator;
import java.util.Properties;

public class AnimatedGifProperties extends Properties {

  static final long serialVersionUID = 41L;

  private final String propFile = "config.properties";
  private Hashtable<String, String> hash;

  public AnimatedGifProperties() {
    hash = new Hashtable<String, String>();
    hash.put("duration", "4");
    hash.put("freq", "1");
    hash.put("importExecutionPath", "/usr/bin/import");
    hash.put("convertExecutionPath", "/usr/bin/convert");
    hash.put("destinationFolder", "${HOME}/Images/norben_animated_gifs");
    hash.put("testImageName", "test.gif");
    hash.put("imageSuffix", "screen");
    hash.put("imageExtension", "gif");
    hash.put("deleteTemporaryImages", "1");

    File file = new File(this.propFile);
    if (file.exists()) {
      this.load();
      Set<String> keys = this.stringPropertyNames();
      Iterator<String> iterator = keys.iterator();
      while(iterator.hasNext()) {
        String key = iterator.next();
        if (!this.hash.containsKey(key)) {
          this.remove(key);
        }
      }
      keys = hash.keySet();
      iterator = keys.iterator();
      while(iterator.hasNext()) {
        String key = iterator.next();
        if (!this.containsKey(key)) {
          this.setProperty(key, hash.get(key));
        }
      }
    }
    else {
      this.setProperty("duration", "4");
      this.setProperty("freq", "1");
      this.setProperty("importExecutionPath", "/usr/bin/import");
      this.setProperty("convertExecutionPath", "/usr/bin/convert");
      this.setProperty("destinationFolder", "${HOME}/Images/norben_animated_gifs");
      this.setProperty("testImageName", "test.gif");
      this.setProperty("imageSuffix", "screen");
      this.setProperty("imageExtension", "gif");
      this.setProperty("deleteTemporaryImages", "1");
    }
  }

  public void load() {
    FileInputStream input = null;
    try {
      input = new FileInputStream(this.propFile);
      this.load(input);
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }
    finally {
      if (input != null) {
        try {
          input.close();
        }
        catch (IOException ioe) {
          ioe.printStackTrace();
        }
      }
    }
  }

  public void save() {
    FileOutputStream output = null;
    try {
      output = new FileOutputStream(this.propFile);
      this.store(output, null);
    }
    catch (IOException ioe) {
      ioe.printStackTrace();
    }
    finally {
      if (output != null) {
        try {
          output.close();
        }
        catch (IOException ioe) {
          ioe.printStackTrace();
        }
      }
    }
  }

}
