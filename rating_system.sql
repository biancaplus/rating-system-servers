-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主机： 127.0.0.1
-- 生成日期： 2025-04-29 16:25:51
-- 服务器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

DELIMITER $$
--
-- 存储过程
--
CREATE PROCEDURE `add_rating` (IN `in_rating` INT(11), IN `in_content` VARCHAR(10000), IN `in_teacher` INT(10))  MODIFIES SQL DATA BEGIN
  INSERT INTO `rating_system`.`ratings` (`rating`, `content`, `teacher_id`) VALUES (in_rating, in_content, in_teacher);
  UPDATE `rating_system`.`teachers` AS dist,
  (SELECT COUNT(teacher_id) AS tic, AVG(rating) AS avr FROM `rating_system`.`ratings` WHERE teacher_id = in_teacher) AS rts,
  (SELECT COUNT(teacher_id) AS tic FROM `rating_system`.`ratings` WHERE content IS NOT NULL AND content != '' AND teacher_id = in_teacher) AS rtsc
  SET dist.rating = ROUND(rts.avr,1),
  dist.rating_count = rts.tic,
  dist.reviews_count = rtsc.tic
  WHERE
    dist.id = in_teacher;
END$$

--
-- 函数
--
CREATE AGGREGATE FUNCTION `JSON_ARRAYAGG`(next_value TEXT) RETURNS text CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN  

 DECLARE json TEXT DEFAULT '[""]'$$

DELIMITER ;

-- --------------------------------------------------------

--
-- 表的结构 `ratings`
--

CREATE TABLE `ratings` (
  `id` int(10) UNSIGNED NOT NULL,
  `date` datetime DEFAULT current_timestamp() COMMENT '评分时间',
  `rating` int(11) DEFAULT NULL COMMENT '评分',
  `content` varchar(10000) DEFAULT NULL COMMENT '评论内容',
  `teacher_id` int(10) UNSIGNED DEFAULT NULL COMMENT '教师id'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `ratings`
--

INSERT INTO `ratings` (`id`, `date`, `rating`, `content`, `teacher_id`) VALUES
(1, '2025-04-15 10:12:34', 5, '张教授的算法课让我大开眼界，他总能用生活案例解释复杂概念，作业批改细致到每行代码，真正的大师风范！', 1),
(2, '2025-04-12 05:13:37', 4, '机器学习课上教授的工业项目经验分享太宝贵了，连谷歌工程师都来旁听他的前沿技术解析，受益匪浅。', 1),
(3, '2024-12-04 10:20:24', 4, '数据结构课板书堪比教科书，推导红黑树时那种庖丁解牛般的讲解，让我第一次感受到算法的艺术性。', 1),
(4, '2025-01-20 10:20:52', 5, '教授凌晨两点还在回复我的论文疑问，他说的\'算法决定下限，工程思维决定上限\'成了我的座右铭。', 1),
(5, '2023-07-21 10:21:25', 5, '小组项目遇到瓶颈时，教授用十分钟就帮我们重构了神经网络模型，这种实战能力让人叹服。', 1),
(6, '2025-04-22 10:22:10', 5, '李老师吟诵《春江花月夜》时整个教室都安静了，他能从月相变化讲出唐诗中的天文智慧，太震撼了！', 2),
(8, '2025-04-11 20:36:18', 5, '去年在老师指导下完成的东坡词研究拿了省奖，他连注释里标点符号的考证都亲自修改了七稿。', 2),
(9, '2024-05-12 10:00:00', 4, '总能用现代段子解读古诗意境，把\'停车坐爱枫林晚\'讲成唐代自驾游攻略，笑着笑着就背会了全集。', 2),
(34, '2025-04-28 16:19:17', 3, '课程内容很高深，但讲课节奏有点快，基础薄弱的同学容易跟不上，建议多加点基础铺垫。', 1),
(44, '2025-04-28 17:20:53', 3, '项目作业难度较大，虽然能学到东西，但经常需要熬夜，希望能平衡下工作量。', 1),
(46, '2025-04-28 17:56:31', 3, '学术水平毋庸置疑，但PPT文字太多，如果能多些图表或案例演示会更生动。', 1),
(48, '2025-04-28 17:58:24', 3, '课后答疑时间比较固定，有时候遇到问题不能及时得到解答，希望增加灵活答疑渠道。', 1),
(49, '2025-04-28 17:58:37', 3, '理论讲得很透彻，但希望多分享一些行业最新动态，比如大模型的实际应用案例。', 1),
(50, '2025-04-28 17:58:51', 2, '上课互动较少，基本都是单向输出，课堂气氛有点沉闷，容易走神。', 1),
(51, '2025-04-28 17:58:58', 2, '作业批改反馈不够详细，有时候只给分数没有具体改进建议，学习效果打折扣。', 1),
(52, '2025-04-28 17:59:05', 1, '课程安排偏重算法理论，实际代码实践环节较少，对想找工作的同学帮助有限。', 1),
(53, '2025-04-29 13:20:06', 5, '老师书房向我们开放，三万册藏书随便借阅，每本眉批都是学术珍宝，这种胸襟让学生感动。', 2),
(54, '2025-04-29 13:20:22', 5, '带我们实地考察西安碑林时，他摸着颜真卿真迹讲解书法演变的样子，比《百家讲坛》还精彩十倍。', 2),
(55, '2025-04-29 13:20:42', 5, '王老师把外卖平台定价策略做成课堂游戏，三周就让我搞懂了之前学不会的弹性系数公式，YYDS！', 3),
(56, '2025-04-29 13:20:53', 5, '用奶茶店经营数据教计量经济学，连R语言代码都手把手调试，作业批注比论文还详细，这样的老师请来一打！', 3),
(57, '2025-04-29 13:21:06', 5, '凌晨发问卷数据给他，醒来发现凌晨三点回复的修改建议，还附了最新的长三角经济分析报告参考。', 3),
(58, '2025-04-29 13:21:16', 5, '把发改委真实项目拆解成小组课题，我们做的开发区产业规划居然被地方政府采用了，成就感爆棚！', 3),
(59, '2025-04-29 13:21:36', 5, '毕业答辩前他陪我们通宵改PPT，咖啡喝到第五杯时突然说\'其实星巴克定价就是三级价格歧视的典型案例\'...规划居然被地方政府采用了，成就感爆棚！', 3),
(60, '2025-04-29 13:22:06', 5, '在附属医院跟诊时，赵老师仅凭听诊就判断出教科书没写的肺动脉变异，后来手术证实完全正确，神乎其技！', 4),
(61, '2025-04-29 13:22:14', 5, '临床诊断学教我们触诊技巧，他蒙着眼能摸出模拟人肝脏0.5cm的肿块，说这是\'二十年练就的指尖CT\'。', 4),
(62, '2025-04-29 13:22:24', 5, '把枯燥的医学统计讲成破案过程，用连环杀手侧写案例教回归分析，连数学渣都听得津津有味。', 4),
(63, '2025-04-29 13:22:33', 5, '疫情期间带我们开发的患者分诊AI模型，现在还在社区医院使用，他说\'好医生要有工程师思维\'。', 4),
(64, '2025-04-29 13:22:42', 5, '有次急诊实习遇到罕见病例，他半夜赶来时白大褂下还穿着睡衣，却三分钟就梳理出诊疗方案，太稳了！', 4),
(65, '2025-04-29 13:22:53', 5, '钱老师带我们在美术馆临摹时，突然掀开西装露出梵高同款向日葵衬衫，说\'要先成为作品才能理解艺术\'。', 5),
(66, '2025-04-29 13:23:02', 5, '他修改画作从不直接动笔，而是用激光笔指出问题区域，培养出的观察力让我速写水平三个月翻倍。', 5),
(67, '2025-04-29 13:23:12', 5, '把枯燥的美术史讲成侦探剧，从达芬奇手稿里的购物清单推导文艺复兴时期的颜料化学成分，绝了！', 5),
(68, '2025-04-29 13:23:20', 5, '毕业展时他穿着我们集体创作的涂鸦西装致辞，说这是\'最珍贵的教授礼服\'，台下家长全在抹眼泪。', 5),
(69, '2025-04-29 13:23:28', 5, '带学生策展时连消防通道标识都要做成装置艺术，这种极致态度影响我拿到了伦敦艺术大学offer。', 5),
(70, '2025-04-29 13:23:40', 5, '孙教授拆解工业机器人时，螺丝刀在他手里像手术刀般精准，说\'装配间隙要精确到呼吸的振幅\'。', 6),
(71, '2025-04-29 13:23:49', 5, '把实验室变成汽车生产线，我们组装的机械臂真的给宝马工厂做了演示，这种实战教学太硬核了！', 6),
(72, '2025-04-29 13:23:56', 5, '六十岁还能编程到凌晨，说\'你们睡觉时KUKA机器人正在迭代算法\'，这种激情让学生自惭形秽。', 6),
(73, '2025-04-29 13:24:04', 5, '带本科生参赛的作品直接转化成专利，他坚持把学生名字写在第一发明人，说\'这是学术传承\'。', 6),
(74, '2025-04-29 13:24:13', 5, '去年冬天他蹲在车间给我们演示液压传动，油污弄脏了院士奖章也毫不在意，这才是真正的工匠精神！', 6),
(75, '2025-04-29 13:24:35', 4, '学识渊博，但讲课偶尔会跑题，从唐诗突然跳到宋代理学，笔记有点难整理。', 2),
(76, '2025-04-29 13:24:43', 4, '对论文要求极其严格，连标点符号都要纠正，虽然严谨但压力确实大。', 2),
(77, '2025-04-29 13:24:55', 3, '推荐的参考书单很棒，但数量太多，一个学期根本看不完，希望突出重点书目。', 2),
(78, '2025-04-29 13:25:05', 3, '课堂讨论时容易陷入学术争论，有时会占用太多授课时间。', 2),
(79, '2025-04-29 13:25:13', 3, '对电子版作业格式要求复杂，提交系统又不太稳定，希望能简化流程。', 2),
(80, '2025-04-29 13:25:23', 1, '太过推崇古典文学，对现当代作品评价偏保守，视野可以更开放些。', 2),
(81, '2025-04-29 13:25:33', 1, '考勤过于严格，因病请假两次就被扣平时分，不够人性化。', 2),
(82, '2025-04-29 13:25:43', 2, '小组汇报时经常打断发言，会让学生紧张得忘词，建议多些耐心。', 2),
(83, '2025-04-29 13:25:58', 2, '课程大纲变动频繁，有次临近期中考试突然增加新内容，准备措手不及。', 3),
(84, '2025-04-29 13:26:06', 2, '分组作业时放任自由组队，导致部分同学抱大腿，建议合理分配成员。', 3),
(85, '2025-04-29 13:26:16', 1, '上课时接听学术合作电话次数较多，虽然理解但确实影响课堂连贯性。', 3),
(86, '2025-04-29 13:26:32', 3, '课外活动组织得多是优点，但有些与课程关联性不强，时间安排可以更合理。', 3),
(87, '2025-04-29 13:26:40', 3, '对作业数据要求太具体，比如必须用2023年GDP数据，查找起来耗时。', 3),
(88, '2025-04-29 13:26:53', 4, 'R语言操作演示很实用，但教室电脑配置低，经常卡顿影响进度。', 3),
(89, '2025-04-29 13:27:01', 4, '方言口音偶尔会影响听讲，关键术语建议板书强调下。', 3),
(90, '2025-04-29 13:27:10', 4, '案例教学很有趣，但经济学公式推导部分讲得有点快，需要课后花时间消化。', 3),
(91, '2025-04-29 13:27:25', 4, '临床经验非常丰富，但医学统计部分用专业软件演示时，操作步骤讲得太快。', 4),
(92, '2025-04-29 13:27:33', 4, '病例分析课很棒，不过希望多安排些常见病案例，罕见病对初学者难度偏高。', 4),
(93, '2025-04-29 13:27:43', 3, '上课会突然点名提问，虽然能督促学习但精神压力比较大。', 4),
(94, '2025-04-29 13:27:52', 4, '推荐的英文文献很有价值，但对英语差的同学不太友好，建议提供中文摘要。', 4),
(95, '2025-04-29 13:28:05', 3, '实验室设备比较老旧，有些解剖模型破损严重，影响观察学习效果。', 4),
(96, '2025-04-29 13:28:15', 2, '门诊实习时让学生站旁边看三小时却不讲解，教学效率有待提高。', 4),
(97, '2025-04-29 13:28:28', 1, '把课程PPT设为保密资料不让拷贝，复习时只能手抄重点很不方便。', 4),
(98, '2025-04-29 13:28:37', 1, '对迟到零容忍，但自己因手术晚到半小时却不补课，有点双标。', 4),
(99, '2025-04-29 13:28:58', 4, '艺术见解独到，但有时评价作品过于主观，希望能更包容不同风格。', 5),
(100, '2025-04-29 13:29:08', 3, '外出写生安排太多，下雨天也不调整计划，画材经常被淋湿。', 5),
(101, '2025-04-29 13:29:20', 4, '对传统技法要求严格虽是好事，但限制了我们实验新媒体创作的自由度。', 5),
(102, '2025-04-29 13:29:32', 3, '策展课干货很多，但分组工作时总让班长承担主要任务，分工不太均衡。', 5),
(103, '2025-04-29 13:29:44', 4, '个人艺术风格强烈，导致学生作品容易趋同化，建议多鼓励个性表达。', 5),
(104, '2025-04-29 13:29:57', 2, '经常临时变更作业主题，上周通知的油画作业突然改成行为艺术，准备不及。', 5),
(105, '2025-04-29 13:30:08', 1, '对学生作品点评时爱用\'灵气不足\'这类抽象评价，缺乏具体改进建议。', 5),
(106, '2025-04-29 13:30:16', 1, '把教学时间用来推广自己的画展，有次整节课都在发展览宣传单。', 5),
(107, '2025-04-29 13:30:33', 1, '把研究生当免费劳动力，让我们帮他公司的项目画图纸却不给任何补贴。', 6),
(108, '2025-04-29 13:30:41', 1, '机器人比赛指导明显偏向保研生，对其他同学敷衍了事。', 6),
(109, '2025-04-29 13:30:51', 2, '上课时突然检查笔记并计入成绩，这种突袭式考核方式不合理。', 6),
(110, '2025-04-29 13:31:00', 2, '喜欢早晨8点上课，但对住校外的同学很不友好，出勤率受影响。', 6),
(111, '2025-04-29 13:31:14', 3, '课程内容偏重传统机械，对3D打印等新技术涉及较少，可以适当更新。', 6),
(112, '2025-04-29 13:31:22', 3, '项目指导时更关注结果，对中间过程遇到的问题解答不够耐心。', 6),
(113, '2025-04-29 13:31:35', 3, '实验室安全管理太严格，连用个电烙铁都要签三级审批，影响实操效率。', 6),
(114, '2025-04-29 13:31:48', 4, '工程经验没得说，但讲课习惯用行业黑话，初学者经常听不懂术语。', 6),
(115, '2025-04-29 13:35:41', 5, '', 1),
(116, '2025-04-29 13:36:48', 5, '', 1),
(117, '2025-04-29 13:37:46', 5, '', 1),
(118, '2025-04-29 13:39:23', 5, '', 1),
(119, '2025-04-29 13:39:36', 5, '', 2);

-- --------------------------------------------------------

--
-- 表的结构 `teachers`
--

CREATE TABLE `teachers` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `faculty` varchar(255) DEFAULT NULL COMMENT '所属学院',
  `title` varchar(255) DEFAULT NULL COMMENT '职称',
  `rating` float DEFAULT 0 COMMENT '总评分',
  `rating_count` int(11) DEFAULT 0 COMMENT '评分人数',
  `reviews_count` int(11) DEFAULT 0 COMMENT '评论人数',
  `courses` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT '课程列表',
  `introduction` varchar(10000) DEFAULT NULL COMMENT '个人简介',
  `avatar` varchar(1000) DEFAULT NULL COMMENT '头像'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `teachers`
--

INSERT INTO `teachers` (`id`, `name`, `faculty`, `title`, `rating`, `rating_count`, `reviews_count`, `courses`, `introduction`, `avatar`) VALUES
(1, '张三', '计算机科学与技术学院', '教授', 3.7, 17, 13, '数据结构与算法,人工智能导论,机器学习', '清华大学计算机系博士，人工智能领域专家，主持国家自然科学基金项目3项，发表SCI论文20余篇，擅长将前沿算法应用于实际工业场景。', NULL),
(2, '李四', '文学院', '副教授', 3.6, 14, 13, '中国古代文学,唐宋诗词研究,文学批评方法', '北京大学文学博士，专注唐宋文学研究20年，出版《唐宋诗风流变》等专著3部，曾获教育部人文社科优秀成果奖。', NULL),
(3, '王五', '经济与管理学院', '讲师', 3.7, 13, 13, '微观经济学,计量经济学,产业经济学', '伦敦政治经济学院硕士，研究产业经济与区域发展，参与多项地方政府规划项目，教学风格生动贴近实际案例。', NULL),
(4, '赵六', '医学院', '教授', 3.6, 13, 13, '内科学,临床诊断学,医学统计学', '协和医学院博士，主任医师，深耕心血管疾病诊疗15年，创新性提出\'阶梯式治疗方案\'，临床经验丰富。', NULL),
(5, '孙八', '机械工程学院', '教授', 3.6, 13, 13, '机械设计基础,机器人学,先进制造技术', '国家杰出青年科学基金获得者，主持研发的工业机器人系统已应用于汽车制造领域，获国家科技进步二等奖。', NULL),
(6, '钱七', '艺术学院', '副教授', 3.4, 13, 13, '西方美术史,油画技法,艺术策展', '巴黎国立高等美术学院访问学者，作品入选全国美展，擅长将传统技法与当代艺术观念融合，培养多名青年艺术家。', NULL),
(7, '陈九', '数学院', '讲师', 1.1, 10, 11, 'a,b,c', NULL, NULL),
(8, '吴十', '经济与管理学院', '讲师', 1.1, 10, 11, '国际政治学', NULL, NULL),
(9, '武十一', '经济与管理学院', '副教授', 1.1, 10, 11, NULL, '', NULL),
(11, 'jihd', 'dddd', 'ffff', 1.1, 10, 11, NULL, NULL, NULL),
(12, 'abfdf', 'sda', 'sda', 2, 1, 0, NULL, NULL, NULL),
(13, '阿林', '大苏打', '手动', 0, 0, 0, NULL, NULL, NULL),
(14, '武一', '发到付', '法', 4, 1, 0, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- 表的结构 `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

--
-- 转存表中的数据 `users`
--

INSERT INTO `users` (`id`, `username`, `password`) VALUES
(1, 'admin', '$2b$10$P.zgZHxRER4c1WiFxNoG0uFQFpb.b2PkBEaDXU3jAEvQi2jSqS04q');

--
-- 转储表的索引
--

--
-- 表的索引 `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`) USING BTREE,
  ADD KEY `FK_TEACHER_ID` (`teacher_id`);

--
-- 表的索引 `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 表的索引 `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`) USING BTREE;

--
-- 在导出的表使用AUTO_INCREMENT
--

--
-- 使用表AUTO_INCREMENT `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=120;

--
-- 使用表AUTO_INCREMENT `teachers`
--
ALTER TABLE `teachers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- 使用表AUTO_INCREMENT `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 限制导出的表
--

--
-- 限制表 `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `FK_TEACHER_ID` FOREIGN KEY (`teacher_id`) REFERENCES `teachers` (`id`);
COMMIT;

