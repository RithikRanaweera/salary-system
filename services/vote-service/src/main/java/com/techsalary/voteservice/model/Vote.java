package com.techsalary.voteservice.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
        name = "votes",
        schema = "community",
        // Prevent the same user voting twice on the same submission
        uniqueConstraints = @UniqueConstraint(
                columnNames = {"submission_id", "user_id"}
        )
)
@Data
public class Vote {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "submission_id", nullable = false)
    private UUID submissionId;

    // We store userId but NOT email — privacy is maintained
    @Column(name = "user_id", nullable = false)
    private Long userId;

    // true = upvote, false = downvote
    @Column(nullable = false)
    private Boolean upvote;

    @Column(name = "voted_at")
    private LocalDateTime votedAt = LocalDateTime.now();
}