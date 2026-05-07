package lk.techsalary.salary.repository;

import lk.techsalary.salary.entity.SalarySubmission;
import lk.techsalary.salary.entity.SalarySubmission.SubmissionStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

@Repository
public interface SalarySubmissionRepository extends JpaRepository<SalarySubmission, UUID> {

    @Query("""
        SELECT s FROM SalarySubmission s
        WHERE s.id = :id AND s.status = :status
        """)
    Optional<SalarySubmission> findByIdAndStatus(
        @Param("id") UUID id,
        @Param("status") SubmissionStatus status
    );

    long countByStatus(SubmissionStatus status);

    Page<SalarySubmission> findByStatus(SubmissionStatus status, Pageable pageable);
}
