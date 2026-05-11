package com.example;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

/**
 * DeepSeek API 测试工具
 * 用于快速诊断 DeepSeek API 连接问题
 * 
 * 运行方式：
 * 1. 在 IDE 中直接运行 main 方法
 * 2. 或使用命令：mvn test -Dtest=DeepSeekApiTest
 */
public class DeepSeekApiTest {
    
    // 从 application.yml 复制你的 API Key
    private static final String API_KEY = "sk-40278446331f49a1945fda8f551fc0ca";
    private static final String API_URL = "https://api.deepseek.com/v1/chat/completions";
    
    public static void main(String[] args) {
        System.out.println("==========================================");
        System.out.println("DeepSeek API 连接测试");
        System.out.println("==========================================");
        System.out.println();
        
        // 测试1：检查配置
        System.out.println("1. 检查配置...");
        System.out.println("   API URL: " + API_URL);
        System.out.println("   API Key: " + maskApiKey(API_KEY));
        System.out.println();
        
        if (API_KEY == null || API_KEY.isEmpty() || !API_KEY.startsWith("sk-")) {
            System.err.println("   ✗ API Key 格式错误");
            System.err.println("   请在代码中设置正确的 API Key");
            return;
        }
        
        System.out.println("   ✓ 配置格式正确");
        System.out.println();
        
        // 测试2：测试网络连接
        System.out.println("2. 测试网络连接...");
        try {
            URL url = new URL(API_URL);
            HttpURLConnection testConn = (HttpURLConnection) url.openConnection();
            testConn.setRequestMethod("HEAD");
            testConn.setConnectTimeout(5000);
            testConn.connect();
            testConn.disconnect();
            System.out.println("   ✓ 网络连接正常");
        } catch (Exception e) {
            System.err.println("   ✗ 网络连接失败: " + e.getMessage());
            System.err.println("   可能原因：");
            System.err.println("   - 无法访问 api.deepseek.com");
            System.err.println("   - 需要配置代理");
            System.err.println("   - 防火墙阻止");
            return;
        }
        System.out.println();
        
        // 测试3：测试 API 调用
        System.out.println("3. 测试 API 调用...");
        try {
            String response = callDeepSeekAPI("你好");
            System.out.println("   ✓ API 调用成功");
            System.out.println();
            
            // 解析响应
            System.out.println("4. API 响应内容：");
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(response);
            
            // 美化输出
            System.out.println(mapper.writerWithDefaultPrettyPrinter().writeValueAsString(root));
            System.out.println();
            
            // 提取回复内容
            JsonNode choices = root.get("choices");
            if (choices != null && choices.isArray() && choices.size() > 0) {
                String content = choices.get(0).get("message").get("content").asText();
                System.out.println("AI 回复: " + content);
                System.out.println();
            }
            
            System.out.println("==========================================");
            System.out.println("✓ 所有测试通过！DeepSeek API 工作正常");
            System.out.println("==========================================");
            
        } catch (Exception e) {
            System.err.println("   ✗ API 调用失败");
            System.err.println();
            System.err.println("错误详情：");
            e.printStackTrace();
            System.err.println();
            
            // 提供解决方案
            System.err.println("可能的解决方案：");
            System.err.println("1. 检查 API Key 是否有效（访问 https://platform.deepseek.com/）");
            System.err.println("2. 检查账户余额是否充足");
            System.err.println("3. 检查网络连接是否正常");
            System.err.println("4. 查看完整的错误信息");
            System.err.println();
            System.err.println("详细故障排查指南：docs/DEEPSEEK_TROUBLESHOOTING.md");
        }
    }
    
    /**
     * 调用 DeepSeek API
     */
    private static String callDeepSeekAPI(String message) throws Exception {
        URL url = new URL(API_URL);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        
        try {
            // 设置请求
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "application/json");
            connection.setRequestProperty("Authorization", "Bearer " + API_KEY);
            connection.setDoOutput(true);
            connection.setConnectTimeout(10000);
            connection.setReadTimeout(30000);
            
            // 构建请求体
            String requestBody = String.format(
                "{\"model\":\"deepseek-chat\",\"messages\":[{\"role\":\"user\",\"content\":\"%s\"}],\"max_tokens\":100}",
                message
            );
            
            // 发送请求
            try (OutputStream os = connection.getOutputStream()) {
                byte[] input = requestBody.getBytes(StandardCharsets.UTF_8);
                os.write(input, 0, input.length);
            }
            
            // 读取响应
            int responseCode = connection.getResponseCode();
            System.out.println("   HTTP 状态码: " + responseCode);
            
            if (responseCode == HttpURLConnection.HTTP_OK) {
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getInputStream(), StandardCharsets.UTF_8))) {
                    StringBuilder response = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        response.append(line);
                    }
                    return response.toString();
                }
            } else {
                // 读取错误信息
                try (BufferedReader br = new BufferedReader(
                        new InputStreamReader(connection.getErrorStream(), StandardCharsets.UTF_8))) {
                    StringBuilder error = new StringBuilder();
                    String line;
                    while ((line = br.readLine()) != null) {
                        error.append(line);
                    }
                    
                    // 根据状态码提供具体建议
                    String errorMsg = error.toString();
                    switch (responseCode) {
                        case 401:
                            throw new RuntimeException("API Key 无效或已过期\n" + errorMsg);
                        case 402:
                            throw new RuntimeException("账户余额不足，请充值\n" + errorMsg);
                        case 429:
                            throw new RuntimeException("请求过于频繁，请稍后重试\n" + errorMsg);
                        default:
                            throw new RuntimeException("API 调用失败 (HTTP " + responseCode + ")\n" + errorMsg);
                    }
                }
            }
        } finally {
            connection.disconnect();
        }
    }
    
    /**
     * 隐藏 API Key 的敏感部分
     */
    private static String maskApiKey(String apiKey) {
        if (apiKey == null || apiKey.length() < 15) {
            return "***";
        }
        return apiKey.substring(0, 10) + "..." + apiKey.substring(apiKey.length() - 5);
    }
}
