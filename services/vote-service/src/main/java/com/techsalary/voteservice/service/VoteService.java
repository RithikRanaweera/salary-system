package com.techsalary.voteservice.service;

import com.techsalary.voteservice.dto.VoteRequest;
import com.techsalary.voteservice.model.Vote;
import com.techsalary.voteservice.repository.VoteRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import java.util.UUID;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class VoteService {

    private final VoteRepository voteRepository;
    private final RestTemplate restTemplate;

    @Value("${services.salary-url}")
    private String salaryServiceUrl;

    @Value("${voting.approval-threshold}")
    private int approvalThreshold;

    // public Vote castVote(VoteRequest request, Long userId) {

    //     // Check if user already voted on this submission
    //     if (voteRepository.existsBySubmissionIdAndUserId(
    //             request.getSubmissionId(), userId)) {
    //         throw new RuntimeException("You have already voted on this submission");
    //     }

    //     // Record the vote
    //     Vote vote = new Vote();
    //     vote.setSubmissionId(request.getSubmissionId());
    //     vote.setUserId(userId);      // userId only, never email
    //     vote.setUpvote(request.getUpvote());
    //     Vote saved = voteRepository.save(vote);

    //     // Count total upvotes for this submission
    //     long upvoteCount = voteRepository.countBySubmissionIdAndUpvote(
    //             request.getSubmissionId(), true);

    //     log.info("Submission {} has {} upvotes (threshold: {})",
    //             request.getSubmissionId(), upvoteCount, approvalThreshold);

    //     // If threshold reached → call salary service to approve it
    //     if (upvoteCount >= approvalThreshold) {
    //         approveSubmission(request.getSubmissionId());
    //     }

    //     return saved;
    // }

public Vote castVote(VoteRequest request, Long userId) {

    // Check if user already voted
    Optional<Vote> existingVote = voteRepository
        .findBySubmissionIdAndUserId(request.getSubmissionId(), userId);

    Vote saved;

    if (existingVote.isPresent()) {
        // Update existing vote
        Vote vote = existingVote.get();
        vote.setUpvote(request.getUpvote());
        saved = voteRepository.save(vote);
        log.info("Vote updated for submission {}", request.getSubmissionId());
    } else {
        // New vote
        Vote vote = new Vote();
        vote.setSubmissionId(request.getSubmissionId());
        vote.setUserId(userId);
        vote.setUpvote(request.getUpvote());
        saved = voteRepository.save(vote);
        log.info("New vote recorded for submission {}", request.getSubmissionId());
    }

    // Count upvotes
    long upvoteCount = voteRepository.countBySubmissionIdAndUpvote(
            request.getSubmissionId(), true);

    log.info("Submission {} has {} upvotes (threshold: {})",
            request.getSubmissionId(), upvoteCount, approvalThreshold);

    // Only approve if threshold reached
    if (upvoteCount >= approvalThreshold) {
        approveSubmission(request.getSubmissionId());
    }

    return saved;
}



private void approveSubmission(UUID submissionId) {
    try {
        String url = salaryServiceUrl + "/v1/salaries/" + submissionId + "/approve";
        restTemplate.exchange(
            url,
            org.springframework.http.HttpMethod.PATCH,
            org.springframework.http.HttpEntity.EMPTY,
            String.class
        );
        log.info("Submission {} has been APPROVED!", submissionId);
    } catch (Exception e) {
        log.error("Failed to approve submission {}: {}", submissionId, e.getMessage());
    }
}


    public long getUpvoteCount(UUID submissionId) {
        return voteRepository.countBySubmissionIdAndUpvote(submissionId, true);
    }
}