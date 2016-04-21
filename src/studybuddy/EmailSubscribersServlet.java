package studybuddy;

import java.io.UnsupportedEncodingException;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailSubscribersServlet {
	   public String to;
	   public String from = "priceupdate@studybuddy-1105@appspotmail.com";
	   
	   EmailSubscribersServlet(Person student){
		   this.to = student.getEmail();
	   }
	   public void sendEmail(Action a) throws UnsupportedEncodingException {
		   try{
			   Properties props = new Properties();
			   Session session = Session.getDefaultInstance(props, null);
			   String msgBody = a.getAction();
			   Message msg = new MimeMessage(session);
			   msg.setFrom(new InternetAddress("priceupdate@study-buddy-1105.appspotmail.com", "Study Buddy Price Update Service"));
			   msg.addRecipient(Message.RecipientType.TO, new InternetAddress(to, ""));
			   msg.setSubject("Price Update");
			   msg.setText(msgBody);
			   Transport.send(msg);
		   }
		   catch(AddressException e){}
		   catch (MessagingException e) {}
	   } 
}