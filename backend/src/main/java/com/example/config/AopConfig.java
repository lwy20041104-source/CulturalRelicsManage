package com.example.config;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;

@Configuration
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class AopConfig {
    
    private static final Logger logger = LoggerFactory.getLogger(AopConfig.class);
    
    @Bean
    public CommandLineRunner aopChecker(ApplicationContext context) {
        return args -> {
            logger.info("=== AOP Configuration Check ===");
            logger.info("AspectJ Auto Proxy is enabled");
            
            // 检查切面 Bean 是否存在
            String[] aspectBeans = context.getBeanNamesForType(org.aspectj.lang.annotation.Aspect.class);
            logger.info("Found {} aspect beans", aspectBeans.length);
            for (String beanName : aspectBeans) {
                logger.info("  - Aspect bean: {}", beanName);
            }
            
            // 检查 OperationLogAspect 是否存在
            if (context.containsBean("operationLogAspect")) {
                logger.info("OperationLogAspect bean is registered");
            } else {
                logger.warn("OperationLogAspect bean is NOT registered!");
            }
            
            logger.info("=== AOP Configuration Check Complete ===");
        };
    }
}
