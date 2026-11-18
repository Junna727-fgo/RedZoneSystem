package com.redzone.model;

public class ThietBiPhanCung {
    private int maThietBi;
    private int maMay;
    private String tenThietBi;
    private String soSerial;
    private String tinhTrang; // VD: "Tot", "CanBaoTri", "HuHong"
    private String moTaSuCo;

    public ThietBiPhanCung() {}

    public ThietBiPhanCung(int maThietBi, int maMay, String tenThietBi, String soSerial, String tinhTrang, String moTaSuCo) {
        this.maThietBi = maThietBi;
        this.maMay = maMay;
        this.tenThietBi = tenThietBi;
        this.soSerial = soSerial;
        this.tinhTrang = tinhTrang;
        this.moTaSuCo = moTaSuCo;
    }

    // Getters & Setters
    public int getMaThietBi() { return maThietBi; }
    public void setMaThietBi(int maThietBi) { this.maThietBi = maThietBi; }
    public int getMaMay() { return maMay; }
    public void setMaMay(int maMay) { this.maMay = maMay; }
    public String getTenThietBi() { return tenThietBi; }
    public void setTenThietBi(String tenThietBi) { this.tenThietBi = tenThietBi; }
    public String getSoSerial() { return soSerial; }
    public void setSoSerial(String soSerial) { this.soSerial = soSerial; }
    public String getTinhTrang() { return tinhTrang; }
    public void setTinhTrang(String tinhTrang) { this.tinhTrang = tinhTrang; }
    public String getMoTaSuCo() { return moTaSuCo; }
    public void setMoTaSuCo(String moTaSuCo) { this.moTaSuCo = moTaSuCo; }
}