package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "deal_products")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class DealProduct extends BaseEntity {

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "deal_id", nullable = false)
    private Deal deal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "product_id", nullable = false)
    private Product product;

    @Column(nullable = false)
    @Builder.Default
    private Integer quantity = 1;

    @Column(name = "unit_price", nullable = false, precision = 15, scale = 2)
    private BigDecimal unitPrice;
}
