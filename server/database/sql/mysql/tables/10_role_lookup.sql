-- CreateTable
CREATE TABLE `wp_cracker_role_lookup` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(10) NOT NULL,
    `description` VARCHAR(255) NOT NULL,

    UNIQUE INDEX `wp_cracker_role_lookup_name_key`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

INSERT INTO `wp_cracker_role_lookup` (`id`, `name`, `description`) VALUES
(1, 'member', 'default role. basic member. access to free features'),
(2, 'premium', 'paid member. access to premium features'),
(3, 'admin', 'administrator. access to admin only features');
