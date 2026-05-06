package com.example.controller;

import com.example.common.PageResult;
import com.example.common.Result;
import com.example.entity.SysOperationLog;
import com.example.service.SysOperationLogService;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/operation-logs")
public class SysOperationLogController {
    
    private final SysOperationLogService logService;
    
    public SysOperationLogController(SysOperationLogService logService) {
        this.logService = logService;
    }
    
    @GetMapping("/page")
    public Result<PageResult<SysOperationLog>> getPage(
            @RequestParam(required = false) String operator,
            @RequestParam(required = false) String operationType,
            @RequestParam(required = false) String operationModule,
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize) {
        PageResult<SysOperationLog> page = logService.getPage(operator, operationType, operationModule, pageNum, pageSize);
        return Result.success(page);
    }
    
    @GetMapping("/{id}")
    public Result<SysOperationLog> getById(@PathVariable Long id) {
        SysOperationLog log = logService.getById(id);
        return Result.success(log);
    }
}
