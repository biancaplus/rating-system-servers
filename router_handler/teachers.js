const db = require("../db/index");

// 新增
exports.add = (req, res) => {
  const teacherinfo = req.body;

  const sql1 =
    "select * from teachers where name = ? and faculty = ? and title = ?";
  db.query(
    sql1,
    [teacherinfo.name, teacherinfo.faculty, teacherinfo.title],
    (err, results) => {
      if (err) return res.cc(err);
      if (results.length > 0) {
        return res.cc("教师已存在");
      }

      const sql2 = "insert into teachers set ?";
      db.query(sql2, teacherinfo, (err, results) => {
        if (results.affectedRows !== 1) {
          return res.cc("新增失败");
        }
        res.cc("新增成功", 0);
      });
    }
  );
};

// 修改
exports.update = (req, res) => {
  const sql = "update teachers set ? where id = ?";
  db.query(sql, [req.body, req.body.id], (err, results) => {
    if (err) return res.cc(err);
    if (results.affectedRows !== 1) {
      return res.cc("修改失败");
    }
    res.cc("修改成功", 0);
  });
};

// 删除
exports.delete = (req, res) => {
  const sql = "delete from teachers where id = ?";
  db.query(sql, [req.query.id], (err, results) => {
    if (err) return res.cc(err);
    if (results.affectedRows !== 1) {
      return res.cc("删除失败");
    }
    res.cc("删除成功", 0);
  });
};
