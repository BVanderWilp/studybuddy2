package studybuddy;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

import com.googlecode.objectify.ObjectifyService;

import studybuddy.Tutor;
import static com.googlecode.objectify.ObjectifyService.ofy;

public class SaveProfileInformationServlet extends HttpServlet {
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		ObjectifyService.register(Tutor.class);
		ObjectifyService.register(Student.class);
		String firstName = req.getParameter("first-name");
		String lastName = req.getParameter("last-name");
		String email = req.getParameter("email");
		String passwordString = req.getParameter("password");
		byte[] passBytes = passwordString.getBytes("UTF-8");
		MessageDigest md = null;
		try {
			 md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		byte[] password = md.digest(passBytes);
		
		List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
       	List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
       	boolean found = false;
       	Person p = new Student();
       	for (int i = 0; i < students.size(); i++) {
       		p = students.get(i);
       		if (p.getEmail().equals(email)) {
      			found = true;
       			break;
       		}
       	}
       	if (!found) {
        	for (int i = 0; i < tutors.size(); i++) {
        		p = tutors.get(i);
        		if (p.getEmail().equals(email)) {
        			found = true;
        			break;
        		}
        	}
       	}
       	if (found) {
       		if(!firstName.equals(""))
       			p.setFirstName(firstName);
       		if(!lastName.equals(""))
       		p.setLastName(lastName);
       		if (!passwordString.equals("")) {
       			p.setPassword(password);
       		}
       		ofy().save().entity(p).now();
       		Cookie[] cookies = req.getCookies();
           	if (cookies.length == 0) {
           		resp.sendRedirect("/index.jsp");
           	}
           	String cookieEmail = null;
           	Cookie c = null;
           	for(Cookie cookie : cookies){
           	    if("email".equals(cookie.getName())){
           	        cookieEmail = cookie.getValue();
           	        c = cookie;
           	    }
           	}
           	if (cookieEmail == null || c == null) {
           		resp.sendRedirect("/index.jsp");
           	}
           	if (!cookieEmail.equals(email)) {
           		c.setValue(null);
    			c.setMaxAge(0);
    			resp.addCookie(c);
    			Cookie cookie = new Cookie("email", email);
    			resp.addCookie(cookie);
           	}
           	resp.sendRedirect("/settings.jsp");
       	}
       	else {
       		resp.sendRedirect("/index.jsp");
       	}
	}

}
