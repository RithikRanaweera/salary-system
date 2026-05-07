package com.techsalary.identityservice.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Entity
@Table(name = "users", schema = "identity")
@Data
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true, nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;   // will be stored HASHED, never plain text

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();
}