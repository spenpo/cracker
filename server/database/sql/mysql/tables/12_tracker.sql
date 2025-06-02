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

-- AddForeignKey
ALTER TABLE `wp_cracker_tracker` ADD CONSTRAINT `wp_cracker_tracker_user_fkey` FOREIGN KEY (`user`) REFERENCES `wp_cracker_user`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
