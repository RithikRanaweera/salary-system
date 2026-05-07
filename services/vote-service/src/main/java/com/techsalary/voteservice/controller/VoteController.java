package com.techsalary.voteservice.controller;

import com.techsalary.voteservice.dto.VoteRequest;
import com.techsalary.voteservice.model.Vote;
import com.techsalary.voteservice.service.VoteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/votes")
@RequiredArgsConstructor
public class VoteController {

    private final VoteService voteService;
    private final RestTemplate restTemplate;

    @Value("${services.identity-url}")
    private String identityServiceUrl;

    @PostMapping
    public ResponseEntity<?> castVote(
            @RequestHeader("Authorization") String authHeader,
            @Valid @RequestBody VoteRequest request) {

        // Step 1: Validate the token with identity service
        Long userId = validateToken(authHeader);
        if (userId == null) {
            return ResponseEntity.status(401)
                    .body(Map.of("error", "Invalid or missing token"));
        }

        // Step 2: Cast the vote
        Vote vote = voteService.castVote(request, userId);
        return ResponseEntity.ok(vote);
    }

    @GetMapping("/{submissionId}/count")
    public ResponseEntity<Map<String, Long>> getCount(
            @PathVariable UUID submissionId) {
        long count = voteService.getUpvoteCount(submissionId);
        return ResponseEntity.ok(Map.of("upvotes", count));
    }

    @GetMapping("/health")
    public ResponseEntity<String> health() {
        return ResponseEntity.ok("OK");
    }

    // Calls identity-service to validate JWT and get userId
    private Long validateToken(String authHeader) {
        try {
            String url = identityServiceUrl + "/auth/validate";
            ResponseEntity<Map> response = restTemplate.exchange(
                    url,
                    org.springframework.http.HttpMethod.GET,
                    new org.springframework.http.HttpEntity<>(
                            createHeaders(authHeader)
                    ),
                    Map.class
            );
            if (response.getBody() != null &&
                    Boolean.TRUE.equals(response.getBody().get("valid"))) {
                return Long.valueOf(
                        response.getBody().get("userId").toString()
                );
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }

    private org.springframework.http.HttpHeaders createHeaders(String authHeader) {
        org.springframework.http.HttpHeaders headers =
                new org.springframework.http.HttpHeaders();
        headers.set("Authorization", authHeader);
        return headers;
    }
}