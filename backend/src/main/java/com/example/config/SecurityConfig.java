package com.example.config;

import com.example.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.web.firewall.HttpFirewall;
import org.springframework.security.web.firewall.StrictHttpFirewall;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    /**
     * 配置 HTTP 防火墙，允许双斜杠（用于图片路径）
     */
    @Bean
    public HttpFirewall allowUrlEncodedSlashHttpFirewall() {
        StrictHttpFirewall firewall = new StrictHttpFirewall();
        firewall.setAllowUrlEncodedSlash(true);
        firewall.setAllowSemicolon(true);
        firewall.setAllowBackSlash(true);
        // 允许双斜杠（虽然我们已经修复了路径问题，但这是额外的保护）
        firewall.setAllowUrlEncodedDoubleSlash(true);
        return firewall;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors()
                .and()
                .csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .antMatchers("/auth/**", "/doc.html", "/webjars/**", "/v3/api-docs/**", "/swagger-resources/**").permitAll()
                .antMatchers("/proxy/**").permitAll()
                .antMatchers("/uploads/**").permitAll()  // 允许访问上传的图片（/api/uploads/**）
                .antMatchers(HttpMethod.GET, "/museums/active").permitAll()
                .antMatchers(HttpMethod.GET, "/relics").permitAll()  // 允许公开访问文物列表（不带ID）
                .antMatchers(HttpMethod.GET, "/relics/{id}").permitAll()  // 允许公开访问单个文物详情
                .antMatchers(HttpMethod.GET, "/relics/{id}/qrcode").permitAll()  // 允许公开访问文物二维码
                .antMatchers(HttpMethod.POST, "/ai/relics/**").authenticated()
                .antMatchers(HttpMethod.GET, "/ai-chat/sessions/all").hasRole("ADMIN")
                .antMatchers(HttpMethod.GET, "/ai-chat/**").authenticated()
                .antMatchers(HttpMethod.POST, "/ai-chat/**").authenticated()
                .antMatchers(HttpMethod.PUT, "/ai-chat/**").authenticated()
                .antMatchers(HttpMethod.DELETE, "/ai-chat/**").authenticated()
                .antMatchers("/reports/**").authenticated()
                // LOANER角色可以访问的接口
                .antMatchers(HttpMethod.GET, "/statistics/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER", "LOANER")
                .antMatchers(HttpMethod.GET, "/relics/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER", "LOANER")
                .antMatchers(HttpMethod.GET, "/categories/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER", "LOANER")
                .antMatchers(HttpMethod.POST, "/loans/**").hasAnyRole("ADMIN", "APPROVER", "LOANER")
                .antMatchers(HttpMethod.GET, "/loans/**").hasAnyRole("ADMIN", "APPROVER", "LOANER")
                .antMatchers(HttpMethod.PUT, "/loans/*/user-return").hasAnyRole("ADMIN", "APPROVER", "LOANER")
                // 档案管理权限
                .antMatchers(HttpMethod.GET, "/archives/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER")
                .antMatchers(HttpMethod.POST, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
                .antMatchers(HttpMethod.PUT, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
                .antMatchers(HttpMethod.DELETE, "/archives/**").hasAnyRole("ADMIN", "CURATOR")
                // 个人信息接口 - 所有已登录用户都可以访问
                .antMatchers(HttpMethod.GET, "/users/profile").authenticated()
                .antMatchers(HttpMethod.PUT, "/users/profile").authenticated()
                // 博物馆管理 - 仅管理员可以管理
                .antMatchers("/museums/**").hasRole("ADMIN")
                // 管理员和保管员的写权限
                .antMatchers("/users/**").hasRole("ADMIN")
                .antMatchers("/relics/**", "/categories/**").hasAnyRole("ADMIN", "CURATOR")
                .antMatchers("/images/**").hasAnyRole("ADMIN", "CURATOR")
                .antMatchers("/relic-images/**").hasAnyRole("ADMIN", "CURATOR")
                .antMatchers("/loans/**").hasAnyRole("ADMIN", "APPROVER")
                .antMatchers("/maintenance/**").hasAnyRole("ADMIN", "CURATOR", "APPROVER")
                .anyRequest().authenticated()
                .and()
                .formLogin().disable()
                .httpBasic().disable();

        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Arrays.asList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }
}
