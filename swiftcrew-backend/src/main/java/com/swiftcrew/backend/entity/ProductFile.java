package com.swiftcrew.backend.entity;

import com.swiftcrew.backend.common.BaseEntity;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "product_files")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class ProductFile extends BaseEntity {

    @Column(name = "product_id", nullable = false)
    private java.util.UUID productId;

    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    @Column(name = "original_name", nullable = false, length = 255)
    private String originalName;

    @Column(name = "content_type", length = 100)
    private String contentType;

    @Column(name = "file_size", nullable = false)
    private Long fileSize;

    @Column(name = "file_path", nullable = false, length = 500)
    private String filePath;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "uploaded_by")
    private User uploadedBy;
}
