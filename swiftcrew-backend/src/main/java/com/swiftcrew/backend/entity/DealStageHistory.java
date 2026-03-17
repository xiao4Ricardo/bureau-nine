package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "deal_stage_history")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DealStageHistory extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "deal_id", nullable = false)
    private Deal deal;

    @Column(name = "from_stage_name")
    private String fromStageName;

    @Column(name = "to_stage_name", nullable = false)
    private String toStageName;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "changed_by", nullable = false)
    private User changedBy;

    @Column(name = "changed_at", nullable = false)
    private LocalDateTime changedAt;
}
