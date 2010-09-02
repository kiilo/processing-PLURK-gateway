P5Properties props;

// this function reads our properties file
void SetupP5Properties() {
  try {
    props = new P5Properties();
    // load a configuration from a file inside the data folder
    props.load(openStream("../config.pde"));
    OscRecvPort = props.getIntProperty("osc.receiving.port",8000);
    OscDestHost = props.getStringProperty("osc.destination.host","localhost");
    OscDestPort = props.getIntProperty("osc.destination.port",9000);
    OscRecvAddress = props.getStringProperty("osc.address.recv","/toTwitter");
    OscSendAddress = props.getStringProperty("osc.address.send","/fromTwitter");
    // read TWITTER config part
    PlurkUsername = props.getStringProperty("plurk.username","");
    PlurkPassword = props.getStringProperty("plurk.password","");
    PlurkAPIkey = props.getStringProperty("plurk.APIkey","");
  }
  catch(IOException e) {
    println("couldn't read config file..."+e.getMessage());
  }
}

/**
 * simple convenience wrapper object for the standard
 * Properties class to return pre-typed numerals
 */
class P5Properties extends Properties {

  boolean getBooleanProperty(String id, boolean defState) {
    return boolean(getProperty(id,""+defState));
  }

  int getIntProperty(String id, int defVal) {
    return int(getProperty(id,""+defVal)); 
  }

  float getFloatProperty(String id, float defVal) {
    return float(getProperty(id,""+defVal)); 
  }

  String getStringProperty(String id, String defVal) {
    return trim(getProperty(id,""+defVal)); 
  }
}

