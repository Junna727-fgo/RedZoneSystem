package com.redzone.model;

import java.math.BigDecimal;

public class QrPaymentOrder {
    private int orderId;
    private int userId;
    private String username;
    private String fullName;
    private String machineCode;
    private String itemName;
    private int quantity;
    private String promoCode; // TOPUP, FNB, GEAR
    private BigDecimal finalAmount;
    private String status;    // PENDING, APPROVED, SERVING, COMPLETED, REJECTED
    private String createdAt;

    public QrPaymentOrder() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

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

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public String getTypeLabel() {
        if ("TOPUP".equalsIgnoreCase(promoCode)) return "Nạp giờ chơi";
        if ("GEAR".equalsIgnoreCase(promoCode)) return "Thuê Gear";
        return "Dịch vụ F&B";
    }

    public String getStatusLabel() {
        if ("PENDING".equalsIgnoreCase(status)) return "Chờ duyệt";
        if ("APPROVED".equalsIgnoreCase(status)) return "Đã cộng tiền";
        if ("SERVING".equalsIgnoreCase(status)) return "Đã duyệt - Đang phục vụ";
        if ("COMPLETED".equalsIgnoreCase(status)) return "Hoàn tất";
        if ("REJECTED".equalsIgnoreCase(status)) return "Đã từ chối";
        return status;
    }
}