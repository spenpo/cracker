# Cracker

This is a lifestyle/productivity intelligence app for tracking and analyzing creative work

## Requirements

- [Node.js](#nodejs)
- [MySQL](#mysql)
- [Redis](#redis)

## Development

Start setting up your dev environment by running the three separate services

### [Redis](https://redis.io/)

- The easy one. Start the service and confirm it is running. No config required
- Note the port it's running on and add it to your .env file

### [MySQL](https://www.mysql.com/)

- Start the service and create a new database
- Note the database credentials and fill them into the connection string in your .env file (DATABASE_URL)
  - In production, you may want to use [Prisma Accelerate](https://www.prisma.io/docs/accelerate), which is why the example .env file includes both DATABASE_URL and DIRECT_URL with DATABASE_URL pointing to an Accelerate URI (prisma://...)
  - For local development, point both variables to the same local connection string (mysql://...)
- Run the migrations with `npx prisma migrate reset`
  - This creates 7 tables and several other resources in the new database
  - You can check it against the [baseline migration](prisma/migrations/0_init/migration.sql)
  - See [Database](#database) below for verbose db documentation
- If you prefer to use [Docker](https://www.docker.com/), there are some sql scripts, [Dockerfiles](https://docs.docker.com/build/concepts/dockerfile/), and [Docker Compose](https://docs.docker.com/compose/intro/compose-application-model/) projects in the [server](/server/) directory
  - The sql scripts are prefixed with numbers to properly enforce an order or operations when building the docker image
  - The compose projects aren't currently functional due to lack of use. The structure is correct, but some debugging is required. If you get it working, please [issue a pull request](https://github.com/spope851/cracker/pulls)
  - There are scripts for [PostgreSQL](https://www.postgresql.org/) in there too. The app will work with Postgres, but you will have to tweak the [prisma schema](prisma/schema.prisma) if you choose to use it
  - Be sure to [baseline your database](https://www.prisma.io/docs/getting-started/setup-prisma/add-to-existing-project/relational-databases/baseline-your-database-typescript-postgresql) after building the docker image so that you can generate Prisma Client properly

### [Node.js](https://nodejs.org/en)

We recommend [Yarn](https://classic.yarnpkg.com/en/) for package management. Install it with `npm i -g yarn`

- Install dependencies with `yarn`
- Generate [Prisma Client](https://www.prisma.io/docs/orm/prisma-client/setup-and-configuration/introduction) with `yarn postinstall`
- Start the dev at [localhost:3000](http://localhost:3000) with `yarn dev`

## Database
...