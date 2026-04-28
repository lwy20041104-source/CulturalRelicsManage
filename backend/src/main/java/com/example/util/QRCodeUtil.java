package com.example.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.qrcode.decoder.ErrorCorrectionLevel;
import lombok.extern.slf4j.Slf4j;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * 二维码工具类
 * 用于生成文物二维码标签
 */
@Slf4j
public class QRCodeUtil {

    /**
     * 生成二维码图片（Base64格式）
     *
     * @param content 二维码内容（URL）
     * @param width   二维码宽度
     * @param height  二维码高度
     * @return Base64编码的图片字符串
     */
    public static String generateQRCodeBase64(String content, int width, int height) {
        try {
            byte[] imageBytes = generateQRCodeBytes(content, width, height);
            return "data:image/png;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);
        } catch (Exception e) {
            log.error("生成二维码失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 生成二维码图片字节数组
     *
     * @param content 二维码内容
     * @param width   宽度
     * @param height  高度
     * @return 图片字节数组
     */
    public static byte[] generateQRCodeBytes(String content, int width, int height) throws WriterException, IOException {
        // 设置二维码参数
        Map<EncodeHintType, Object> hints = new HashMap<>();
        hints.put(EncodeHintType.CHARACTER_SET, "UTF-8");
        hints.put(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H); // 高容错率
        hints.put(EncodeHintType.MARGIN, 1); // 边距

        // 生成二维码矩阵
        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(content, BarcodeFormat.QR_CODE, width, height, hints);

        // 转换为图片
        BufferedImage image = MatrixToImageWriter.toBufferedImage(bitMatrix);

        // 转换为字节数组
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, "PNG", baos);
        return baos.toByteArray();
    }

    /**
     * 生成带文字说明的二维码标签
     *
     * @param content    二维码内容
     * @param relicCode  文物编号
     * @param relicName  文物名称
     * @param qrSize     二维码大小
     * @return Base64编码的图片字符串
     */
    public static String generateQRCodeLabelBase64(String content, String relicCode, String relicName, int qrSize) {
        try {
            // 生成二维码
            byte[] qrCodeBytes = generateQRCodeBytes(content, qrSize, qrSize);
            BufferedImage qrImage = ImageIO.read(new java.io.ByteArrayInputStream(qrCodeBytes));

            // 计算标签尺寸
            int labelWidth = qrSize + 40; // 左右各留20px边距
            int labelHeight = qrSize + 120; // 上下留空间显示文字

            // 创建标签画布
            BufferedImage labelImage = new BufferedImage(labelWidth, labelHeight, BufferedImage.TYPE_INT_RGB);
            Graphics2D g2d = labelImage.createGraphics();

            // 设置抗锯齿
            g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            g2d.setRenderingHint(RenderingHints.KEY_TEXT_ANTIALIASING, RenderingHints.VALUE_TEXT_ANTIALIAS_ON);

            // 填充白色背景
            g2d.setColor(Color.WHITE);
            g2d.fillRect(0, 0, labelWidth, labelHeight);

            // 绘制二维码
            g2d.drawImage(qrImage, 20, 20, null);

            // 绘制文物编号
            g2d.setColor(Color.BLACK);
            g2d.setFont(new Font("Microsoft YaHei", Font.BOLD, 16));
            FontMetrics fm1 = g2d.getFontMetrics();
            int codeWidth = fm1.stringWidth(relicCode);
            g2d.drawString(relicCode, (labelWidth - codeWidth) / 2, qrSize + 45);

            // 绘制文物名称（可能需要换行）
            g2d.setFont(new Font("Microsoft YaHei", Font.PLAIN, 14));
            FontMetrics fm2 = g2d.getFontMetrics();
            
            // 如果名称太长，截断并添加省略号
            String displayName = relicName;
            int maxWidth = labelWidth - 40;
            if (fm2.stringWidth(displayName) > maxWidth) {
                while (fm2.stringWidth(displayName + "...") > maxWidth && displayName.length() > 0) {
                    displayName = displayName.substring(0, displayName.length() - 1);
                }
                displayName += "...";
            }
            
            int nameWidth = fm2.stringWidth(displayName);
            g2d.drawString(displayName, (labelWidth - nameWidth) / 2, qrSize + 70);

            // 绘制扫描提示
            g2d.setFont(new Font("Microsoft YaHei", Font.PLAIN, 12));
            g2d.setColor(new Color(128, 128, 128));
            FontMetrics fm3 = g2d.getFontMetrics();
            String tip = "扫描查看详情";
            int tipWidth = fm3.stringWidth(tip);
            g2d.drawString(tip, (labelWidth - tipWidth) / 2, qrSize + 95);

            g2d.dispose();

            // 转换为Base64
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            ImageIO.write(labelImage, "PNG", baos);
            byte[] imageBytes = baos.toByteArray();
            return "data:image/png;base64," + java.util.Base64.getEncoder().encodeToString(imageBytes);

        } catch (Exception e) {
            log.error("生成二维码标签失败: {}", e.getMessage(), e);
            return null;
        }
    }

    /**
     * 生成文物二维码URL
     *
     * @param relicId   文物ID
     * @param baseUrl   基础URL（如：http://localhost:5173）
     * @return 完整的二维码URL
     */
    public static String generateRelicQRCodeUrl(Long relicId, String baseUrl) {
        return baseUrl + "/qrcode/" + relicId;
    }
}
