const db = require("../db/index");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const config = require("../config");

// 注册
exports.register = (req, res) => {
  const userinfo = req.body;

  const sql1 = "select * from users where username = ?";
  db.query(sql1, [userinfo.username], (err, results) => {
    if (results.length > 0) {
      return res.cc("用户名被占用");
    }

    userinfo.password = bcrypt.hashSync(userinfo.password, 10);
    const sql2 = "insert into users set ?";
    db.query(sql2, userinfo, (err, results) => {
      if (results.affectedRows !== 1) {
        return res.cc("注册失败");
      }
      res.cc("注册成功", 0);
    });
  });
};

// 登录
exports.login = (req, res) => {
  const userinfo = req.body;
  const sql = "select * from users where username = ?";
  db.query(sql, [userinfo.username], (err, results) => {
    if (err) return res.cc(err);
    if (results.length !== 1) return res.cc("登录失败");

    const compareResult = bcrypt.compareSync(
      userinfo.password,
      results[0].password
    );
    if (!compareResult) return res.cc("密码不正确");

    const user = { ...results[0], password: "", avatar: "" };
    const tokenStr = jwt.sign(user, config.jwtSecretKey, {
      expiresIn: config.expiresIn,
    });

    res.send({
      status: 0,
      message: "登录成功",
      token: "Bearer " + tokenStr,
    });
  });
};

// 退出登录
exports.logout = (req, res) => {
  res.cc("退出成功", 0);
};
