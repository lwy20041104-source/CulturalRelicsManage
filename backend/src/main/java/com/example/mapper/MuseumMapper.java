package com.example.mapper;

import com.example.entity.Museum;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface MuseumMapper {
    
    @Select("<script>" +
            "SELECT * FROM museum WHERE 1=1 " +
            "<if test='museumName != null and museumName != \"\"'> AND museum_name LIKE CONCAT('%', #{museumName}, '%') </if>" +
            "<if test='city != null and city != \"\"'> AND city = #{city} </if>" +
            "<if test='status != null'> AND status = #{status} </if>" +
            "ORDER BY id ASC " +
            "</script>")
    List<Museum> selectByPage(@Param("museumName") String museumName, 
                               @Param("city") String city, 
                               @Param("status") Integer status);
    
    @Select("SELECT * FROM museum WHERE status = 1 ORDER BY museum_code")
    @Results({
        @Result(property = "museumCode", column = "museum_code"),
        @Result(property = "museumName", column = "museum_name"),
        @Result(property = "museumType", column = "museum_type"),
        @Result(property = "contactPerson", column = "contact_person"),
        @Result(property = "contactPhone", column = "contact_phone"),
        @Result(property = "contactEmail", column = "contact_email"),
        @Result(property = "createTime", column = "create_time"),
        @Result(property = "updateTime", column = "update_time")
    })
    List<Museum> selectAllActive(); // 查询所有有合作的博物馆
    
    @Select("SELECT * FROM museum WHERE id = #{id}")
    Museum selectById(Long id);
    
    @Select("SELECT * FROM museum WHERE museum_code = #{museumCode}")
    Museum selectByCode(String museumCode);
    
    @Select("SELECT * FROM museum WHERE museum_name = #{museumName}")
    Museum selectByName(String museumName);
    
    @Insert("INSERT INTO museum (museum_code, museum_name, museum_type, province, city, address, " +
            "contact_person, contact_phone, contact_email, description, status) " +
            "VALUES (#{museumCode}, #{museumName}, #{museumType}, #{province}, #{city}, #{address}, " +
            "#{contactPerson}, #{contactPhone}, #{contactEmail}, #{description}, #{status})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Museum museum);
    
    @Update("UPDATE museum SET museum_name = #{museumName}, museum_type = #{museumType}, " +
            "province = #{province}, city = #{city}, address = #{address}, " +
            "contact_person = #{contactPerson}, contact_phone = #{contactPhone}, " +
            "contact_email = #{contactEmail}, description = #{description}, status = #{status} " +
            "WHERE id = #{id}")
    int update(Museum museum);
    
    @Delete("DELETE FROM museum WHERE id = #{id}")
    int deleteById(Long id);
}
