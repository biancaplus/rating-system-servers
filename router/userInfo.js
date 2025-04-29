const express = require("express");
const router = express.Router();
const userInfoHandler = require("../router_handler/userInfo");
const validate = require("../schema/validate");
const { update_password_schema } = require("../schema/user");

// 获取用户信息
router.get("/getInfo", userInfoHandler.getUserInfo);

// 更新用户密码(此处有bug，修改密码后，未过期的旧token依然有效，需要再处理)
router.post(
  "/updatePwd",
  validate(update_password_schema),
  userInfoHandler.updatePassword
);

module.exports = router;
