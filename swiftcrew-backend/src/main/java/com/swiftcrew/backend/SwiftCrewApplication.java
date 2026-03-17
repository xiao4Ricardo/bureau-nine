package com.swiftcrew.backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class SwiftCrewApplication {

    public static void main(String[] args) {
        SpringApplication.run(SwiftCrewApplication.class, args);
    }
}
