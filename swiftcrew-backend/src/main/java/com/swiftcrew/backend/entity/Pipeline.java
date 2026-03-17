package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "pipelines")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Pipeline extends BaseEntity {
    @Column(nullable = false, length = 100)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;

    @OneToMany(mappedBy = "pipeline", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("position ASC")
    @Builder.Default
    private List<PipelineStage> stages = new ArrayList<>();
}
