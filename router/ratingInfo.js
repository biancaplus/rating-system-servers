const express = require("express");
const router = express.Router();
const ratingInfoHandler = require("../router_handler/ratingInfo");

// 查询
router.get("/getListByTeacherId", ratingInfoHandler.getListByTeacherId);

// 查询最新的条数
router.get("/getListByCount", ratingInfoHandler.getListByCount);

// 根据教师ID获取评分分布情况
router.get("/getRatingDistribution", ratingInfoHandler.getRatingDistribution);

module.exports = router;
