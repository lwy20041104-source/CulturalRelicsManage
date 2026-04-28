package com.example.mapper;

import com.example.entity.UserMuseum;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface UserMuseumMapper {
    
    @Select("SELECT * FROM user_museum WHERE user_id = #{userId}")
    List<UserMuseum> selectByUserId(Long userId);
    
    @Select("SELECT * FROM user_museum WHERE user_id = #{userId} AND is_primary = 1 LIMIT 1")
    UserMuseum selectPrimaryByUserId(Long userId);
    
    @Select("SELECT um.*, m.museum_name as museumName FROM user_museum um " +
            "LEFT JOIN museum m ON um.museum_id = m.id " +
            "WHERE um.user_id = #{userId} AND um.is_primary = 1 LIMIT 1")
    @Results({
        @Result(property = "id", column = "id"),
        @Result(property = "userId", column = "user_id"),
        @Result(property = "museumId", column = "museum_id"),
        @Result(property = "isPrimary", column = "is_primary"),
        @Result(property = "createTime", column = "create_time"),
        @Result(property = "updateTime", column = "update_time"),
        @Result(property = "museumName", column = "museumName")
    })
    UserMuseum selectPrimaryWithMuseumNameByUserId(Long userId);
    
    @Select("SELECT * FROM user_museum WHERE museum_id = #{museumId}")
    List<UserMuseum> selectByMuseumId(Long museumId);
    
    @Insert("INSERT INTO user_museum (user_id, museum_id, is_primary) " +
            "VALUES (#{userId}, #{museumId}, #{isPrimary})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(UserMuseum userMuseum);
    
    @Update("UPDATE user_museum SET museum_id = #{museumId}, is_primary = #{isPrimary} " +
            "WHERE id = #{id}")
    int update(UserMuseum userMuseum);
    
    @Delete("DELETE FROM user_museum WHERE user_id = #{userId}")
    int deleteByUserId(Long userId);
    
    @Delete("DELETE FROM user_museum WHERE id = #{id}")
    int deleteById(Long id);
    
    @Select("SELECT COUNT(*) FROM user_museum WHERE user_id = #{userId} AND museum_id = #{museumId}")
    int countByUserIdAndMuseumId(@Param("userId") Long userId, @Param("museumId") Long museumId);
}
