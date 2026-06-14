package com.example.controller;

import com.example.annotation.OperationLog;
import com.example.common.Result;
import com.example.entity.CulturalRelicCategory;
import com.example.service.CulturalRelicCategoryService;
import com.example.service.SysOperationLogService;
import com.example.util.UserContextUtil;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/categories")
public class CulturalRelicCategoryController {

    private final CulturalRelicCategoryService categoryService;
    private final SysOperationLogService operationLogService;
    private final UserContextUtil userContextUtil;

    public CulturalRelicCategoryController(CulturalRelicCategoryService categoryService,
                                          SysOperationLogService operationLogService,
                                          UserContextUtil userContextUtil) {
        this.categoryService = categoryService;
        this.operationLogService = operationLogService;
        this.userContextUtil = userContextUtil;
    }

    @GetMapping
    public Result<List<CulturalRelicCategory>> list(@RequestParam(required = false) Long parentId) {
        return Result.success(categoryService.listByParentId(parentId));
    }

    @PostMapping
    @OperationLog(operationType = "新增", operationModule = "分类管理", operationContent = "新增文物分类")
    public Result<Boolean> save(@RequestBody CulturalRelicCategory category) {
        category.setCreateTime(LocalDateTime.now());
        category.setUpdateTime(LocalDateTime.now());
        return Result.success("新增成功", categoryService.save(category));
    }

    @PutMapping
    public Result<Boolean> update(@RequestBody CulturalRelicCategory category,
                                  HttpServletRequest request) {
        // 1. 获取修改前的数据
        CulturalRelicCategory oldCategory = categoryService.getById(category.getId());
        
        // 2. 执行更新操作
        category.setUpdateTime(LocalDateTime.now());
        boolean success = categoryService.updateById(category);
        
        // 3. 记录审计日志
        if (success && oldCategory != null) {
            try {
                CulturalRelicCategory newCategory = categoryService.getById(category.getId());
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "修改", "分类管理",
                    "CATEGORY", category.getId(), oldCategory, newCategory,
                    ipAddress, "PUT", "/categories"
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("更新成功", success);
    }

    @DeleteMapping("/{id}")
    public Result<Boolean> delete(@PathVariable Long id, HttpServletRequest request) {
        // 1. 获取删除前的数据
        CulturalRelicCategory oldCategory = categoryService.getById(id);
        
        // 2. 执行删除操作
        boolean success = categoryService.removeById(id);
        
        // 3. 记录审计日志
        if (success && oldCategory != null) {
            try {
                String realName = userContextUtil.getCurrentUserRealName();
                Long userId = userContextUtil.getCurrentUserId();
                String ipAddress = UserContextUtil.getClientIp(request);
                
                operationLogService.logDataChange(
                    userId, realName, "删除", "分类管理",
                    "CATEGORY", id, oldCategory, null,
                    ipAddress, "DELETE", "/categories/" + id
                );
            } catch (Exception e) {
                log.error("记录审计日志失败: {}", e.getMessage());
            }
        }
        
        return Result.success("删除成功", success);
    }
}
