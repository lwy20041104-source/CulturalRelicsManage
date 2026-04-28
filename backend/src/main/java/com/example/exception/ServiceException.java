package com.example.exception;

/**
 * 服务异常
 * 用于处理外部服务调用失败的情况（如邮件、短信服务）
 */
public class ServiceException extends RuntimeException {
    
    private String serviceName;
    
    public ServiceException(String serviceName, String message) {
        super(String.format("%s服务异常：%s", serviceName, message));
        this.serviceName = serviceName;
    }
    
    public ServiceException(String serviceName, String message, Throwable cause) {
        super(String.format("%s服务异常：%s", serviceName, message), cause);
        this.serviceName = serviceName;
    }
    
    public String getServiceName() {
        return serviceName;
    }
}
