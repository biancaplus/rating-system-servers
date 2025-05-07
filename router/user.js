const express = require("express");
const router = express.Router();
const userHandler = require("../router_handler/user");
const { register_login_schema } = require("../schema/user");
const validate = require("../schema/validate");

/**
 * 注册用户
 * @route POST /user/register
 * @group 用户模块 - 用户注册
 * @param {string} username.query.required - username or email - eg: user@domain/用户账号
 * @param {string} password.query.required - user's password/用户密码.
 * @returns {object} 200 - {code:200,msg:'ok',data:null}
 * @returns {Error}  default - {code:500,msg:'error',data:null}
 */
router.post("/register", userHandler.register);

router.post("/login", userHandler.login);

module.exports = router;
