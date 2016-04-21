package studybuddy;
import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.AddressException;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import com.googlecode.objectify.ObjectifyService;

import java.util.*;

public class RemoveSubjectServlet extends HttpServlet {
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		ObjectifyService.register(Student.class);
		ObjectifyService.register(Tutor.class);
		List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
		List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
		String email = (String) req.getSession().getAttribute("email");
		String subject = (String) req.getParameter("subject");
		Person p = null;
		boolean match = false;
		for(int i = 0; i < tutors.size(); i += 1) {
			p = tutors.get(i);
       		if (p.getEmail().equals(email)) {
       			match = true;
       			break;
       		}
		}
		if(!match) {
			for(int i = 0; i < students.size(); i += 1) {
				p = students.get(i);
	       		if (p.getEmail().equals(email)) {
	       			break;
	       		}
			}
		}
		p.removeSubject(subject);
		ofy().save().entity(p).now();
		resp.sendRedirect("/settings.jsp");
	}
}
