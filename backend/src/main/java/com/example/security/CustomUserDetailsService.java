package com.example.security;

import com.example.entity.SysRole;
import com.example.entity.SysUser;
import com.example.mapper.SysRoleMapper;
import com.example.mapper.SysUserMapper;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final SysUserMapper sysUserMapper;
    private final SysRoleMapper sysRoleMapper;

    public CustomUserDetailsService(SysUserMapper sysUserMapper, SysRoleMapper sysRoleMapper) {
        this.sysUserMapper = sysUserMapper;
        this.sysRoleMapper = sysRoleMapper;
    }

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            throw new UsernameNotFoundException("用户不存在");
        }

        String roleCode = "ROLE_USER";
        if (user.getRoleId() != null) {
            SysRole role = sysRoleMapper.selectById(user.getRoleId());
            if (role != null && role.getRoleCode() != null) {
                roleCode = "ROLE_" + role.getRoleCode();
            }
        }
        List<GrantedAuthority> authorities = Collections.singletonList(new SimpleGrantedAuthority(roleCode));

        return new User(user.getUsername(), user.getPassword(), user.getStatus() != null && user.getStatus() == 1,
                true, true, true, authorities);
    }
}
