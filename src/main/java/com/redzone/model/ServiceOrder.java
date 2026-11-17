package com.redzone.model;

import java.math.BigDecimal;

public class ServiceOrder {
    private int orderId;
    private String machineCode;
    private String itemName;
    private int quantity;
    private String promoCode;
    private BigDecimal finalAmount;
    private String status;

    public ServiceOrder() {}

    public ServiceOrder(int orderId, String machineCode, String itemName, int quantity, String promoCode, BigDecimal finalAmount, String status) {
        this.orderId = orderId;
        this.machineCode = machineCode;
        this.itemName = itemName;
        this.quantity = quantity;
        this.promoCode = promoCode;
        this.finalAmount = finalAmount;
        this.status = status;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getMachineCode() { return machineCode; }
    public void setMachineCode(String machineCode) { this.machineCode = machineCode; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public BigDecimal getFinalAmount() { return finalAmount; }
    public void setFinalAmount(BigDecimal finalAmount) { this.finalAmount = finalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}
