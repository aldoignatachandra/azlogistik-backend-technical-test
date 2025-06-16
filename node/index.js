require("dotenv/config");

const express = require("express");
const useragent = require("express-useragent");
const logger = require("./helpers/logger");
const reservationRoutes = require("./routes/reservations");

const app = express();
app.use(express.json());
app.use(useragent.express());
app.use(express.json({ limit: "50mb" }));
app.use(express.urlencoded({ limit: "50mb", extended: false }));

// List Routes
app.use("/api/reservation", reservationRoutes);

const ctx = "app-listen";
const port = process.env.PORT;
app.listen(port, () =>
  logger.log(
    ctx,
    `Server started, listening at port:${port}`,
    "initate application"
  )
);
