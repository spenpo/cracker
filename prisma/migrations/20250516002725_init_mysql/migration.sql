-- CreateTable
CREATE TABLE `feature_flag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `is_enabled` BOOLEAN NOT NULL DEFAULT false,
    `required_role` INTEGER NULL,

    UNIQUE INDEX `feature_flag_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `role_lookup` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL,
    `description` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `role_lookup_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `sentence` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sentence` VARCHAR(512) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `tracker` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `overview` VARCHAR(512) NOT NULL,
    `number_creative_hours` DECIMAL(3, 1) NOT NULL,
    `rating` SMALLINT NOT NULL,
    `created_at` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `updated_at` TIMESTAMP(0) NULL DEFAULT CURRENT_TIMESTAMP(0),
    `user` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `role` INTEGER NULL DEFAULT 1,

    UNIQUE INDEX `user_username_key`(`username`),
    UNIQUE INDEX `user_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `word` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `word` VARCHAR(50) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `feature_flag` ADD CONSTRAINT `feature_flag_required_role_fkey` FOREIGN KEY (`required_role`) REFERENCES `role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `sentence` ADD CONSTRAINT `sentence_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `tracker` ADD CONSTRAINT `tracker_user_fkey` FOREIGN KEY (`user`) REFERENCES `user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `user` ADD CONSTRAINT `user_role_fkey` FOREIGN KEY (`role`) REFERENCES `role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `word` ADD CONSTRAINT `word_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
