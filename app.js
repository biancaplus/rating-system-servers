const express = require("express");
const app = express();
const { expressjwt } = require("express-jwt");
const config = require("./config");
const swaggerJsdoc = require("swagger-jsdoc");
const swaggerUi = require("swagger-ui-express");
const fs = require("fs");
const yaml = require("js-yaml");
const swaggerDefinition = yaml.load(
  fs.readFileSync("./swagger-definitions.yaml", "utf8")
);

// 配置解析表单数据的中间件，解析application/x-www-form-urlencoded格式的表单数据
app.use(express.urlencoded({ limit: "3mb", extended: false }));

// 响应数据的中间件(封装res.cc函数，在路由之前，也要在jwt解析之前，否则报错获取不到该函数)
app.use((req, res, next) => {
  res.cc = (err, status = 1) => {
    res.send({ status, message: err instanceof Error ? err.message : err });
  };
  next();
});

// 在路由之前配置解析Token的中间件
app.use(
  expressjwt({
    secret: config.jwtSecretKey, // 配置 JWT 的密钥
    algorithms: ["HS256"], // 明确指定算法
  }).unless({
    path: [
      /^\/api\/user\//,
      /^\/api\/teacherInfo\//,
      /^\/api\/ratingInfo\//,
      /^\/swagger\//,
    ], // 排除开头的路由
  })
);

// 用户路由模块
const userRouter = require("./router/user");
app.use("/api/user", userRouter);

// 用户信息路由模块
const userInfoRouter = require("./router/userInfo");
app.use("/api/userInfo", userInfoRouter);

// 教师路由模块
const teachersRouter = require("./router/teachers");
app.use("/api/teachers", teachersRouter);

// 教师信息路由模块
const teacherInfoRouter = require("./router/teacherInfo");
app.use("/api/teacherInfo", teacherInfoRouter);

// 评分路由模块
const ratingsRouter = require("./router/ratings");
app.use("/api/ratings", ratingsRouter);

// 评分信息路由模块
const ratingInfoRouter = require("./router/ratingInfo");
app.use("/api/ratingInfo", ratingInfoRouter);

// if (process.env.ENABLE_REGISTRATION === "true") {
//   const registrationRouter = require("./router/registration");
//   app.use("/api/registration", registrationRouter);
// }

// 定义错误级别的中间件
app.use((err, req, res, next) => {
  // Token 过期
  if (err.name === "UnauthorizedError" && err.message.includes("expired")) {
    return res
      .status(401)
      .json({ code: 401, message: "Token 已过期，请重新登录" });
  }

  // 无效 Token（格式错误、伪造 Token 等）
  if (err.name === "UnauthorizedError") {
    return res
      .status(401)
      .json({ code: 401, message: "无效的Token，请重新登录" });
  }

  // 其他错误
  res
    .status(500)
    .json({ code: 500, message: "服务器内部错误", error: err.message });
});

// Swagger 配置
const options = {
  swaggerDefinition,
  // 指定包含路由注释的文件路径
  apis: ["./router/*.js"],
};
const specs = swaggerJsdoc(options);

// 设置 Swagger 路由
app.use("/swagger/docs", swaggerUi.serve, swaggerUi.setup(specs));

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
