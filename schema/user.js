const Joi = require("joi");

// 定义验证规则
const username = Joi.string()
  .alphanum()
  .min(3)
  .max(10)
  .required()
  .error(new Error("用户名为a-z、A-Z、0-9的3-10位字符"));
const password = Joi.string()
  .pattern(/^[\S]{6,12}$/)
  .required()
  .error(new Error("密码为6-12位的非空字符"));

// 注册和登录的规则
exports.register_login_schema = Joi.object({
  username,
  password,
});

// 更新用户密码的规则
exports.update_password_schema = Joi.object({
  oldPwd: password,
  newPwd: Joi.string()
    .pattern(/^[\S]{6,12}$/)
    .not(Joi.ref("oldPwd"))
    .required()
    .error(new Error("密码为6-12位的非空字符且新旧密码不能相同")),
});
