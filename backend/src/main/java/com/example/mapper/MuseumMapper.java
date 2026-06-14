package com.example.mapper;

import com.example.entity.Museum;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MuseumMapper {

    List<Museum> selectByPage(@Param("museumName") String museumName,
                               @Param("city") String city,
                               @Param("status") Integer status);

    List<Museum> selectAllActive();

    Museum selectById(Long id);

    Museum selectByCode(String museumCode);

    Museum selectByName(String museumName);

    int insert(Museum museum);

    int update(Museum museum);

    int deleteById(Long id);
}
