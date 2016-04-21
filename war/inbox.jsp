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
<%@ page import="java.util.Iterator" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreServiceFactory" %>
<%@ page import="com.google.appengine.api.datastore.DatastoreService" %>
<%@ page import="com.google.appengine.api.datastore.Query" %>
<%@ page import="com.google.appengine.api.datastore.Entity" %>
<%@ page import="com.google.appengine.api.datastore.FetchOptions" %>
<%@ page import="com.google.appengine.api.datastore.Key" %>
<%@ page import="com.google.appengine.api.datastore.KeyFactory" %>

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
                        <a href="inbox.jsp"><i class="fa fa-fw fa-gear"></i> Inbox</a>
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
                        	<h2>Your Inbox</h2>
                        	<br>
                        	
                   
                        
			    <%
				    pageContext.setAttribute("email", user.getEmail());
			    	ArrayList<String> inboxes = new ArrayList<String>();
			    	if(user.getIsTutor() == true)
			    	{
				    	inboxes.add(user.getEmail());
				    }
				    else
				    {
				    	for(String tutorEmail : ((Student)user).getSubs())
				    	{
				    		inboxes.add(tutorEmail);
				    	}
				    }
				    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
				    for(String inbox : inboxes)
				    {
				    	%> <%= inbox %> <%
					    Key blogKey = KeyFactory.createKey("Blog", inbox);
					    // Run an ancestor query to ensure we see the most up-to-date
					    // view of the Greetings belonging to the selected Blog.
					    Query query = new Query("Post", blogKey).addSort("date", Query.SortDirection.DESCENDING);
					    List<Entity> posts = datastore.prepare(query).asList(FetchOptions.Builder.withDefaults());       
				        if (posts.isEmpty()) {
				            %>
				            <p>There are no posts on this blog yet.</p>
				                <!-- Begin post new blog post Modal -->         
				            <%
				        } else {  %>
				                <div class="col-lg-8 col-lg-offset-2 col-md-10 col-md-offset-1">
				                    <div class="post-preview">
				                        <%
				                            int count = 0; 
				                            for (Iterator<Entity> postIt = posts.iterator(); postIt.hasNext() && count < 5; count++) {
				                                Entity post = postIt.next();
				                                pageContext.setAttribute("post_title", post.getProperty("title"));
				                                pageContext.setAttribute("post_content", post.getProperty("content"));
				                                pageContext.setAttribute("post_user", post.getProperty("user"));
				                                pageContext.setAttribute("post_date", post.getProperty("date"));
				                                %>
				                                <div class="post-preview">
				                                    <h4>${fn:escapeXml(post_title)}</h4><br>
				                                    <span class="small">${fn:escapeXml(post_content)}</span>
				                                    <blockquote><span class="small">Posted by ${fn:escapeXml(post_user)} at ${fn:escapeXml(post_date)}</span></blockquote>
				                                    <hr>
				                                </div>
				                            <% } 
			         } 
			     }%>
                        
                     </div>
                  <ul class="pager">
		           <li class="previous">
		             <% if (user != null) { %>
		                    <a  data-toggle="modal" href="#blogPostModal">Post a New Entry</a>
		                <% }

		              %>
		            </li>
		            <li class="next">
		                <a href="/archives.jsp">View All Posts &rarr;</a>
		            </li>
		         </ul>
                </div>
                <!-- /.row -->
		         
            </div>
            <!-- /.container-fluid -->

        </div>
        <!-- /#page-wrapper -->
        
        
        

    </div>
    
    <div id="blogPostModal" class="modal fade" role="dialog">
	  <div class="modal-dialog">
	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">Please post your entry</h4>
	      </div>
	      <div class="modal-body">
	         <form id="submitBlogPost" action="/post" method="post">
                <div id="titleGroup" class="form-group">
                    <label for="title">Title: </label><input type="text" name="title" class="form-control" id="postTitle">
                </div>
                <div class="form-group">
			        <label for="content">Content: </label><textarea class="form-control" name="content" rows="3" cols="50" id="postContent"></textarea>
                </div>
			    <%
			    	if(user.getIsTutor() == false)
			    	{
				    	%>
    				    Tutor email: 
				    	<input type="text" name="blogName"/>
				    	<%
			    	} else
			    	{
			    		%>
			    		<input type="hidden" name="blogName" value="${fn:escapeXml(email)}"/>
			    		<%
			    	}
			    %>
			    <input type="hidden" name="user" value="${fn:escapeXml(email)}"/>
			  </form>
	      </div>
	      <div class="modal-footer">
            <button type="button" class="btn btn-default pull-left"  onclick="postToBlog()">Post</button>
	        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	      </div>
	    </div>
	
	  </div>
	</div>
    <!-- End post new blog post Modal -->

    
    <!-- /#wrapper -->

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-1.11.3.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="js/bootstrap.min.js"></script>
    
    <script src="js/matches.js"></script>
    
    <script>
    function postToBlog() 
    {
    	
        var postTitle = document.getElementById("postTitle");
        var postContent = document.getElementById("postContent");

        if (postTitle.value == null || postTitle.value == "") 
        {
             $("#postTitle").notify(  "Please enter the post title", "warn", { position:"right" } );
            return false;
        }
        if (postContent.value == null || postContent.value == "") 
        {
            $("#postContent").notify(  "Please enter the post content", "warn", { position:"right" } );
            return false;
        }
       document.getElementById("submitBlogPost").submit();
    }

    </script>

</body>

</html>