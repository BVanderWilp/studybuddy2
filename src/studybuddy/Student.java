package studybuddy;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/**
 * 
 * This is the student class. It extends the person class and implements Observer.
 * It contains the student's first and last name, their email, and a list of the tutors they
 *  are subscribed to. Add code here if it belongs to students but should not affect tutors.
 *
 */

@Entity

public class Student extends Person implements Observer {
	
	@Id Long id;
	private Subject tutorSubject;
	
	private ArrayList<String> subs = new ArrayList<String>();
	private ArrayList<Action> actions = new ArrayList<Action>();
	private ArrayList<String> tried = new ArrayList<String>();
	private ArrayList<Action> log = new ArrayList<Action>();
	
	/**
	 * 
	 * @param tutor: The tutor object that the student will be subscribed to
	 * This method adds the student to the tutors subscriber list so that the student will receive
	 * any updates about the tutor.
	 * The method also adds the tutor to the students sub list to make deletion of student accounts
	 * easier.
	 */
	public void subscribe(Tutor tutor) {
		tutor.registerObserver(this);
		subs.add(tutor.getEmail());
	}
	
	public ArrayList<String> getTried(){ return tried;}
	
	public void addTried(String attempt){ tried.add(attempt);}
	
	public boolean alreadyTried(String attempt)
	{ 
		for(int i = 0; i < tried.size(); i ++)
		{
			if(tried.get(i).equals(attempt))
				return true;
		}
		return false;
	}
	
	public void clearTried(){tried.clear();}
	
	/**
	 * 
	 * @param tutor: The tutor that the student will be unsubscribed from.
	 * This method will remove the student from the tutor's subscribers list and it will
	 * remove the tutor from the student's sub list.
	 */
	public void unsubscribe(Tutor tutor){
		tutor.removeObserver(this);
		subs.remove(tutor.getEmail());
	}
	
	/**
	 * @param updateMeddage: The information about the update performed by the tutor to be sent in the email
	 *
	 * This method is called any time a tutor that the student is subscribed to 
	 * updates prices or subjects. It then stores the action in a log to be displayed on the site.
	 */
	
	public void addAction(Action action)
	{
		actions.add(action);
	}
	
	/**
	 * 
	 * @return subs: The list of all tutors that this student is subscribed to.
	 *  Used for when the student deletes their account and we need to delete them from 
	 *  every tutor subscribers list.
	 */
	public ArrayList<String> getSubs(){return subs;}
	
	/**
	 * Takes care of actually sending the email to the student when an update occurs in a
	 * tutor that the student is subscribed to.
	 * 
	 * @param updateMessage The message to be sent to the student in the email.
	 */
	private void sendEmailUpdate(Action update){
		EmailSubscribersServlet email = new EmailSubscribersServlet(this);
		try {
			email.sendEmail(update);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void update(Action action) {
		log.add(action);
		sendEmailUpdate(action);
	}
	
	public Tutor getTutor(String email)
	{
		ObjectifyService.register(Tutor.class);
		List<Tutor> tutors = ObjectifyService.ofy().load().type(Tutor.class).list();
		Tutor t = null;
		for (int i = 0; i < tutors.size(); i++) {
			if (tutors.get(i).getEmail().equals(email))
			{
				return tutors.get(i);
			}
		}
		return null;
	}

}