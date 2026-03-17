package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "deals")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Deal extends BaseEntity {
    @Column(nullable = false, length = 200)
    private String name;

    @Column(precision = 14, scale = 2)
    private BigDecimal amount;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pipeline_id", nullable = false)
    private Pipeline pipeline;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "stage_id", nullable = false)
    private PipelineStage stage;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contact_id")
    private Contact contact;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;

    @Column(name = "expected_close_date")
    private LocalDate expectedCloseDate;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String tags;
}
