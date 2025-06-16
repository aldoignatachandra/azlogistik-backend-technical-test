const winston = require("winston");

let logger = new winston.Logger({
  transports: [
    new winston.transports.Console({
      level: "info",
      handleExceptions: true,
      json: false,
      colorize: true,
    }),
  ],
  exitOnError: false,
});

const log = (context, message, scope) => {
  const obj = {
    context,
    scope,
    message: message.toString(),
  };
  logger.info(obj);
};

const info = (context, message, scope, meta) => {
  const obj = {
    context,
    scope,
    message: message,
    meta,
  };
  logger.info(obj);
};

const error = (context, message, scope, meta) => {
  const obj = {
    context,
    scope,
    message: message,
    meta,
  };
  logger.error(obj);
};

module.exports = {
  log,
  info,
  error,
};
