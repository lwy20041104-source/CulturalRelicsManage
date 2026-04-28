package com.example.util;

import com.example.entity.CulturalRelic;
import com.itextpdf.html2pdf.ConverterProperties;
import com.itextpdf.html2pdf.HtmlConverter;
import com.itextpdf.kernel.font.PdfFont;
import com.itextpdf.kernel.font.PdfFontFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Cell;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import com.itextpdf.layout.properties.TextAlignment;
import com.itextpdf.layout.properties.UnitValue;
import lombok.extern.slf4j.Slf4j;
import org.apache.poi.xwpf.usermodel.*;

import java.io.ByteArrayOutputStream;
import java.io.OutputStream;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * 导出工具类
 */
@Slf4j
public class ExportUtils {

    /**
     * 导出文物数据为PDF
     */
    public static void exportRelicsToPdf(List<CulturalRelic> relics, OutputStream outputStream) throws Exception {
        PdfWriter writer = new PdfWriter(outputStream);
        PdfDocument pdfDoc = new PdfDocument(writer);
        Document document = new Document(pdfDoc);

        try {
            // 设置中文字体
            PdfFont font = PdfFontFactory.createFont("STSong-Light", "UniGB-UCS2-H");
            document.setFont(font);

            // 添加标题
            Paragraph title = new Paragraph("文物数据导出报表")
                    .setFontSize(18)
                    .setBold()
                    .setTextAlignment(TextAlignment.CENTER);
            document.add(title);

            // 添加导出时间
            String exportTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            Paragraph time = new Paragraph("导出时间：" + exportTime)
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.RIGHT);
            document.add(time);

            // 添加空行
            document.add(new Paragraph("\n"));

            // 创建表格
            float[] columnWidths = {1, 2, 1.5f, 1.5f, 1.5f, 1, 1.5f, 1, 1.5f, 3};
            Table table = new Table(UnitValue.createPercentArray(columnWidths));
            table.setWidth(UnitValue.createPercentValue(100));

            // 添加表头
            String[] headers = {"编号", "名称", "年代", "材质", "分类", "状态", "尺寸", "重量(kg)", "来源", "描述"};
            for (String header : headers) {
                Cell cell = new Cell().add(new Paragraph(header).setFontSize(10).setBold());
                cell.setTextAlignment(TextAlignment.CENTER);
                table.addHeaderCell(cell);
            }

            // 添加数据行
            for (CulturalRelic relic : relics) {
                table.addCell(new Cell().add(new Paragraph(relic.getRelicCode() != null ? relic.getRelicCode() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getRelicName() != null ? relic.getRelicName() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getEra() != null ? relic.getEra() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getMaterial() != null ? relic.getMaterial() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getCategoryName() != null ? relic.getCategoryName() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getStatus() != null ? relic.getStatus() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getDimensions() != null ? relic.getDimensions() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getWeight() != null ? String.valueOf(relic.getWeight()) : "0").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getOrigin() != null ? relic.getOrigin() : "").setFontSize(9)));
                table.addCell(new Cell().add(new Paragraph(relic.getDescription() != null ? relic.getDescription() : "").setFontSize(9)));
            }

            document.add(table);

            // 添加页脚
            Paragraph footer = new Paragraph("共 " + relics.size() + " 条记录")
                    .setFontSize(10)
                    .setTextAlignment(TextAlignment.RIGHT);
            document.add(footer);

        } catch (Exception e) {
            log.error("生成PDF失败", e);
            throw e;
        } finally {
            document.close();
        }

        log.info("PDF导出成功：count={}", relics.size());
    }

    /**
     * 导出文物数据为Word
     */
    public static void exportRelicsToWord(List<CulturalRelic> relics, OutputStream outputStream) throws Exception {
        XWPFDocument document = new XWPFDocument();

        try {
            // 添加标题
            XWPFParagraph titleParagraph = document.createParagraph();
            titleParagraph.setAlignment(ParagraphAlignment.CENTER);
            XWPFRun titleRun = titleParagraph.createRun();
            titleRun.setText("文物数据导出报表");
            titleRun.setBold(true);
            titleRun.setFontSize(18);
            titleRun.setFontFamily("宋体");

            // 添加导出时间
            XWPFParagraph timeParagraph = document.createParagraph();
            timeParagraph.setAlignment(ParagraphAlignment.RIGHT);
            XWPFRun timeRun = timeParagraph.createRun();
            String exportTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            timeRun.setText("导出时间：" + exportTime);
            timeRun.setFontSize(10);
            timeRun.setFontFamily("宋体");

            // 添加空行
            document.createParagraph();

            // 创建表格
            XWPFTable table = document.createTable(relics.size() + 1, 10);
            table.setWidth("100%");

            // 设置表头
            XWPFTableRow headerRow = table.getRow(0);
            String[] headers = {"编号", "名称", "年代", "材质", "分类", "状态", "尺寸", "重量(kg)", "来源", "描述"};
            for (int i = 0; i < headers.length; i++) {
                XWPFTableCell cell = headerRow.getCell(i);
                cell.setColor("CCCCCC");
                XWPFParagraph paragraph = cell.getParagraphs().get(0);
                paragraph.setAlignment(ParagraphAlignment.CENTER);
                XWPFRun run = paragraph.createRun();
                run.setText(headers[i]);
                run.setBold(true);
                run.setFontFamily("宋体");
                run.setFontSize(10);
            }

            // 填充数据
            for (int i = 0; i < relics.size(); i++) {
                CulturalRelic relic = relics.get(i);
                XWPFTableRow row = table.getRow(i + 1);

                setCellText(row.getCell(0), relic.getRelicCode() != null ? relic.getRelicCode() : "");
                setCellText(row.getCell(1), relic.getRelicName() != null ? relic.getRelicName() : "");
                setCellText(row.getCell(2), relic.getEra() != null ? relic.getEra() : "");
                setCellText(row.getCell(3), relic.getMaterial() != null ? relic.getMaterial() : "");
                setCellText(row.getCell(4), relic.getCategoryName() != null ? relic.getCategoryName() : "");
                setCellText(row.getCell(5), relic.getStatus() != null ? relic.getStatus() : "");
                setCellText(row.getCell(6), relic.getDimensions() != null ? relic.getDimensions() : "");
                setCellText(row.getCell(7), relic.getWeight() != null ? String.valueOf(relic.getWeight()) : "0");
                setCellText(row.getCell(8), relic.getOrigin() != null ? relic.getOrigin() : "");
                setCellText(row.getCell(9), relic.getDescription() != null ? relic.getDescription() : "");
            }

            // 添加页脚
            XWPFParagraph footerParagraph = document.createParagraph();
            footerParagraph.setAlignment(ParagraphAlignment.RIGHT);
            XWPFRun footerRun = footerParagraph.createRun();
            footerRun.setText("共 " + relics.size() + " 条记录");
            footerRun.setFontSize(10);
            footerRun.setFontFamily("宋体");

            // 写入输出流
            document.write(outputStream);

        } catch (Exception e) {
            log.error("生成Word失败", e);
            throw e;
        } finally {
            document.close();
        }

        log.info("Word导出成功：count={}", relics.size());
    }

    /**
     * 设置单元格文本
     */
    private static void setCellText(XWPFTableCell cell, String text) {
        XWPFParagraph paragraph = cell.getParagraphs().get(0);
        XWPFRun run = paragraph.createRun();
        run.setText(text);
        run.setFontFamily("宋体");
        run.setFontSize(9);
    }
}
