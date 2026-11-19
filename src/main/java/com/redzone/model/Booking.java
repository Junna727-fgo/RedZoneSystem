package com.redzone.model;

public class Booking {
    private int bookingId;
    private int userId;
    private String machineCode;
    private String roomName;
    private String timeSlot;
    private int hours;
    private String status; // PENDING, APPROVED, REJECTED

    public Booking() {}

    public Booking(int bookingId, int userId, String machineCode, String roomName, String timeSlot, int hours, String status) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.machineCode = machineCode;
        this.roomName = roomName;
        this.timeSlot = timeSlot;
        this.hours = hours;
        this.status = status;
    }

    public int getBookingId() { return bookingId; }
    public void setBookingId(int bookingId) { this.bookingId = bookingId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getMachineCode() { return machineCode; }
    public void setMachineCode(String machineCode) { this.machineCode = machineCode; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getTimeSlot() { return timeSlot; }
    public void setTimeSlot(String timeSlot) { this.timeSlot = timeSlot; }

    public int getHours() { return hours; }
    public void setHours(int hours) { this.hours = hours; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
