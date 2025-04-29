// 表单验证请求体
module.exports = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body);
    if (error) {
      return res.cc(error.message);
    }
    next();
  };
};
