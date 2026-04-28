package com.example.annotation;

import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OperationLog {
    String operationType();
    String operationModule();
    String operationContent() default "";  // 操作内容描述，如果不填则使用方法名
}
