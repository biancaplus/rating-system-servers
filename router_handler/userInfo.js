const db = require("../db/index");
const bcrypt = require("bcryptjs");
const forge = require("node-forge");
const { privateKey } = require("../utils/key");

// 获取用户信息
exports.getUserInfo = (req, res) => {
  const user = req.auth;

  const sql = "select id, username from users where id = ?";
  db.query(sql, [user.id], (err, results) => {
    if (err) return res.cc(err);
    if (results.length !== 1) return res.cc("获取用户信息失败");

    res.send({
      status: 0,
      message: "获取用户信息成功",
      data: results[0],
    });
  });
};

// 更新用户密码
exports.updatePassword = (req, res) => {
  const user = req.auth;
  const encrypted = req.body.data;

  try {
    const decrypted = privateKey.decrypt(
      forge.util.decode64(encrypted),
      "RSAES-PKCS1-V1_5"
    );
    const pwds = JSON.parse(decrypted);
    const sql1 = "select * from users where id = ?";
    db.query(sql1, [user.id], (err, results) => {
      if (err) return res.cc(err);
      if (results.length !== 1) return res.cc("用户不存在");

      const compareResult = bcrypt.compareSync(
        pwds.oldPwd,
        results[0].password
      );
      if (!compareResult) return res.cc("旧密码不正确");

      const compareResult2 = bcrypt.compareSync(
        pwds.newPwd,
        results[0].password
      );
      if (compareResult2) {
        return res.cc("新密码不能与旧密码相同");
      }

      const newPwd = bcrypt.hashSync(pwds.newPwd, 10);

      const sql2 = "update users set password = ? where id = ?";
      db.query(sql2, [newPwd, user.id], (err, results) => {
        if (err) return res.cc(err);
        if (results.affectedRows !== 1) return res.cc("更新用户密码失败");

        res.cc("更新用户密码成功", 0);
      });
    });
  } catch (err) {
    res.cc("修改失败");
  }
};
