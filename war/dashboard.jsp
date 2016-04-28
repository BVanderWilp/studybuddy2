<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Collections" %>
<%@ page import="studybuddy.Tutor" %>
<%@ page import="studybuddy.Student" %>
<%@ page import="studybuddy.Person" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%@ page import="javax.servlet.ServletContext" %>
<%@ page import="javax.servlet.RequestDispatcher" %>
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

    <title>Study Buddy - Dashboard</title>

    <!-- Bootstrap Core CSS -->
    <link href="css/bootstrap.min.css" rel="stylesheet">
    
    <link href="css/dashboard.css" rel="stylesheet">

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
                        <h1 class="page-header">
                        	Welcome, ${fn:escapeXml(first_name)}!
                        </h1>
                        <h3 class="page-header">
                        	Update Your Hourly Rate
                        </h3>
                        <div class="row">
                        	<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
                        		<h4>Your current hourly rate is 
                        		<%
                        			Tutor t = (Tutor)user;
                        			out.print("$" + String.format( "%.2f", t.getPrice()) + "/hr");
                        		%>
                        		<br></br>
                        		You are tutoring 
                        		<%
                        			out.print(String.format( "%d", t.getSubscribers().size()));
                        		%> 
                        		students out of 
                        		<%
                        			out.print(String.format( "%.0f", t.getLimit()));
                        		%>
                        		</h4>
                        		<h5>An email will be sent to your subscribed students when your hourly rate is updated.</h5>
                        	</div>
                        </div>
                        <br>
                        <div class="row">
                        	<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
                        		<div id="info" style="color: red;"></div>
	                        	<form id="changePriceForm" method="post" action="/changePrice">
	                        		New Price
	                        		<input class="hidden" name="email" value="${fn:escapeXml(email)}">
	                        		<input id="newPrice" class="form-control" type="text" name="price">
	                        		<br>
		                        </form>
		                        <a id="changePriceButton" class="btn btn-primary">Update Rate</a>
	                        </div>
                        </div>
                        <%
                        }
                        else {
                        %>
                        <h1 class="page-header">
                        	Welcome, ${fn:escapeXml(first_name)}!
                        </h1>
                        <div class="container" id="option">
	                        <div class="row">
	                        	<div class="col-sm-offset-1 col-sm-5">
	                        		<h2 class="optionLabel">${fn:escapeXml(tutor_first_name)} ${fn:escapeXml(tutor_last_name)}</h2>
	                        	</div>
	                        	<div class="col-sm-5 col-sm-offset-1">
	                        		<h3 class="optionLabel">${fn:escapeXml(tutor_price)}</h3>
	                        	</div>
	                        </div>
	                        <div class="row">
	                        	<div class="col-sm-offset-1 col-sm-10 col-sm-offset-1">
	                        		<h4 class="optionLabel">${fn:escapeXml(tutor_subjects)}</h4>
	                        	</div>
	                        </div>
	                        <br>
	                        <%
	                        if(request.getAttribute("tutor_first_name") != null && request.getAttribute("tutor_price") != " "){%>
	                        <div class="row">
                        		<form id='subTutor' method='get' action='/subscribe'>
									<input class="btn btn-primary" type="submit" value="Subscribe to this Tutor" />
								</form>
	                        </div>
	                        <br>
	                        <div class="row">
                        		<form id='getTutor' method='get' action='/getTutor'>
									<input class="btn btn-info" type="submit" value="View Next Tutor" />
								</form>
	                        </div>
	                        <%
	                        }
	                        else{ %>
	                        <div class="row">
                        		<form id='getTutor' method='get' action='/getTutor'>
									<button type="submit" class="btn btn-default btn-lg">
  										<span class="glyphicon glyphicon-user" aria-hidden="true"></span> Browse Tutors
									</button>
								</form>
	                        </div>
	                        <%
	                        }%>
	                    </div>
                        <%
                        }
     					String temp = (String) request.getAttribute("tutor_email");
                        session.setAttribute("tutor_email", temp);
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
    
    <script src="js/dashboard.js"></script>

</body>

</html>