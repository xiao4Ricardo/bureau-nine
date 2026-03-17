package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "products")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Product extends BaseEntity {
    @Column(nullable = false, length = 200)
    private String name;

    @Column(length = 50)
    private String code;

    @Column(length = 100)
    private String category;

    @Column(name = "unit_price", precision = 12, scale = 2)
    private BigDecimal unitPrice;

    @Column(nullable = false)
    @Builder.Default
    private Boolean active = true;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(columnDefinition = "TEXT")
    private String tags;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id")
    private User owner;
}
