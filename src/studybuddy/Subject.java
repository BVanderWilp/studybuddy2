package studybuddy;

/**
 * 
 * Subject.java
 * Interface class for observers
 * Objects use the interface to de(register) as observers
 * 
 */
public interface Subject {
    public void registerObserver(Student observer);
    public void removeObserver(Student observer);
    public void notifyObservers(String message);
}
