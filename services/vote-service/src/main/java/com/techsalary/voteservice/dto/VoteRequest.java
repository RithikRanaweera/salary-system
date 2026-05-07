package com.techsalary.voteservice.dto;

import jakarta.validation.constraints.NotNull;
import lombok.Data;
import java.util.UUID;

@Data
public class VoteRequest {

    @NotNull(message = "Submission ID is required")
    private UUID submissionId;

    @NotNull(message = "Vote type is required")
    private Boolean upvote;   // true = upvote, false = downvote
}