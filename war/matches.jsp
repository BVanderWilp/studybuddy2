<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="studybuddy.Tutor" %>
<%@ page import="studybuddy.Student" %>
<%@ page import="studybuddy.Person" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="javax.servlet.RequestDispatcher" %>
<%@ page import="java.util.ArrayList" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
Cookie[] cookies = request.getCookies();
if (cookies.length == 0) {
	response.sendRedirect("/index.jsp");
}
String email = null;
for(Cookie cookie : cookies){
    if("email".equals(cookie.getName())){
        email = cookie.getValue();
    }
}
if (email == null) {
	response.sendRedirect("/index.jsp");
}
Person user = null;
ObjectifyService.register(Student.class);
ObjectifyService.register(Tutor.class);
List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
boolean found = false;
Person p = null;
for (int i = 0; i < students.size(); i++) {
	p = students.get(i);
	if (p.getEmail().equals(email)) {
		found = true;
		user = p;
		break;
	}
}
if (!found) {
	for (int i = 0; i < tutors.size(); i++) {
		p = tutors.get(i);
		if (p.getEmail().equals(email)) {
			found = true;
			user = p;
			break;
		}
	}
}
if (!found) {
	response.sendRedirect("/index.jsp");
}
pageContext.setAttribute("first_name", user.getFirstName());
pageContext.setAttribute("last_name", user.getLastName());
pageContext.setAttribute("email", user.getEmail());
session.setAttribute("email", user.getEmail());
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Study Buddy - Matches</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <link href="css/matches.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="css/sb-admin.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

    <div id="wrapper">

        <!-- Navigation -->
        <nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
            <!-- Brand and toggle get grouped for better mobile display -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="dashboard.jsp">Study Buddy</a>
            </div>
            <!-- Top Menu Items -->
            <ul class="nav navbar-right top-nav">
                <li class="dropdown">
                    <a href="#" class="dropdown-toggle" data-toggle="dropdown"><i class="fa fa-user"></i> ${fn:escapeXml(first_name)} ${fn:escapeXml(last_name)} <b class="caret"></b></a>
                    <ul class="dropdown-menu">
                        <li>
                            <a href="settings.jsp"><i class="fa fa-fw fa-gear"></i> Settings</a>
                        </li>
                        <li class="divider"></li>
                        <li>
                        	<form id="logoutForm" method="post" action="/logout">
                        		<a id="logoutButton"><i class="fa fa-fw fa-power-off"></i> Log Out</a>
                        	</form>
                        </li>
                    </ul>
                </li>
            </ul>
            <!-- Sidebar Menu Items - These collapse to the responsive navigation menu on small screens -->
            <div class="collapse navbar-collapse navbar-ex1-collapse">
                <ul class="nav navbar-nav side-nav">
                    <li>
                        <a href="dashboard.jsp"><i class="fa fa-fw fa-dashboard"></i> Dashboard</a>
                    </li>
                    <li>
                        <a href="matches.jsp"><i class="fa fa-fw fa-group"></i> 
                        <%
                        if (user.getIsTutor()) {
                        %> 
                        Student Matches</a>
                        <%
                        }
                        else {
                        %>
                        Tutor Matches</a>
                        <%
                        }
                        %>
                    </li>
                    <li>
                        <a href="settings.jsp"><i class="fa fa-fw fa-gear"></i> Settings</a>
                    </li>
                    <li>
                        <a href="inbox.jsp"><i class="fa fa-fw fa-envelope"></i> Inbox</a>
                    </li>
<!--
                    <li>
                        <a href="javascript:;" data-toggle="collapse" data-target="#demo"><i class="fa fa-fw fa-arrows-v"></i> Dropdown <i class="fa fa-fw fa-caret-down"></i></a>
                        <ul id="demo" class="collapse">
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                            <li>
                                <a href="#">Dropdown Item</a>
                            </li>
                        </ul>
                    </li>
-->
                </ul>
            </div>
            <!-- /.navbar-collapse -->
        </nav>

        <div id="page-wrapper">

            <div class="container-fluid">

                <!-- Page Heading -->
                <div class="row">
                    <div class="col-lg-12">
                        <%
                        if (user.getIsTutor()) {
                        %>
                        	<h2>Your Students</h2>
                        	<br>
                        	<table class="table table-hover">
                        		<tr>
                        			<th>#</th>
                        			<th>First Name</th>
                        			<th>Last Name</th>
                        			<th>Email</th>
                        			<th>Subjects</th>
                        		</tr>
                        		<%
                        		Tutor t = (Tutor)user;
                        		ArrayList<String> subscribers = t.getSubscribers();
                        		for (int i = 0; i < subscribers.size(); i++) { 
                        			Student s = t.getStudent(subscribers.get(i));
                        		%>
                        			<tr>
                        				<td><% out.print(i + 1); %></td>
                        				<td><% out.print(s.getFirstName()); %></td>
                        				<td><% out.print(s.getLastName()); %></td>
                        				<td><% out.print(s.getEmail()); %></td>
                        				<td>
                        				<%
                        				ArrayList<String> subjects = s.getSubjects();
                        				String subjectString = "";
                        				for (int j = 0; j < subjects.size(); j++) {
                        					String subject = subjects.get(j);
            	               				for (int k = 0; k < subject.length(); k++) {
            	               					if (Character.isDigit(subject.charAt(k))) {
            	               						subject = subject.substring(0, k) + " " + subject.substring(k, subject.length());
            	               						break;
            	               					}
            	               				}
            	               				subjectString += subject.toUpperCase() + ", ";
                        				}
                        				if (!subjectString.equals("")) {
                        					out.print(subjectString.substring(0, subjectString.length() - 2));
                        				}
                        				%>
                        				</td>
                        	       </tr>
                        		<%
                        		}
                        		%>
							</table>
                        <%
                        }
                        else { %>
                        	<h2>Your Tutors</h2>
                        	<br>
                        	<table class="table table-hover">
                        		<tr>
                        			<th>#</th>
                        			<th>First Name</th>
                        			<th>Last Name</th>
                        			<th>Email</th>
                        			<th>Price</th>
                        			<th>Subjects</th>
                        			<th>Unsubscribe</th>
                        		</tr>
                        		<%
                        		Student s = (Student)user;
                        		ArrayList<String> subscribers = s.getSubs();
                        		for (int i = 0; i < subscribers.size(); i++) { 
                        			Tutor t = s.getTutor(subscribers.get(i));
                        		%>
                        			<tr>
                        				<td><% out.print(i + 1); %></td>
                        				<td><% out.print(t.getFirstName()); %></td>
                        				<td><% out.print(t.getLastName()); %></td>
                        				<td><% out.print(t.getEmail()); %></td>
                        				<td><% out.print("$" + String.format( "%.2f", t.getPrice()) + "/hr"); %></td>
                        				<td>
                        				<%
                        				ArrayList<String> subjects = t.getSubjects();
                        				String subjectString = "";
                        				for (int j = 0; j < subjects.size(); j++) {
                        					String subject = subjects.get(j);
            	               				for (int k = 0; k < subject.length(); k++) {
            	               					if (Character.isDigit(subject.charAt(k))) {
            	               						subject = subject.substring(0, k) + " " + subject.substring(k, subject.length());
            	               						break;
            	               					}
            	               				}
            	               				subjectString += subject.toUpperCase() + ", ";
                        				}
                        				if (!subjectString.equals("")) {
                        					out.print(subjectString.substring(0, subjectString.length() - 2));
                        				}
                        				%>
                        				</td>
                        				<td>
                        					<form id='unsubTutor' method='get' action='/unsubscribe'>
												<input class="btn btn-primary" type="submit" value="Unsubscribe" />
												<input name="unsubEmail" value="<% out.print(t.getEmail()); %>" class="hidden">
											</form>
										</td>
                        			</tr>
                        		<%
                        		}
                        		%>
							</table>
                        <%
                        }
                        %>
                    </div>
                </div>
                <!-- /.row -->

            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->

    </div>
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>
    
    <script src="js/matches.js"></script>

</body>

</html>