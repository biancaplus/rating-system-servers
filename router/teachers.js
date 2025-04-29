const express = require("express");
const router = express.Router();
const teachersHandler = require("../router_handler/teachers");
const { add_schema, update_schema } = require("../schema/teachers");
const validate = require("../schema/validate");

// 新增
router.post("/add", validate(add_schema), teachersHandler.add);

// 修改
router.post("/update", validate(update_schema), teachersHandler.update);

// 删除
router.get("/delete", teachersHandler.delete);

module.exports = router;
