const express = require("express");
const router = express.Router();
const ratingsHandler = require("../router_handler/ratings");
const { add_schema } = require("../schema/ratings");
const validate = require("../schema/validate");

// 新增
router.post("/add", validate(add_schema), ratingsHandler.add);

// 查询
router.get("/getListByTeacherId", ratingsHandler.getListByTeacherId);

// 查询最新的条数
router.get("/getListByCount", ratingsHandler.getListByCount);

// 根据教师ID获取评分分布情况
router.get("/getRatingDistribution", ratingsHandler.getRatingDistribution);

module.exports = router;
