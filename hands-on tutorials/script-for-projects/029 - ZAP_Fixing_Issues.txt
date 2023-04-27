############## Add spring-boot-starter-security dependency in pom.xml ############## 
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-security</artifactId>
</dependency>
############## Add spring-boot-starter-security dependency in pom.xml ############## 



############## Create a new class - src/main/java/com/devsecops/WebSecurityConfig.java ############## 
package com.devsecops;

import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;

@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http.csrf().disable();

    }
}
############## Create a new class - /src/main/java/com/devsecops/WebSecurityConfig.java ############## 



Modify the CVSS value as shown in video 