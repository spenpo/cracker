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

-- AddForeignKey
ALTER TABLE `wp_cracker_feature_flag` ADD CONSTRAINT `wp_cracker_feature_flag_required_role_fkey` FOREIGN KEY (`required_role`) REFERENCES `wp_cracker_role_lookup`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

INSERT INTO `wp_cracker_feature_flag` (`id`, `name`, `description`, `is_enabled`, `required_role`) VALUES
(1, 'premiumDashboardSwitch', 'a switch that changes state from basic to premium dashboard. brings up upgrade popup for basic members', 0, NULL),
(2, 'adminDashboardMenuItem', 'option in user menu that navigates to admin dashboard', 1, 3);
