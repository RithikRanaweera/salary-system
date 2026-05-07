package lk.techsalary.salary.controller;

import jakarta.validation.Valid;
import lk.techsalary.salary.dto.ApiResponse;
import lk.techsalary.salary.dto.SalarySubmitRequest;
import lk.techsalary.salary.dto.SalarySubmitResponse;
import lk.techsalary.salary.service.SalaryService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
@RequestMapping("/v1/salaries")
@RequiredArgsConstructor
@Slf4j
public class SalaryController {

    private final SalaryService salaryService;

    @PostMapping
    public ResponseEntity<ApiResponse<SalarySubmitResponse>> submit(
            @Valid @RequestBody SalarySubmitRequest request) {

        SalarySubmitResponse response = salaryService.submit(request);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(ApiResponse.success(response, "Salary submitted. Pending community review."));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<SalarySubmitResponse>> getById(
            @PathVariable UUID id) {

        SalarySubmitResponse response = salaryService.getById(id);
        return ResponseEntity.ok(ApiResponse.success(response, null));
    }

    // Internal endpoint — called only by vote-service, NOT exposed via Ingress
@PatchMapping("/{id}/approve")
public ResponseEntity<ApiResponse<SalarySubmitResponse>> approve(
        @PathVariable UUID id) {

    SalarySubmitResponse response = salaryService.approve(id);
    return ResponseEntity.ok(ApiResponse.success(response, "Submission approved"));
}

    private boolean isValidInternalToken(String token) {
        String expected = System.getenv().getOrDefault("INTERNAL_SERVICE_TOKEN", "");
        return !expected.isEmpty() && expected.equals(token);
    }
}
