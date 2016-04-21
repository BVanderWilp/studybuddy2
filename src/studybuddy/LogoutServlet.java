package studybuddy;

import java.io.IOException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class LogoutServlet extends HttpServlet{
	
	public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException
	{
		Cookie[] cookies = req.getCookies();

		if (cookies.length == 0) {
			resp.sendRedirect("/index.jsp");
		}

		String email = null;
		Cookie c = null;

		for(Cookie cookie : cookies){
		    if("email".equals(cookie.getName())){
		        email = cookie.getValue();
		        c = cookie;
		    }
		}

		if (email == null || c == null) {
			resp.sendRedirect("/index.jsp");
		}
		else {
			c.setValue(null);
			c.setMaxAge(0);
			resp.addCookie(c);
			resp.sendRedirect("/index.jsp");
		}
	}

}
