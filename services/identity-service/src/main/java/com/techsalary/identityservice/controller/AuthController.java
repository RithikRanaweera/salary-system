package com.techsalary.identityservice.controller;

import com.techsalary.identityservice.dto.AuthRequest;
import com.techsalary.identityservice.dto.AuthResponse;
import com.techsalary.identityservice.service.AuthService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> signup(@Valid @RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.signup(request));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody AuthRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    // Called by BFF to check if a token is valid
    @GetMapping("/validate")
    public ResponseEntity<Map<String, Object>> validate(
            @RequestHeader("Authorization") String authHeader) {
        String token = authHeader.replace("Bearer ", "");
        boolean valid = authService.validateToken(token);
        if (!valid) {
            return ResponseEntity.status(401).body(Map.of("valid", false));
        }
        Long userId = authService.getUserIdFromToken(token);
        return ResponseEntity.ok(Map.of("valid", true, "userId", userId));
    }

    // Health check for Kubernetes liveness probe
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }
}