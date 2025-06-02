-- CreateTable
CREATE TABLE `wp_cracker_sentence` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `sentence` VARCHAR(512) NOT NULL,
    `tracker` INTEGER NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `wp_cracker_sentence` ADD CONSTRAINT `wp_cracker_sentence_tracker_fkey` FOREIGN KEY (`tracker`) REFERENCES `wp_cracker_tracker`(`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;
