// https://expressjs.com/en/starter/hello-world.html
const express = require("express");
const app = express();
const port = 8080;

app.get("/", (req, res) => {
  const response = {
    message: "Hello World!!",
  };
  res.json(response);
});

app.get("/status", (req, res) => {
  const response = {
    status: "ok",
  };
  res.json(response);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
