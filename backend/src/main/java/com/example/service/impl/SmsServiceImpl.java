package com.example.service.impl;

import com.aliyun.dysmsapi20170525.Client;
import com.aliyun.dysmsapi20170525.models.SendSmsRequest;
import com.aliyun.dysmsapi20170525.models.SendSmsResponse;
import com.aliyun.teaopenapi.models.Config;
import com.example.service.SmsService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

/**
 * 短信服务实现类（阿里云短信）
 */
@Slf4j
@Service
public class SmsServiceImpl implements SmsService {
    
    @Value("${aliyun.sms.access-key-id:}")
    private String accessKeyId;
    
    @Value("${aliyun.sms.access-key-secret:}")
    private String accessKeySecret;
    
    @Value("${aliyun.sms.sign-name:}")
    private String signName;
    
    @Value("${aliyun.sms.template-code:}")
    private String templateCode;
    
    @Value("${aliyun.sms.enabled:false}")
    private boolean smsEnabled;
    
    @Override
    public boolean sendVerificationCode(String phone, String code, int expireMinutes) {
        if (!smsEnabled || accessKeyId == null || accessKeyId.isEmpty()) {
            log.warn("短信服务未启用，模拟发送验证码到：{}，验证码：{}", phone, code);
            return true;
        }
        
        try {
            // 创建阿里云短信客户端
            Config config = new Config()
                    .setAccessKeyId(accessKeyId)
                    .setAccessKeySecret(accessKeySecret)
                    .setEndpoint("dysmsapi.aliyuncs.com");
            
            Client client = new Client(config);
            
            // 构建短信请求
            SendSmsRequest request = new SendSmsRequest()
                    .setPhoneNumbers(phone)
                    .setSignName(signName)
                    .setTemplateCode(templateCode)
                    .setTemplateParam("{\"code\":\"" + code + "\",\"expire\":\"" + expireMinutes + "\"}");
            
            // 发送短信
            SendSmsResponse response = client.sendSms(request);
            
            if ("OK".equals(response.getBody().getCode())) {
                log.info("验证码短信发送成功：{}，BizId：{}", phone, response.getBody().getBizId());
                return true;
            } else {
                log.error("验证码短信发送失败：{}，错误码：{}，错误信息：{}", 
                        phone, response.getBody().getCode(), response.getBody().getMessage());
                return false;
            }
        } catch (Exception e) {
            log.error("验证码短信发送异常：{}", phone, e);
            return false;
        }
    }
}
