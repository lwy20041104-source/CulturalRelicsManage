package com.example.service;

import com.example.common.PageResult;
import com.example.entity.Museum;
import java.util.List;

public interface MuseumService {
    PageResult<Museum> pageMuseums(Integer pageNum, Integer pageSize, String museumName, String city, Integer status);
    List<Museum> listAllActive();
    Museum getById(Long id);
    Museum getByCode(String museumCode);
    Museum getByName(String museumName);
    boolean save(Museum museum);
    boolean updateById(Museum museum);
    boolean removeById(Long id);
}
