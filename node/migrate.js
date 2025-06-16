const { Client } = require("pg");
const { readdirSync, readFileSync, statSync } = require("fs");
const { join } = require("path");
const { pgConnection } = require("./config/database");

// Function to check if the database exists; if not, create it.
const checkAndCreateDatabase = async () => {
  // Connect to default database, e.g., "postgres"
  const tempConnection = { ...pgConnection, database: "postgres" };
  const tempClient = new Client(tempConnection);
  await tempClient.connect();

  const dbName = pgConnection.database;
  const res = await tempClient.query(
    `SELECT 1 FROM pg_database WHERE datname = $1`,
    [dbName]
  );

  if (res.rowCount === 0) {
    console.log(`\x1b[33mDatabase "${dbName}" does not exist. Creating...`);
    await tempClient.query(`CREATE DATABASE "${dbName}";`);
    console.log(`\x1b[32mDatabase "${dbName}" created.`);
  } else {
    console.log(`\x1b[32mDatabase "${dbName}" already exists.`);
  }

  await tempClient.end();
};

const client = new Client(pgConnection);

// Execute migrations for regular tables
const runMigrations = async () => {
  // Exclude the seeder from the regular migration loop
  const migrations = readdirSync("config/migrations").filter(
    (file) =>
      !file.includes("5_table_seeder.sql") &&
      !file.includes("6_helper_seeder_function.sql")
  );

  console.log(`\x1b[32m=============================`);
  console.log(`\x1b[32mStarting Migration`);
  console.log(`\x1b[32m=============================`);

  for (let index = 0; index < migrations.length; index++) {
    const filePath = join("config/migrations", migrations[index]);
    if (statSync(filePath).isFile()) {
      console.log(`\x1b[33mMigrating ${migrations[index]}`);
      await client.query(readFileSync(filePath, "utf-8"));
      console.log(`\x1b[32mMigrated ${migrations[index]}`);
    }
  }

  console.log(`\x1b[32m=============================`);
  console.log(`\x1b[32mMigration Finished`);
  console.log(`\x1b[32m=============================`);
};

// Execute the seeder after all migrations
const runSeeders = async () => {
  console.log(`\x1b[32m=============================`);
  console.log(`\x1b[32mStarting Seeder`);
  console.log(`\x1b[32m=============================`);

  const seederPath = join("config/migrations", "5_table_seeder.sql");
  await client.query(readFileSync(seederPath, "utf-8"));

  console.log(`\x1b[32mSeeder Executed: 5_table_seeder.sql`);

  // const seederFuncPath = join(
  //   "config/migrations",
  //   "6_helper_seeder_function.sql"
  // );
  // await client.query(readFileSync(seederFuncPath, "utf-8"));

  // console.log(`\x1b[32mSeeder Executed: 6_helper_seeder_function.sql`);

  console.log(`\x1b[32m=============================`);
  console.log(`\x1b[32mSeeder Finished`);
  console.log(`\x1b[32m=============================`);
};

const migrate = async () => {
  try {
    // Check if target database exists, and create it if not.
    await checkAndCreateDatabase();

    // Connect to the target database
    await client.connect();
    await client.query("BEGIN");

    await runMigrations();
    await runSeeders();

    await client.query("COMMIT");
  } catch (error) {
    console.error("Error executing migrations:", error);
  } finally {
    await client.end();
  }
};

migrate();
