# LF Database assignment

This repository contains a `PostgreSQL`-based database assignment, dockerized
for easy setup and execution. It covers SQL queries and database management
tasks, offering practical learning and hands-on experience.

Before you begin, ensure you have the following installed on your machine:

- Docker: [ Install Docker ](https://docs.docker.com/engine/install/)
- Docker Compose: [Install Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

To get started with this project, follow these steps:

1. Clone this repository:

   ```bash
   git clone <repository-url>
   cd <repository-folder>
   ```

1. Create a `.env` file in the root of the project with the following contents. You can set your own values:

   ```bash
   POSTGRES_USER=postgres
   POSTGRES_PW=postgres
   POSTGRES_DB=postgres
   PGADMIN_MAIL=postges@postgre.com
   PGADMIN_PW=postgres
   ```

   Adjust the values of each variable as needed.

1. Start the services using `docker-compose`:

   ```bash
   docker compose up -d
   ```

   This command will start `pgAdmin`, `cloudbeaver` and `PostgreSQL` as services in the background.

1. Access `pgAdmin`:
   Open your web browser and go to `http://localhost:5050`.
   Log in using the email (`PGADMIN_EMAIL`) and password (`PGADMIN_PW`) specified in your `.env` file.

1. Add a `PostgreSQL` server in `pgAdmin`:

   - Click on `Add New Server`.
   - In the `General` tab, enter a name for the server.
   - In the `Connection` tab:
   - Host name/address: `postgres`
   - Port: 5432
   - Username: The value of `POSTGRES_USER` from your `.env` file.
   - Password: The value of `POSTGRES_PW` from your `.env` file.

   Save the server configuration and connect.

1. For `cloudbeaver` go to `http://localhost:6060` and to add connection read the docs at [https://github.com/dbeaver/cloudbeaver/wiki/Run-Docker-Container](https://github.com/dbeaver/cloudbeaver/wiki/Run-Docker-Container)

## Stopping the Services

To stop the services and remove the containers, run:

```bash
docker compose down
```

This command will stop and remove the `pgAdmin` and `PostgreSQL` containers.
