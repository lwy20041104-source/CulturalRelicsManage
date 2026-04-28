package com.example.exception;

/**
 * 数据验证异常
 * 用于处理参数校验失败的情况
 */
public class ValidationException extends RuntimeException {
    
    private String field;
    
    public ValidationException(String message) {
        super(message);
    }
    
    public ValidationException(String field, String message) {
        super(message);
        this.field = field;
    }
    
    public ValidationException(String message, Throwable cause) {
        super(message, cause);
    }
    
    public String getField() {
        return field;
    }
}
