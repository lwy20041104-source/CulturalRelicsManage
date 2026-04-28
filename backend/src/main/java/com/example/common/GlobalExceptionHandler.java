package com.example.common;

import com.example.exception.BusinessException;
import com.example.exception.ResourceNotFoundException;
import com.example.exception.ServiceException;
import com.example.exception.ValidationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

/**
 * 全局异常处理器
 * 统一处理各类异常，规范错误响应格式
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 业务异常处理
     * 用于处理可预期的业务逻辑错误
     */
    @ExceptionHandler(BusinessException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleBusinessException(BusinessException e) {
        log.warn("业务异常 [{}]: {}", e.getCode(), e.getMessage());
        return Result.error(e.getMessage());
    }

    /**
     * 参数校验异常处理
     * 用于处理数据验证失败的情况
     */
    @ExceptionHandler(ValidationException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleValidationException(ValidationException e) {
        log.warn("参数校验失败: {}", e.getMessage());
        return Result.error(e.getMessage());
    }

    /**
     * 资源未找到异常处理
     * 用于处理数据不存在的情况
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleResourceNotFoundException(ResourceNotFoundException e) {
        log.warn("资源未找到: {}", e.getMessage());
        return Result.error(e.getMessage());
    }

    /**
     * 服务异常处理
     * 用于处理外部服务调用失败的情况
     */
    @ExceptionHandler(ServiceException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleServiceException(ServiceException e) {
        log.error("外部服务调用失败 [{}]: {}", e.getServiceName(), e.getMessage(), e);
        return Result.error(e.getMessage());
    }

    /**
     * 参数校验异常处理（Spring Validation）
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleMethodArgumentNotValidException(MethodArgumentNotValidException e) {
        String errorMsg = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining("; "));
        log.warn("参数校验失败: {}", errorMsg);
        return Result.error(errorMsg);
    }

    /**
     * 参数绑定异常处理
     */
    @ExceptionHandler(BindException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleBindException(BindException e) {
        String errorMsg = e.getBindingResult().getFieldErrors().stream()
                .map(FieldError::getDefaultMessage)
                .collect(Collectors.joining("; "));
        log.warn("参数绑定失败: {}", errorMsg);
        return Result.error(errorMsg);
    }

    /**
     * 数据库唯一键冲突异常处理
     */
    @ExceptionHandler(DuplicateKeyException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleDuplicateKeyException(DuplicateKeyException e) {
        log.warn("数据库唯一键冲突: {}", e.getMessage());
        return Result.error("数据已存在，请勿重复操作");
    }

    /**
     * 非法参数异常处理（保留兼容性）
     */
    @ExceptionHandler(IllegalArgumentException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleIllegalArgumentException(IllegalArgumentException e) {
        log.warn("非法参数: {}", e.getMessage());
        return Result.error(e.getMessage());
    }

    /**
     * 非法状态异常处理
     */
    @ExceptionHandler(IllegalStateException.class)
    @ResponseStatus(HttpStatus.OK)
    public Result<String> handleIllegalStateException(IllegalStateException e) {
        log.warn("非法状态: {}", e.getMessage());
        return Result.error(e.getMessage());
    }

    /**
     * 空指针异常处理
     */
    @ExceptionHandler(NullPointerException.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<String> handleNullPointerException(NullPointerException e) {
        log.error("空指针异常", e);
        return Result.error("系统内部错误，请联系管理员");
    }

    /**
     * 通用异常处理
     * 捕获所有未被特定处理器捕获的异常
     */
    @ExceptionHandler(Exception.class)
    @ResponseStatus(HttpStatus.INTERNAL_SERVER_ERROR)
    public Result<String> handleException(Exception e) {
        log.error("系统异常: {}", e.getMessage(), e);
        return Result.error("系统异常，请稍后重试");
    }
}
