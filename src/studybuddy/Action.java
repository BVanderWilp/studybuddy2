package studybuddy;

import java.util.Date;

/**
 * This class is used for logging the actions of tutors. It stores the date that the activity occurred, the tutor that performed the activity,
 * and a string that describes the activity. It can be used to send updates to the subscribers in the tutor's subscriber list.
 * @author Christopher Gill
 *
 */
public class Action {
	private Subject actor;
	private Date date;
	private String action;
	
	public Action(Subject person, Date time, String msg)
	{
		actor = person;
		date = time;
		action = msg;
	}
	
	/**
	 * 
	 * @param person The tutor that performed the activity.
	 */
	public void setActor(Subject person){actor = person;}
	
	/**
	 * 
	 * @param time: The time that the activity occured.
	 */
	public void setDate(Date time){ date = time;}
	
	/**
	 * 
	 * @param msg: A string describing the activity.
	 */
	public void setAction(String msg){ action = msg;}
	
	/**
	 * 
	 * @return A string that describes the activity.
	 */
	public String getAction(){ return action;}
	
	/**
	 * 
	 * @return The time that the activity occurred.
	 */
	public Date getDate(){ return date;}
	
	/**
	 * 
	 * @return The tutor that performed the activity.
	 */
	public Subject getActor(){ return actor;}

}
