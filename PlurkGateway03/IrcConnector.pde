import java.util.Date;
import java.util.Timer;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.jplurk.ISettings.Simple;
import com.google.jplurk.PlurkClient;
import com.google.jplurk.PlurkNotifier;
import com.google.jplurk.PlurkSettings;
import com.google.jplurk.Qualifier;
import com.google.jplurk.PlurkNotifier.NotificationListener;
import com.google.jplurk.exception.PlurkException;


String PlurkUsername; 
String PlurkPassword;
String PlurkAPIkey;
PlurkClient client;


void SetupPlurk() {
  ISettings.Simple settings = new Simple( PlurkAPIkey, Lang.en);
  client = new PlurkClient(settings);
  // sign in the plurk account
  client.login( PlurkUsername, PlurkPassword);
  PlurkNotifier notifier = client.getUserChannel();
  notifier.addNotificationListener(new NotificationListener() {
    //@Override
    public void onNotification(JSONObject message) throws Exception {
      // do something with notification
      //println(message);
      
      String PlurkSender = "";
      try { 
        PlurkSender = str(message.getJSONObject("response").getInt("user_id"));
      }
      catch (JSONException ex) {
        PlurkSender = str(message.getInt("user_id"));
      }
      
      //TODO
      // convert user_id to nickname
      // public JSONObject getPublicProfile(String userId)
      JSONObject UserProfile = client.getPublicProfile(PlurkSender);
      PlurkSender = UserProfile.getJSONObject("user_info").getString("nick_name");
      
      String PlurkQUalifier = "";
      try { 
        PlurkQUalifier = message.getJSONObject("response").getString("qualifier");
      }
      catch (JSONException ex) {
        PlurkQUalifier = message.getString("qualifier");
      }
      println(message);
      String PlurkMessage = "";
      try { 
        PlurkMessage = message.getJSONObject("response").getString("content_raw");
      }
      catch (JSONException ex) {
        PlurkMessage = message.getString("content_raw");  
      }
      PlurkToOsc( PlurkSender, PlurkQUalifier + " " + PlurkMessage );
      
    }
  }
  );
  Timer timer = new Timer();
  timer.schedule(notifier, new Date(), 8 * 1000);
}


// try and error


void PlurkToOsc(String PlurkSender, String PlurkMessage) {
  PlurkMessage = trim(PlurkMessage);
  OscMessage SendOscMessage = new OscMessage(OscSendAddress);
  SendOscMessage.add(PlurkSender);
  String[] OscMessageArguments = split(PlurkMessage, ' ');
  for(int i=0; i < OscMessageArguments.length; i++) {
    try
    {
      float f = Float.valueOf(OscMessageArguments[i].trim()).floatValue();
      SendOscMessage.add(f);
    }
    catch (NumberFormatException nfe)
    {
      SendOscMessage.add(OscMessageArguments[i]);
    }

    //SendOscMessage.add(OscMessageArguments[i]);
  }
  oscP5.send(SendOscMessage, OscDestination);
  ActivityLogAddLine("OSC SEND " + OscSendAddress + " " + PlurkSender + " " + PlurkMessage);
}







