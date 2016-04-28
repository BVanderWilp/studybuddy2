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

public class TutorSignUpServlet extends HttpServlet {
	
	/**
	 * Registers new tutor accounts in the DataStore. Must pass data: firstName, lastName, email,
	 * price (as a string). If any field is null or if the price is less than 0.00, the tutor
	 * will not be added to the DataStore. **NOTE: Will need to add subject to this function after 
	 * front end is done**.
	 */
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Tutor.class);
		String firstName = req.getParameter("firstName");
		String lastName = req.getParameter("lastName");
		String email = req.getParameter("email");
		List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
		List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
		for (int i = 0; i < students.size(); i++) {
       		if(students.get(i).getEmail().equals(email))
       		{
       			resp.sendRedirect("/index.jsp?page=signupError");
       			return;
       		}
       	}
		for (int i = 0; i < tutors.size(); i++) {
       		if(tutors.get(i).getEmail().equals(email))
       		{
       			resp.sendRedirect("/index.jsp?page=signupError");
       			return;
       		}
       	}
		String passwordString = req.getParameter("password");
		byte[] passBytes = passwordString.getBytes("UTF-8");
		MessageDigest md = null;
		try {
			 md = MessageDigest.getInstance("MD5");
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		byte[] password = md.digest(passBytes);
		String priceString = req.getParameter("price");
		double price = Double.parseDouble(priceString);
		
		String limitString = req.getParameter("limit"); 
		double limit = Double.parseDouble(limitString);
				
		Tutor profile = new Tutor();
		profile.setFirstName(firstName);
		profile.setLastName(lastName);
		profile.setEmail(email);
		profile.setPassword(password);
		profile.setPrice(price);
		profile.setLimit(limit);
		profile.setIsTutor(true);
		ofy().save().entity(profile).now();
		Cookie cookie = new Cookie("email", email);
		resp.addCookie(cookie);
        resp.sendRedirect("/dashboard.jsp");
	}

}
