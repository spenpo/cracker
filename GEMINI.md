# Project: Creativity Tracker (Cracker)

## Overview
This is a full-stack **Next.js** application designed to track and visualize creativity metrics. It leverages a **GraphQL** API built with **TypeGraphQL** and **Apollo Server**, integrated directly into Next.js API routes. The application uses a robust backend infrastructure running in **Docker** containers, including PostgreSQL, MongoDB, and Redis.

## Tech Stack

*   **Frontend:** Next.js 13, React 18, Material UI (MUI), Apollo Client, Nivo (Charts).
*   **Backend:** Next.js API Routes, Apollo Server, TypeGraphQL.
*   **Database:** PostgreSQL (Primary), MongoDB (Unstructured/Logs).
*   **Caching:** Redis.
*   **Infrastructure:** Docker & Docker Compose.
*   **Language:** TypeScript.

## Getting Started

### Prerequisites
*   Node.js (v18+ recommended)
*   Yarn (or npm)
*   Docker & Docker Compose

### Installation & Setup

1.  **Install Dependencies:**
    ```bash
    yarn install
    ```

2.  **Start Backend Infrastructure:**
    This spins up PostgreSQL, MongoDB, Redis, and admin tools (pgAdmin, Mongo Express).
    ```bash
    yarn start:server
    ```
    *   *Note: Ensure Docker Desktop (or daemon) is running.*

3.  **Start Development Server:**
    ```bash
    yarn dev
    ```
    Access the app at [http://localhost:3000](http://localhost:3000).

4.  **Generate GraphQL Types:**
    The project uses `graphql-codegen` to generate TypeScript types from the GraphQL schema. The dev server must be running for this to work (as it introspects the endpoint).
    ```bash
    yarn codegen
    ```

## Key Commands

| Command | Description |
| :--- | :--- |
| `yarn dev` | Starts the Next.js development server. |
| `yarn build` | Builds the application for production. |
| `yarn start:server` | Starts backend services (DBs, Cache) via Docker Compose. |
| `yarn codegen` | Generates GraphQL types based on schema and operations. |
| `yarn lint` | Runs ESLint. |
| `yarn it:db` | Access the running PostgreSQL container shell. |
| `yarn it:cache` | Access the running Redis CLI. |

## Architecture & Directory Structure

*   **`/pages`**: Next.js pages and API routes.
    *   **`/api/graphql.ts`**: The entry point for the Apollo GraphQL server.
*   **`/graphql`**: Core logic for the GraphQL API and Client.
    *   **`/resolvers`**: Backend resolvers (business logic) for TypeGraphQL.
    *   **`/schemas`**: TypeGraphQL schemas/input types.
    *   **`/client`**: Client-side GraphQL queries and mutations.
*   **`/components`**: React UI components (MUI based).
*   **`/server`**: Docker configuration and database initialization scripts.
    *   **`docker-compose.yml`**: Defines the dev infrastructure services.
*   **`/generated`**: auto-generated TypeScript types from GraphQL.

## Development Notes

*   **Database Access:**
    *   **Postgres:** Port 5432 (User: `postgres`, Pass: `postgres`, DB: `postgres`).
    *   **MongoDB:** Port 27017 (User: `mongo`, Pass: `mongo`).
    *   **Redis:** Port 6379.
*   **Admin Tools:**
    *   **pgAdmin:** [http://localhost:4000](http://localhost:4000) (Email: `spope@blockchains.com`, Pass: `password`).
    *   **Mongo Express:** [http://localhost:8081](http://localhost:8081).
*   **GraphQL:** The schema is built code-first using `type-graphql`. When making backend changes, ensure you update the resolvers and then run `yarn codegen` to update frontend types.
