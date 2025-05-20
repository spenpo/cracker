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

-- AddForeignKey
ALTER TABLE `wp_cracker_user` ADD CONSTRAINT `wp_cracker_user_role_fkey` FOREIGN KEY (`role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
