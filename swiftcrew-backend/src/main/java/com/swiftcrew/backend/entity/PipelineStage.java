package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "pipeline_stages")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class PipelineStage extends BaseEntity {
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pipeline_id", nullable = false)
    private Pipeline pipeline;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false)
    private Integer position;

    @Column(columnDefinition = "TEXT")
    private String description;
}
