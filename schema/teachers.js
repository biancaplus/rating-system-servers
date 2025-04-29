const Joi = require("joi");

// 定义验证规则
const notEmpty = Joi.string()
  .pattern(/^(?!\s*$).+/)
  .required();

exports.add_schema = Joi.object({
  name: notEmpty.error(new Error("名称必传且为非空字符")),
  faculty: notEmpty.error(new Error("学院必传且为非空字符")),
  title: notEmpty.error(new Error("职称必传且为非空字符")),
}).unknown(true);

exports.update_schema = Joi.object({
  id: Joi.number().required().error(new Error("id必传且为非空字符")),
  name: notEmpty.error(new Error("名称必传且为非空字符")),
  faculty: notEmpty.error(new Error("学院必传且为非空字符")),
  title: notEmpty.error(new Error("职称必传且为非空字符")),
}).unknown(true);
