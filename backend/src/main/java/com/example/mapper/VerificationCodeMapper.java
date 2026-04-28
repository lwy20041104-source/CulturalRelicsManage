package com.example.mapper;

import com.example.entity.VerificationCode;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 验证码Mapper
 */
@Mapper
public interface VerificationCodeMapper {
    
    /**
     * 插入验证码
     */
    int insert(VerificationCode verificationCode);
    
    /**
     * 根据用户名和验证码查询（未使用且未过期）
     */
    VerificationCode selectValidCode(@Param("username") String username, 
                                     @Param("code") String code,
                                     @Param("purpose") String purpose);
    
    /**
     * 标记验证码为已使用
     */
    int markAsUsed(@Param("id") Long id);
    
    /**
     * 删除用户的旧验证码
     */
    int deleteByUsername(@Param("username") String username, 
                        @Param("purpose") String purpose);
}
