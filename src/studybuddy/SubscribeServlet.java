package studybuddy;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.googlecode.objectify.ObjectifyService;
import static com.googlecode.objectify.ObjectifyService.ofy;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.List;

public class SubscribeServlet extends HttpServlet {
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException
	{
		ObjectifyService.register(Student.class);
		ObjectifyService.register(Tutor.class);
		List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
		List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
		String email = (String) req.getSession().getAttribute("email");
		String tutorEmail = (String) req.getSession().getAttribute("tutor_email");
		Student s = null;
		Tutor t = null;
		for (int i = 0; i < students.size(); i++) {
			if (students.get(i).getEmail().equals(email))
			{
				s = students.get(i);
				break;
			}
		}
		for (int i = 0; i < tutors.size(); i++) {
			if (tutors.get(i).getEmail().equals(tutorEmail))
			{
				t = tutors.get(i);
				break;
			}
		}
		s.subscribe(t);
		ofy().save().entity(s).now();
		ofy().save().entity(t).now();
		ServletContext sc = getServletContext();
		RequestDispatcher rd = sc.getRequestDispatcher("/getTutor");
		rd.forward(req, resp);
	}

}
