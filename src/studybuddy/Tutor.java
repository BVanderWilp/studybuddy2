package studybuddy;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.googlecode.objectify.ObjectifyService;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

/**
 * The class extends Person and implements Subject. It should be made when a tutor account is opened. It contains all of the information
 * needed to keep tutors and student subscribers up to date.
 * Add code here if it belongs to Tutor but should not affect Student.
 */

@Entity

public class Tutor extends Person implements Subject{
	
	@Id Long id;
	private double price;
	private double limit;
	private ArrayList<String> subscribers = new ArrayList<String>();
	
	/**
	 * Sets a price for this tutor and notifies all subscribers of the change.
	 * @param number: The new price for this tutor.
	 */
	public void setPrice(double number){ 
		price = number;
		String msg = new String(firstName + " " + lastName + " has updated their price to $" + String.format( "%.2f", number) + "/hr.");
		notifyObservers(msg);
	}
	
	public void setLimit(double number){  //add this method
		limit = number;
		String msg = new String(firstName + " " + lastName + " has updated their limit to " + String.format( "%.2f", number));
		notifyObservers(msg);
	}
	
	/** 
	 * Adds a subject and notifies all of the subscribers of the change.
	 * @param subject: The subject to add to the tutor's list of subjects.
	 */
	public void addSubject(String subject){
		subject = subject.toLowerCase();
		subject = subject.replaceAll("\\s", "");
		if(!subjects.contains(subject))
		{
			subjects.add(subject);
			notifyObservers(firstName + " " + lastName + " has added the subject " + subject + ".");
		}
	}
	
	/**
	 * Removes a subject and notifies all subscribers of the change.
	 * @param subject: The subject to remove from the tutor's list of subjects.
	 */
	public void removeSubject(String subject)
	{
		int i = subjects.indexOf(subject);
		if(subjects.contains(subject))
		{
			subjects.remove(i);
			notifyObservers(firstName + " " + lastName + " has removed the following subject from their list of tutored subjects: " + subject + ".");
		}
	}
	
	/**
	 * 
	 * @return The price of the tutor.
	 */
	public double getPrice(){ return price;}
	
	public double getLimit(){ return limit;}
	
	/**
	 * Adds a student to the list of this tutor's subscribers.
	 */
	public void registerObserver(Student name){ subscribers.add(name.getEmail());}
	
	/**
	 * Removes a student from this tutor's list of subscribers.
	 */
	public void removeObserver(Student name){ 
		int index = subscribers.indexOf(name.getEmail());
		subscribers.remove(index);
	}
	
	public ArrayList<String> getSubscribers() {
		return subscribers;
	}

	/**
	 * Notifies all of this tutor's subscribers of any change to the tutor's price or subjects.
	 */
	public void notifyObservers(String msg) {
		Date date = new Date();
		for(int i = 0; i < subscribers.size(); i++)
		{
			Student s = getStudent(subscribers.get(i));
			s.update(new Action(this, date, msg));
		}
		
	}
	
	public Student getStudent(String email)
	{
		ObjectifyService.register(Student.class);
		List<Student> students = ObjectifyService.ofy().load().type(Student.class).list();
		Student s = null;
		for (int i = 0; i < students.size(); i++) {
			if (students.get(i).getEmail().equals(email))
			{
				return students.get(i);
			}
		}
		return null;
	}
	
}