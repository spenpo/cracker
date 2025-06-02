-- CreateTable
CREATE TABLE "feature_flag" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" VARCHAR(255) NOT NULL,
    "is_enabled" BIT(1) NOT NULL,
    "required_role" INTEGER,

    CONSTRAINT "feature_flag_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "role_lookup" (
    "id" SERIAL NOT NULL,
    "name" VARCHAR(10) NOT NULL,
    "description" VARCHAR(255) NOT NULL,

    CONSTRAINT "role_lookup_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sentence" (
    "id" SERIAL NOT NULL,
    "sentence" VARCHAR(512) NOT NULL,
    "tracker" INTEGER NOT NULL,

    CONSTRAINT "sentence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tracker" (
    "id" SERIAL NOT NULL,
    "overview" VARCHAR(512) NOT NULL,
    "number_creative_hours" DECIMAL(3,1) NOT NULL,
    "rating" SMALLINT NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "user" INTEGER NOT NULL,

    CONSTRAINT "tracker_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user" (
    "id" SERIAL NOT NULL,
    "username" VARCHAR(50) NOT NULL,
    "password" VARCHAR(100) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "created_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    "role" INTEGER DEFAULT 1,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "word" (
    "id" SERIAL NOT NULL,
    "word" VARCHAR(50) NOT NULL,
    "tracker" INTEGER NOT NULL,

    CONSTRAINT "word_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "feature_flag_name_key" ON "feature_flag"("name");

-- CreateIndex
CREATE UNIQUE INDEX "role_lookup_name_key" ON "role_lookup"("name");

-- CreateIndex
CREATE UNIQUE INDEX "user_username_key" ON "user"("username");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- AddForeignKey
ALTER TABLE "feature_flag" ADD CONSTRAINT "feature_flag_required_role_fkey" FOREIGN KEY ("required_role") REFERENCES "role_lookup"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "sentence" ADD CONSTRAINT "sentence_tracker_fkey" FOREIGN KEY ("tracker") REFERENCES "tracker"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "tracker" ADD CONSTRAINT "tracker_user_fkey" FOREIGN KEY ("user") REFERENCES "user"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "user" ADD CONSTRAINT "user_role_fkey" FOREIGN KEY ("role") REFERENCES "role_lookup"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "word" ADD CONSTRAINT "word_tracker_fkey" FOREIGN KEY ("tracker") REFERENCES "tracker"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

