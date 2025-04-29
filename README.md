# 教师评分系统后台

> _一个基于 Express 的教师评价后台服务_

对应的前台项目：https://github.com/biancaplus/rating-system

![example](README.assets/example.png)

## ✨ 功能特性

- 功能点 1 - JWT 身份验证
- 功能点 2 - Mysql 数据增删改查
- 功能点 3 - Swagger 文档支持
- 功能点 4 - 多语言

## 🚀 快速开始

- node app.js
- nodemon app.js

### 前置条件

- Node.js `>=18.0.0`
- npm/yarn/pnpm
- 数据库（MySQL、MariaDB）

### 安装依赖

```bash
npm install
# 或
yarn install
```

### 导入示例数据
```bash
mysql -u username -p database_name < rating_system.sql
```