package com.example.mapper;

import com.example.entity.UserMuseum;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMuseumMapper {

    List<UserMuseum> selectByUserId(Long userId);

    UserMuseum selectPrimaryByUserId(Long userId);

    UserMuseum selectPrimaryWithMuseumNameByUserId(Long userId);

    List<UserMuseum> selectByMuseumId(Long museumId);

    int insert(UserMuseum userMuseum);

    int update(UserMuseum userMuseum);

    int deleteByUserId(Long userId);

    int deleteById(Long id);

    int countByUserIdAndMuseumId(@Param("userId") Long userId, @Param("museumId") Long museumId);
}
