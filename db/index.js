const mysql = require("mysql2");

const db = mysql.createPool({
  host: "127.0.0.1",
  user: "root",
  password: "bing123456",
  database: "rating_system",
});

// 测试数据库连接
// db.getConnection((err, connection) => {
//   if (err) {
//     console.error("Error connecting to the database:", err);
//     return;
//   }
//   console.log("Connected to the database");
//   connection.release(); // 释放连接
// });

module.exports = db;
