const express = require("express");
const router = express.Router();
const teacherInfoHandler = require("../router_handler/teacherInfo");
const { add_update_schema } = require("../schema/teachers");
const validate = require("../schema/validate");

// 查询
router.get("/list", teacherInfoHandler.getList);

// 根据教师ID查询
router.get("/getDetailById", teacherInfoHandler.getDetailById);

module.exports = router;
