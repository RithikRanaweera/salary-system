package com.techsalary.identityservice.service;

import com.techsalary.identityservice.dto.AuthRequest;
import com.techsalary.identityservice.dto.AuthResponse;
import com.techsalary.identityservice.model.User;
import com.techsalary.identityservice.repository.UserRepository;
import com.techsalary.identityservice.util.JwtUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;

    public AuthResponse signup(AuthRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new RuntimeException("Email already registered");
        }

        User user = new User();
        user.setEmail(request.getEmail());
        // HASHING the password before saving — never store plain text!
        user.setPassword(passwordEncoder.encode(request.getPassword()));

        User saved = userRepository.save(user);
        String token = jwtUtil.generateToken(saved.getId(), saved.getEmail());

        return new AuthResponse(token, saved.getId(), "Signup successful");
    }

    public AuthResponse login(AuthRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new RuntimeException("Invalid credentials"));

        // Compare raw password against the stored hash
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("Invalid credentials");
        }

        String token = jwtUtil.generateToken(user.getId(), user.getEmail());
        return new AuthResponse(token, user.getId(), "Login successful");
    }

    public boolean validateToken(String token) {
        return jwtUtil.isTokenValid(token);
    }

    public Long getUserIdFromToken(String token) {
        return jwtUtil.validateTokenAndGetUserId(token);
    }
}