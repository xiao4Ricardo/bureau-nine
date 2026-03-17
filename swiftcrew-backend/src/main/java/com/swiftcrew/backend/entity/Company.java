package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "companies")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Company extends BaseEntity {
    @Column(nullable = false, length = 200)
    private String name;

    @Column(length = 30)
    private String phone;

    @Column(length = 255)
    private String website;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;
}
