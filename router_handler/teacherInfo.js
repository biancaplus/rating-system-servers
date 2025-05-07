const db = require("../db/index");

function isJsonString(str) {
  try {
    JSON.parse(str);
    return true;
  } catch (e) {
    return false;
  }
}

// 查询
exports.getList = (req, res) => {
  const {
    order = "t.rating",
    page = 1,
    pagesize = 10,
    keywords = "",
  } = req.query;
  const offset = (page - 1) * pagesize;

  db.query(
    "select count(*) from teachers WHERE name LIKE CONCAT('%', ?, '%')",
    [keywords],
    (err, results) => {
      if (err) return res.cc(err);
      const total = results[0]["count(*)"];

      let orderBy = "t.id DESC";
      if (order == 1) {
        orderBy = "t.rating DESC";
      } else if (order == 2) {
        orderBy = "t.rating_count DESC";
      } else if (order == 3) {
        orderBy = "LEFT(CONVERT(name USING gbk) COLLATE gbk_chinese_ci, 1)";
      }

      db.query(
        `SELECT 
    t.*,
    COALESCE(
        JSON_ARRAYAGG(
            JSON_OBJECT(
                'id', r.id,
                'date', r.date,
                'rating', r.rating,
                'content', r.content
            )
        ),
        JSON_ARRAY()
    ) AS recent_ratings
FROM teachers t
LEFT JOIN (
    SELECT 
        *,
        ROW_NUMBER() OVER (PARTITION BY teacher_id ORDER BY date DESC) AS rn
    FROM ratings WHERE content IS NOT NULL AND content != ''
) r ON t.id = r.teacher_id AND r.rn <= 3
WHERE t.name LIKE CONCAT('%', '${keywords}', '%')
GROUP BY t.id
ORDER BY ${orderBy}
LIMIT ?,?;`,
        [offset, Number(pagesize)],
        (err, results) => {
          ``;
          if (err) return res.cc(err);
          results.forEach((teacher) => {
            if (teacher.recent_ratings) {
              const ratings = JSON.parse(teacher.recent_ratings);
              const ratingsObj = ratings.map((rating) => {
                const ratingObj = isJsonString(rating)
                  ? JSON.parse(rating)
                  : rating;
                return {
                  id: ratingObj.id,
                  date: ratingObj.date,
                  rating: ratingObj.rating,
                  content: ratingObj.content,
                };
              });
              if (ratingsObj.length === 1 && ratingsObj[0].id === null) {
                teacher.recent_ratings = [];
              } else {
                teacher.recent_ratings = ratingsObj;
              }
            } else {
              teacher.recent_ratings = [];
            }
            teacher.recent_ratings = teacher.recent_ratings.reverse();
            teacher.courses = teacher.courses ? teacher.courses.split(",") : [];
          });
          res.send({
            status: 0,
            message: "获取成功",
            data: {
              totalPage: Math.ceil(total / Number(pagesize)),
              list: results,
            },
          });
        }
      );
    }
  );
};

// 根据教师ID查询
exports.getDetailById = (req, res) => {
  const { id } = req.query;
  const sql = "select * from teachers where id = ?";
  db.query(sql, [id], (err, results) => {
    if (err) return res.cc(err);
    if (results.length === 0) return res.cc("教师不存在");
    let teacherData = results[0];
    teacherData.courses = teacherData.courses
      ? teacherData.courses.split(",")
      : [];

    res.send({
      status: 0,
      message: "获取成功",
      data: teacherData,
    });
  });
};
