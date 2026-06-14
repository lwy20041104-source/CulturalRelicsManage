package com.example.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@Slf4j
@Configuration
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class AopConfig {
    
    @Bean
    public CommandLineRunner aopChecker(ApplicationContext context) {
        return args -> {
            log.info("=== AOP Configuration Check ===");
            log.info("AspectJ Auto Proxy is enabled");
            
            // 检查切面 Bean 是否存在
            String[] aspectBeans = context.getBeanNamesForType(org.aspectj.lang.annotation.Aspect.class);
            log.info("Found {} aspect beans", aspectBeans.length);
            for (String beanName : aspectBeans) {
                log.info("  - Aspect bean: {}", beanName);
            }
            
            // 检查 OperationLogAspect 是否存在
            if (context.containsBean("operationLogAspect")) {
                log.info("OperationLogAspect bean is registered");
            } else {
                log.warn("OperationLogAspect bean is NOT registered!");
            }
            
            log.info("=== AOP Configuration Check Complete ===");
        };
    }
}
