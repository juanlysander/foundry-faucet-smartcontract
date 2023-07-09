const express = require("express");
const path = require("path");
const app = express();

app.use(express.static(path.join(__dirname, "src")));

app.get("/", (req, res) => {
    res.sendFile(path.join(__dirname + "/src/html/index.html"));
})

const server = app.listen(5000);
const portNumber = server.address().port;
console.log(`port is open on ${portNumber}`);