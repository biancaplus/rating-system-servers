const express = require("express");
const router = express.Router();
const ratingsHandler = require("../router_handler/ratings");
const { add_schema } = require("../schema/ratings");
const validate = require("../schema/validate");

// 新增
router.post("/add", validate(add_schema), ratingsHandler.add);

module.exports = router;
