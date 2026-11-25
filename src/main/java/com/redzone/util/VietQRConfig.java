package com.redzone.util;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class VietQRConfig {
    public static final String BANK_ID = "ACB";
    public static final String BANK_NAME = "Ngân hàng TMCP Á Châu (ACB)";
    public static final String ACCOUNT_NO = "40831547";
    public static final String ACCOUNT_NAME = "NGUYEN TUAN KIET";
    public static final String TEMPLATE = "compact2";

    public static String buildQrUrl(long amount, String addInfo) {
        String encodedInfo = URLEncoder.encode(addInfo != null ? addInfo : "REDZONE", StandardCharsets.UTF_8)
                .replace("+", "%20");
        String encodedName = URLEncoder.encode(ACCOUNT_NAME, StandardCharsets.UTF_8)
                .replace("+", "%20");
        return "https://img.vietqr.io/image/" + BANK_ID + "-" + ACCOUNT_NO + "-" + TEMPLATE + ".png"
                + "?amount=" + Math.max(0, amount)
                + "&addInfo=" + encodedInfo
                + "&accountName=" + encodedName;
    }
}