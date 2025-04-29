const Joi = require("joi");

exports.add_schema = Joi.object({
  rating: Joi.number()
    .integer()
    .min(1)
    .max(5)
    .required()
    .error(new Error("评分必传且为1-5的整数")),
  teacher_id: Joi.number().integer().required().error(new Error("教师ID必传")),
}).unknown(true);
