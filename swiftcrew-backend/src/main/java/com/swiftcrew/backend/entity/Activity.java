package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "activities")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Activity extends BaseEntity {
    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private Type type;

    @Column(nullable = false, length = 200)
    private String title;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "due_date")
    private LocalDate dueDate;

    @Column(name = "due_time")
    private LocalTime dueTime;

    @Column(nullable = false)
    @Builder.Default
    private Boolean completed = false;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "contact_id")
    private Contact contact;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "deal_id")
    private Deal deal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id")
    private Product product;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;

    public enum Type {
        TASK, EVENT, CALL
    }
}
