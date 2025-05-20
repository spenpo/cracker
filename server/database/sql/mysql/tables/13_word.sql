-- CreateTable
CREATE TABLE `wp_cracker_word` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `word` VARCHAR(50) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `wp_cracker_word` ADD CONSTRAINT `wp_cracker_word_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
