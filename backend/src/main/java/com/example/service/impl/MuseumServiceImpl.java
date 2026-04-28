package com.example.service.impl;

import com.example.common.CacheConstants;
import com.example.common.PageResult;
import com.example.entity.Museum;
import com.example.mapper.MuseumMapper;
import com.example.service.MuseumService;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class MuseumServiceImpl implements MuseumService {
    
    private final MuseumMapper museumMapper;
    
    public MuseumServiceImpl(MuseumMapper museumMapper) {
        this.museumMapper = museumMapper;
    }
    
    @Override
    public PageResult<Museum> pageMuseums(Integer pageNum, Integer pageSize, String museumName, String city, Integer status) {
        int current = pageNum == null || pageNum < 1 ? 1 : pageNum;
        int size = pageSize == null || pageSize < 1 ? 10 : pageSize;
        
        List<Museum> list = museumMapper.selectByPage(museumName, city, status);
        long total = list.size();
        
        // 手动分页
        int fromIndex = (current - 1) * size;
        int toIndex = Math.min(fromIndex + size, list.size());
        
        List<Museum> records = fromIndex < list.size() ? list.subList(fromIndex, toIndex) : new java.util.ArrayList<>();
        
        return new PageResult<>(records, total, current, size);
    }
    
    @Override
    @Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'list:active'")
    public List<Museum> listAllActive() {
        return museumMapper.selectAllActive();
    }
    
    @Override
    @Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'detail:' + #id")
    public Museum getById(Long id) {
        return museumMapper.selectById(id);
    }
    
    @Override
    @Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'code:' + #museumCode")
    public Museum getByCode(String museumCode) {
        return museumMapper.selectByCode(museumCode);
    }
    
    @Override
    @Cacheable(value = CacheConstants.MUSEUM_CACHE, key = "'name:' + #museumName")
    public Museum getByName(String museumName) {
        return museumMapper.selectByName(museumName);
    }
    
    @Override
    @CacheEvict(value = CacheConstants.MUSEUM_CACHE, allEntries = true)
    public boolean save(Museum museum) {
        return museumMapper.insert(museum) > 0;
    }
    
    @Override
    @CacheEvict(value = CacheConstants.MUSEUM_CACHE, allEntries = true)
    public boolean updateById(Museum museum) {
        return museumMapper.update(museum) > 0;
    }
    
    @Override
    @CacheEvict(value = CacheConstants.MUSEUM_CACHE, allEntries = true)
    public boolean removeById(Long id) {
        return museumMapper.deleteById(id) > 0;
    }
}
