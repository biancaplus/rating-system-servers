const db = require("../db/index");

// 新增
exports.add = (req, res) => {
  const ratings = req.body;

  const sql1 = "select name, faculty, title from teachers where id = ?";
  db.query(sql1, ratings.teacher_id, (err, results) => {
    if (err) return res.cc(err);
    if (results.length === 0) {
      return res.cc("教师不存在");
    }

    const sql2 = "CALL add_rating(?, ?, ?)";
    db.query(
      sql2,
      [ratings.rating, ratings.content, ratings.teacher_id],
      (err, results) => {
        if (err) return res.cc(err);
        if (results.affectedRows === 0) {
          return res.cc("操作失败");
        }
        res.cc("操作成功", 0);
      }
    );
  });
};
