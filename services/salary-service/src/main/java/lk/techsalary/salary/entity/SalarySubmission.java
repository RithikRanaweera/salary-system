package lk.techsalary.salary.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

@Entity
@Table(
    schema = "salary",
    name = "submissions",
    indexes = {
        @Index(name = "idx_status",  columnList = "status"),
        @Index(name = "idx_country", columnList = "country"),
        @Index(name = "idx_title",   columnList = "job_title")
    }
)
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SalarySubmission {

    @Id
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID id;

    @Column(name = "job_title", nullable = false, length = 255)
    private String jobTitle;

    @Column(name = "company", length = 255)
    private String company;

    @Column(name = "anonymize", nullable = false)
    private boolean anonymize = true;

    @Column(name = "country", nullable = false, length = 100)
    private String country;

    @Column(name = "city", length = 100)
    private String city;

    @Column(name = "experience_years")
    private Integer experienceYears;

    @Enumerated(EnumType.STRING)
    @Column(name = "level", length = 50)
    private ExperienceLevel level;

    @Column(name = "gross_salary", nullable = false, precision = 14, scale = 2)
    private BigDecimal grossSalary;

    @Column(name = "currency", length = 10)
    @Builder.Default
    private String currency = "LKR";

    @Column(name = "tech_stack", columnDefinition = "text[]")
    private String[] techStack;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", length = 20, nullable = false)
    @Builder.Default
    private SubmissionStatus status = SubmissionStatus.PENDING;

    @CreationTimestamp
    @Column(name = "submitted_at", updatable = false)
    private LocalDateTime submittedAt;

    @Column(name = "approved_at")
    private LocalDateTime approvedAt;

    public enum SubmissionStatus {
        PENDING, APPROVED, REJECTED
    }

    public enum ExperienceLevel {
        INTERN, JUNIOR, MID, SENIOR, LEAD, PRINCIPAL
    }
}
