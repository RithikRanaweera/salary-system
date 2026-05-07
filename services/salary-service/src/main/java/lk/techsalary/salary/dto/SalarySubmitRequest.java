package lk.techsalary.salary.dto;

import jakarta.validation.constraints.*;
import lombok.Data;

import java.math.BigDecimal;
import java.util.List;

@Data
public class SalarySubmitRequest {

    @NotBlank(message = "Job title is required")
    @Size(min = 2, max = 255, message = "Job title must be between 2 and 255 characters")
    private String jobTitle;

    @Size(max = 255)
    private String company;

    private boolean anonymize = true;

    @NotBlank(message = "Country is required")
    @Size(max = 100)
    private String country;

    @Size(max = 100)
    private String city;

    @Min(value = 0, message = "Experience years cannot be negative")
    @Max(value = 50, message = "Experience years seems too high")
    private Integer experienceYears;

    @Pattern(
        regexp = "INTERN|JUNIOR|MID|SENIOR|LEAD|PRINCIPAL",
        message = "Level must be one of: INTERN, JUNIOR, MID, SENIOR, LEAD, PRINCIPAL"
    )
    private String level;

    @NotNull(message = "Gross salary is required")
    @DecimalMin(value = "0.01", message = "Salary must be greater than 0")
    @DecimalMax(value = "99999999.99", message = "Salary value is too large")
    @Digits(integer = 12, fraction = 2)
    private BigDecimal grossSalary;

    @Size(max = 10)
    private String currency = "LKR";

    @Size(max = 20, message = "Tech stack can have at most 20 items")
    private List<@Size(max = 50) String> techStack;
}
