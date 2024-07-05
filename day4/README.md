## Ingesting database from a `CSV` file

To ingest a database from a `CSV` file into your `postgresql` container, follow these steps:

   1. **Prepare Your `CSV` File:** Ensure the `CSV` file you want to import is available on your local machine.

   1. **Copy `CSV` to `postgresql` Container:** Use the following command to copy the `CSV` file into the `root` directory of the `postgresql` container:
      ``` bash
      docker cp <path_to_csv_file_on_your_computer> postgresql:/
      ```
      This command transfers the `CSV` file from your local machine to the `root`
      directory of the `postgresql` container, making it accessible for `COPY`
      operation.

