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

// 分页查询评论列表
exports.getListByTeacherId = (req, res) => {
  const { id, page = 1, pagesize = 10, order = 1 } = req.query;
  const offset = (page - 1) * pagesize;
  let sql =
    "select * from ratings where teacher_id = ? and content is not null and content != '' order by date desc limit ?,?";
  if (order == 2) {
    sql =
      "select * from ratings where teacher_id = ? and content is not null and content != '' order by rating desc limit ?,?";
  } else if (order == 3) {
    sql =
      "select * from ratings where teacher_id = ? and content is not null and content != '' order by rating asc limit ?,?";
  }
  db.query(sql, [id, offset, Number(pagesize)], (err, results) => {
    if (err) return res.cc(err);
    const list = results;
    db.query(
      "select count(*) from ratings where teacher_id = ? and content is not null and content != ''",
      [id],
      (err, results) => {
        if (err) return res.cc(err);
        const total = results[0]["count(*)"];
        res.send({
          status: 0,
          message: "获取成功",
          data: {
            totalPage: Math.ceil(total / Number(pagesize)),
            list,
          },
        });
      }
    );
  });
};

// 根据count查询最新评论列表
exports.getListByCount = (req, res) => {
  const { teacher_id, count } = req.query;
  const sql =
    "select * from ratings where teacher_id = ? order by date desc limit ?";
  db.query(sql, [teacher_id, Number(count)], (err, results) => {
    if (err) return res.cc(err);

    res.send({
      status: 0,
      message: "获取成功",
      data: results,
    });
  });
};

// 根据id查询评论分布情况
exports.getRatingDistribution = (req, res) => {
  const { id } = req.query;
  const sql =
    "select rating, count(*) as count from ratings where teacher_id = ? group by rating";
  db.query(sql, [id], (err, results) => {
    if (err) return res.cc(err);
    let starList = [];
    for (let i = 5; i >= 1; i--) {
      const star = results.find((item) => item.rating === i);
      if (star) {
        starList.push(star);
      } else {
        starList.push({
          count: 0,
          rating: i,
        });
      }
    }
    // 计算总平均分
    const total = results.reduce(
      (acc, item) => acc + item.rating * item.count,
      0
    );
    const totalCount = results.reduce((acc, item) => acc + item.count, 0);
    const rating = Number((total / totalCount).toFixed(1));
    // 计算评分人数
    const rating_count = results.reduce((acc, item) => acc + item.count, 0);

    res.send({
      status: 0,
      message: "获取成功",
      data: {
        starList,
        rating,
        rating_count,
      },
    });
  });
};
