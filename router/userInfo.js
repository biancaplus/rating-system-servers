const express = require("express");
const router = express.Router();
const userInfoHandler = require("../router_handler/userInfo");
const validate = require("../schema/validate");
const { update_password_schema } = require("../schema/user");

// 获取用户信息
router.get("/getInfo", userInfoHandler.getUserInfo);

// 更新用户密码
router.post("/updatePwd", userInfoHandler.updatePassword);

module.exports = router;
