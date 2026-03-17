package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "contacts")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Contact extends BaseEntity {

    @Column(nullable = false, length = 150)
    private String name;

    @Column(length = 150)
    private String email;

    @Column(length = 30)
    private String phone;

    @Column(columnDefinition = "TEXT")
    private String address;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "company_id")
    private Company company;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;
}
