package com.redzone.model;

import java.math.BigDecimal;

public class Computer {
    private int machineId;
    private String machineCode;
    private String roomName;
    private String specs;
    private BigDecimal pricePerHour;
    private String status; // AVAILABLE, IN_USE, RESERVED, MAINTENANCE

    public Computer() {}

    public Computer(int machineId, String machineCode, String roomName, String specs, BigDecimal pricePerHour, String status) {
        this.machineId = machineId;
        this.machineCode = machineCode;
        this.roomName = roomName;
        this.specs = specs;
        this.pricePerHour = pricePerHour;
        this.status = status;
    }

    public int getMachineId() { return machineId; }
    public void setMachineId(int machineId) { this.machineId = machineId; }

    public String getMachineCode() { return machineCode; }
    public void setMachineCode(String machineCode) { this.machineCode = machineCode; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public String getSpecs() { return specs; }
    public void setSpecs(String specs) { this.specs = specs; }

    public BigDecimal getPricePerHour() { return pricePerHour; }
    public void setPricePerHour(BigDecimal pricePerHour) { this.pricePerHour = pricePerHour; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
