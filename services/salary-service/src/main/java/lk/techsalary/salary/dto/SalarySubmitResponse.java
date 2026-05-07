package lk.techsalary.salary.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Data
@Builder
public class SalarySubmitResponse {
    private UUID id;
    private String jobTitle;
    private String company;
    private String country;
    private String city;
    private Integer experienceYears;
    private String level;
    private BigDecimal grossSalary;
    private String currency;
    private List<String> techStack;
    private String status;
    private LocalDateTime submittedAt;
}
