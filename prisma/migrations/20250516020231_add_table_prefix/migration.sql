/*
  Warnings:

  - You are about to drop the `feature_flag` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `role_lookup` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sentence` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `tracker` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `user` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `word` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE `feature_flag` DROP FOREIGN KEY `feature_flag_required_role_fkey`;

-- DropForeignKey
ALTER TABLE `sentence` DROP FOREIGN KEY `sentence_tracker_fkey`;

-- DropForeignKey
ALTER TABLE `tracker` DROP FOREIGN KEY `tracker_user_fkey`;

-- DropForeignKey
ALTER TABLE `user` DROP FOREIGN KEY `user_role_fkey`;

-- DropForeignKey
ALTER TABLE `word` DROP FOREIGN KEY `word_tracker_fkey`;

-- DropTable
DROP TABLE `feature_flag`;

-- DropTable
DROP TABLE `role_lookup`;

-- DropTable
DROP TABLE `sentence`;

-- DropTable
DROP TABLE `tracker`;

-- DropTable
DROP TABLE `user`;

-- DropTable
DROP TABLE `word`;

-- CreateTable
CREATE TABLE `wp_cracker_feature_flag` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `description` VARCHAR(255) NOT NULL,
    `is_enabled` BOOLEAN NOT NULL DEFAULT false,
    `required_role` INTEGER NULL,

    UNIQUE INDEX `wp_cracker_feature_flag_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_role_lookup` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL,
    `description` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `wp_cracker_role_lookup_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_sentence` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sentence` VARCHAR(512) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_tracker` (
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
CREATE TABLE `wp_cracker_user` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL,
    `password` VARCHAR(100) NOT NULL,
    `email` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `updated_at` TIMESTAMP(6) NULL DEFAULT CURRENT_TIMESTAMP(6),
    `role` INTEGER NULL DEFAULT 1,

    UNIQUE INDEX `wp_cracker_user_username_key`(`username`),
    UNIQUE INDEX `wp_cracker_user_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `wp_cracker_word` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `word` VARCHAR(50) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `wp_cracker_feature_flag` ADD CONSTRAINT `wp_cracker_feature_flag_required_role_fkey` FOREIGN KEY (`required_role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_sentence` ADD CONSTRAINT `wp_cracker_sentence_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_tracker` ADD CONSTRAINT `wp_cracker_tracker_user_fkey` FOREIGN KEY (`user`) REFERENCES `wp_cracker_user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_user` ADD CONSTRAINT `wp_cracker_user_role_fkey` FOREIGN KEY (`role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE `wp_cracker_word` ADD CONSTRAINT `wp_cracker_word_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
