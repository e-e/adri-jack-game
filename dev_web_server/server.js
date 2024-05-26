const express = require("express");
const path = require("path");

const port = 8989;
const app = express();

// self.send_header("Cross-Origin-Opener-Policy", "same-origin")
//         self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
//         self.send_header("Access-Control-Allow-Origin", "*")
app.all("*", (req, res, next) => {
  res.set("Cross-Origin-Opener-Policy", "same-origin");
  res.set("Cross-Origin-Embedder-Policy", "require-corp");
  res.set("Access-Control-Allow-Origin", "*");
  next();
});

app.use("/", express.static(path.join(__dirname, "..", "_builds", "web")));

app.get("/", (req, res) =>
  res.sendFile(path.join(__dirname, "..", "_builds", "web", "client.html")),
);

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
