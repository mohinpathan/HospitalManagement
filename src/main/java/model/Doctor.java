package model;

// Replaced by com.hospital.model.Doctor — kept to avoid compilation errors
public class Doctor {
    private int id;
    private String name;
    private String specialization;

    public Doctor(int id, String name, String specialization) {
        this.id = id; this.name = name; this.specialization = specialization;
    }

    public int getId() { return id; }
    public String getName() { return name; }
    public String getSpecialization() { return specialization; }
    public void setName(String name) { this.name = name; }
    public void setSpecialization(String s) { this.specialization = s; }
}
