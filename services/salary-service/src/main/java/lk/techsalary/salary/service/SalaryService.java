package lk.techsalary.salary.service;

import lk.techsalary.salary.dto.SalarySubmitRequest;
import lk.techsalary.salary.dto.SalarySubmitResponse;
import lk.techsalary.salary.entity.SalarySubmission;
import lk.techsalary.salary.entity.SalarySubmission.ExperienceLevel;
import lk.techsalary.salary.entity.SalarySubmission.SubmissionStatus;
import lk.techsalary.salary.exception.ResourceNotFoundException;
import lk.techsalary.salary.repository.SalarySubmissionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Slf4j
public class SalaryService {

    private final SalarySubmissionRepository repository;

    @Transactional
    public SalarySubmitResponse submit(SalarySubmitRequest request) {
        log.info("New salary submission: role={}, country={}", request.getJobTitle(), request.getCountry());
        SalarySubmission entity = buildEntity(request);
        SalarySubmission saved  = repository.save(entity);
        log.info("Submission saved id={} status=PENDING", saved.getId());
        return toResponse(saved);
    }

    public SalarySubmitResponse getById(UUID id) {
        SalarySubmission submission = repository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Submission not found: " + id));
        return toResponse(submission);
    }

    // @Transactional
    // public SalarySubmitResponse approve(UUID id) {
    //     SalarySubmission submission = repository.findByIdAndStatus(id, SubmissionStatus.PENDING)
    //             .orElseThrow(() -> new ResourceNotFoundException("Pending submission not found: " + id));
    //     submission.setStatus(SubmissionStatus.APPROVED);
    //     submission.setApprovedAt(LocalDateTime.now());
    //     SalarySubmission saved = repository.save(submission);
    //     log.info("Submission {} approved", id);
    //     return toResponse(saved);
    // }

    @Transactional
public SalarySubmitResponse approve(UUID id) {
    SalarySubmission submission = repository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Submission not found: " + id));

    // Already approved — just return, don't throw
    if (submission.getStatus() == SubmissionStatus.APPROVED) {
        log.info("Submission {} already approved, skipping", id);
        return toResponse(submission);
    }

    submission.setStatus(SubmissionStatus.APPROVED);
    submission.setApprovedAt(LocalDateTime.now());
    SalarySubmission saved = repository.save(submission);
    log.info("Submission {} approved", id);
    return toResponse(saved);
}

    // ── Private helpers ──────────────────────────────────────

    private SalarySubmission buildEntity(SalarySubmitRequest req) {
        String[] techStack = req.getTechStack() != null
                ? req.getTechStack().toArray(new String[0])
                : new String[0];

        return SalarySubmission.builder()
                .jobTitle(req.getJobTitle().trim())
                .company(req.getCompany() != null ? req.getCompany().trim() : null)
                .anonymize(req.isAnonymize())
                .country(req.getCountry().trim())
                .city(req.getCity() != null ? req.getCity().trim() : null)
                .experienceYears(req.getExperienceYears())
                .level(req.getLevel() != null ? ExperienceLevel.valueOf(req.getLevel()) : null)
                .grossSalary(req.getGrossSalary())
                .currency(req.getCurrency() != null ? req.getCurrency() : "LKR")
                .techStack(techStack)
                .build();
    }

    private SalarySubmitResponse toResponse(SalarySubmission s) {
        String visibleCompany = s.isAnonymize() ? null : s.getCompany();
        List<String> techStack = s.getTechStack() != null
                ? Arrays.asList(s.getTechStack())
                : List.of();

        return SalarySubmitResponse.builder()
                .id(s.getId())
                .jobTitle(s.getJobTitle())
                .company(visibleCompany)
                .country(s.getCountry())
                .city(s.getCity())
                .experienceYears(s.getExperienceYears())
                .level(s.getLevel() != null ? s.getLevel().name() : null)
                .grossSalary(s.getGrossSalary())
                .currency(s.getCurrency())
                .techStack(techStack)
                .status(s.getStatus().name())
                .submittedAt(s.getSubmittedAt())
                .build();
    }
}
