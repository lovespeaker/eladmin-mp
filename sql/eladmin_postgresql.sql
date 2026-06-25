-- ============================================
-- PostgreSQL DDL 转换自 eladmin.sql (MariaDB)
-- 转换日期: 2025-06-24
-- ============================================

-- 注意：PostgreSQL 中索引名和约束名是 schema 级别全局唯一的，
-- 已将所有索引和约束名加表名前缀以避免冲突。

-- ----------------------------
-- Table structure for code_column
-- ----------------------------
DROP TABLE IF EXISTS code_column CASCADE;
CREATE TABLE code_column (
  column_id BIGSERIAL PRIMARY KEY,
  table_name VARCHAR(180),
  column_name VARCHAR(255),
  column_type VARCHAR(255),
  dict_name VARCHAR(255),
  extra VARCHAR(255),
  form_show BOOLEAN,
  form_type VARCHAR(255),
  key_type VARCHAR(255),
  list_show BOOLEAN,
  not_null BOOLEAN,
  query_type VARCHAR(255),
  remark VARCHAR(255)
);
CREATE INDEX idx_code_column_table_name ON code_column (table_name);
COMMENT ON TABLE code_column IS '代码生成字段信息存储';

-- ----------------------------
-- Table structure for code_config
-- ----------------------------
DROP TABLE IF EXISTS code_config CASCADE;
CREATE TABLE code_config (
  config_id BIGSERIAL PRIMARY KEY,
  table_name VARCHAR(255),
  author VARCHAR(255),
  cover BOOLEAN,
  module_name VARCHAR(255),
  pack VARCHAR(255),
  path VARCHAR(255),
  api_path VARCHAR(255),
  prefix VARCHAR(255),
  api_alias VARCHAR(255)
);
CREATE INDEX idx_code_config_table_name ON code_config (table_name);
COMMENT ON TABLE code_config IS '代码生成器配置';



-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS sys_dept CASCADE;
CREATE TABLE sys_dept (
  dept_id BIGSERIAL PRIMARY KEY,
  pid BIGINT,
  sub_count INTEGER DEFAULT 0,
  name VARCHAR(255) NOT NULL,
  dept_sort INTEGER DEFAULT 999,
  enabled BOOLEAN NOT NULL,
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP
);
CREATE INDEX idx_sys_dept_pid ON sys_dept (pid);
CREATE INDEX idx_sys_dept_enabled ON sys_dept (enabled);
COMMENT ON TABLE sys_dept IS '部门';

INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (2, 7, 1, '研发部', 3, TRUE, 'admin', 'admin', '2019-03-25 09:15:32', '2020-08-02 14:48:47');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (5, 7, 0, '运维部', 4, TRUE, 'admin', 'admin', '2019-03-25 09:20:44', '2020-05-17 14:27:27');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (6, 8, 0, '测试部', 6, TRUE, 'admin', 'admin', '2019-03-25 09:52:18', '2020-06-08 11:59:21');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (7, NULL, 2, '华南分部', 0, TRUE, 'admin', 'admin', '2019-03-25 11:04:50', '2020-06-08 12:08:56');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (8, NULL, 2, '华北分部', 1, TRUE, 'admin', 'admin', '2019-03-25 11:04:53', '2020-05-14 12:54:00');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (15, 8, 0, 'UI部门', 7, TRUE, 'admin', 'admin', '2020-05-13 22:56:53', '2020-05-14 12:54:13');
INSERT INTO sys_dept (dept_id, pid, sub_count, name, dept_sort, enabled, create_by, update_by, create_time, update_time) VALUES (17, 2, 0, '研发一组', 999, TRUE, 'admin', 'admin', '2020-08-02 14:49:07', '2020-08-02 14:49:07');
SELECT setval('sys_dept_dept_id_seq', (SELECT COALESCE(MAX(dept_id), 1) FROM sys_dept));

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS sys_dict CASCADE;
CREATE TABLE sys_dict (
  dict_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255),
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP
);
COMMENT ON TABLE sys_dict IS '数据字典';

INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (1, 'user_status', '用户状态', NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (4, 'dept_status', '部门状态', NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict (dict_id, name, description, create_by, update_by, create_time, update_time) VALUES (5, 'job_status', '岗位状态', NULL, 'admin', '2019-10-27 20:31:36', '2025-01-14 15:48:29');
SELECT setval('sys_dict_dict_id_seq', (SELECT COALESCE(MAX(dict_id), 1) FROM sys_dict));

-- ----------------------------
-- Table structure for sys_dict_detail
-- ----------------------------
DROP TABLE IF EXISTS sys_dict_detail CASCADE;
CREATE TABLE sys_dict_detail (
  detail_id BIGSERIAL PRIMARY KEY,
  dict_id BIGINT,
  label VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  dict_sort INTEGER,
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP
);
CREATE INDEX idx_sys_dict_detail_dict_id ON sys_dict_detail (dict_id);
COMMENT ON TABLE sys_dict_detail IS '数据字典详情';

INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (1, 1, '激活', 'true', 1, NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (2, 1, '禁用', 'false', 2, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (3, 4, '启用', 'true', 1, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (4, 4, '停用', 'false', 2, NULL, NULL, '2019-10-27 20:31:36', NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (5, 5, '启用', 'true', 1, NULL, NULL, NULL, NULL);
INSERT INTO sys_dict_detail (detail_id, dict_id, label, value, dict_sort, create_by, update_by, create_time, update_time) VALUES (6, 5, '停用', 'false', 2, NULL, NULL, '2019-10-27 20:31:36', NULL);
SELECT setval('sys_dict_detail_detail_id_seq', (SELECT COALESCE(MAX(detail_id), 1) FROM sys_dict_detail));

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS sys_job CASCADE;
CREATE TABLE sys_job (
  job_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(180) NOT NULL,
  enabled BOOLEAN NOT NULL,
  job_sort INTEGER,
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP,
  CONSTRAINT uniq_sys_job_name UNIQUE (name)
);
CREATE INDEX idx_sys_job_enabled ON sys_job (enabled);
COMMENT ON TABLE sys_job IS '岗位';

INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (8, '人事专员', TRUE, 3, NULL, NULL, '2019-03-29 14:52:28', NULL);
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (10, '产品经理', TRUE, 4, NULL, NULL, '2019-03-29 14:55:51', NULL);
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (11, '全栈开发', TRUE, 2, NULL, 'admin', '2019-03-31 13:39:30', '2020-05-05 11:33:43');
INSERT INTO sys_job (job_id, name, enabled, job_sort, create_by, update_by, create_time, update_time) VALUES (12, '软件测试', TRUE, 5, NULL, 'admin', '2019-03-31 13:39:43', '2020-05-10 19:56:26');
SELECT setval('sys_job_job_id_seq', (SELECT COALESCE(MAX(job_id), 1) FROM sys_job));

-- ----------------------------
-- Table structure for sys_log
-- ----------------------------
DROP TABLE IF EXISTS sys_log CASCADE;
CREATE TABLE sys_log (
  log_id BIGSERIAL PRIMARY KEY,
  description VARCHAR(255),
  log_type VARCHAR(10) NOT NULL,
  method VARCHAR(255),
  params TEXT,
  request_ip VARCHAR(255),
  time BIGINT,
  username VARCHAR(255),
  address VARCHAR(255),
  browser VARCHAR(255),
  exception_detail TEXT,
  create_time TIMESTAMP NOT NULL
);
CREATE INDEX idx_sys_log_create_time ON sys_log (create_time);
CREATE INDEX idx_sys_log_log_type ON sys_log (log_type);
COMMENT ON TABLE sys_log IS '系统日志';

INSERT INTO sys_log (log_id, description, log_type, method, params, request_ip, time, username, address, browser, exception_detail, create_time) VALUES (13753, '删除多个文件', 'INFO', 'me.zhengjie.rest.S3StorageController.deleteAllQiNiu()', '{"reqBodyList":[2]}', '127.0.0.1', 225, 'admin', '内网IP', 'Chrome 137', NULL, '2025-06-19 16:55:15');
SELECT setval('sys_log_log_id_seq', (SELECT COALESCE(MAX(log_id), 1) FROM sys_log));

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS sys_menu CASCADE;
CREATE TABLE sys_menu (
  menu_id BIGSERIAL PRIMARY KEY,
  pid BIGINT,
  sub_count INTEGER DEFAULT 0,
  type INTEGER,
  title VARCHAR(100),
  name VARCHAR(100),
  component VARCHAR(255),
  menu_sort INTEGER,
  icon VARCHAR(255),
  path VARCHAR(255),
  i_frame BOOLEAN,
  cache BOOLEAN DEFAULT FALSE,
  hidden BOOLEAN DEFAULT FALSE,
  permission VARCHAR(255),
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP,
  CONSTRAINT uniq_sys_menu_name UNIQUE (name),
  CONSTRAINT uniq_sys_menu_title UNIQUE (title)
);
CREATE INDEX idx_sys_menu_pid ON sys_menu (pid);
COMMENT ON TABLE sys_menu IS '系统菜单';

INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (1, NULL, 7, 0, '系统管理', NULL, NULL, 1, 'system', 'system', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2018-12-18 15:11:29', '2025-01-14 15:48:18');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (2, 1, 3, 1, '用户管理', 'User', 'system/user/index', 2, 'peoples', 'user', FALSE, FALSE, FALSE, 'user:list', NULL, NULL, '2018-12-18 15:14:44', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (3, 1, 3, 1, '角色管理', 'Role', 'system/role/index', 3, 'role', 'role', FALSE, FALSE, FALSE, 'roles:list', NULL, NULL, '2018-12-18 15:16:07', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (5, 1, 3, 1, '菜单管理', 'Menu', 'system/menu/index', 5, 'menu', 'menu', FALSE, FALSE, FALSE, 'menu:list', NULL, NULL, '2018-12-18 15:17:28', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (6, NULL, 5, 0, '系统监控', NULL, NULL, 10, 'monitor', 'monitor', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-18 15:17:48', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (7, 6, 0, 1, '操作日志', 'Log', 'monitor/log/index', 11, 'log', 'logs', FALSE, TRUE, FALSE, NULL, NULL, 'admin', '2018-12-18 15:18:26', '2020-06-06 13:11:57');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (9, 6, 0, 1, 'SQL监控', 'Sql', 'monitor/sql/index', 18, 'sqlMonitor', 'druid', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-18 15:19:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (10, NULL, 5, 0, '组件管理', NULL, NULL, 50, 'zujian', 'components', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-19 13:38:16', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (11, 10, 0, 1, '图标库', 'Icons', 'components/icons/index', 51, 'icon', 'icon', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-19 13:38:49', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (14, 36, 0, 1, '邮件工具', 'Email', 'tools/email/index', 35, 'email', 'email', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-27 10:13:09', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (15, 10, 0, 1, '富文本', 'Editor', 'components/Editor', 52, 'fwb', 'tinymce', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-27 11:58:25', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (18, 36, 1, 1, '存储管理', 'Storage', 'tools/storage/index', 34, 'qiniu', 'storage', FALSE, FALSE, FALSE, 'storage:list', NULL, NULL, '2018-12-31 11:12:15', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (19, 36, 0, 1, '支付宝工具', 'AliPay', 'tools/aliPay/index', 37, 'alipay', 'aliPay', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2018-12-31 14:52:38', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (21, NULL, 2, 0, '多级菜单', NULL, '', 900, 'menu', 'nested', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2019-01-04 16:22:03', '2020-06-21 17:27:35');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (22, 21, 2, 0, '二级菜单1', NULL, '', 999, 'menu', 'menu1', FALSE, FALSE, FALSE, NULL, NULL, 'admin', '2019-01-04 16:23:29', '2020-06-21 17:27:20');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (23, 21, 0, 1, '二级菜单2', NULL, 'nested/menu2/index', 999, 'menu', 'menu2', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-04 16:23:57', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (24, 22, 0, 1, '三级菜单1', 'Test', 'nested/menu1/menu1-1', 999, 'menu', 'menu1-1', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-04 16:24:48', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (27, 22, 0, 1, '三级菜单2', NULL, 'nested/menu1/menu1-2', 999, 'menu', 'menu1-2', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-07 17:27:32', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (28, 1, 3, 1, '任务调度', 'Timing', 'system/timing/index', 999, 'timing', 'timing', FALSE, FALSE, FALSE, 'timing:list', NULL, NULL, '2019-01-07 20:34:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (30, 36, 0, 1, '代码生成', 'GeneratorIndex', 'generator/index', 32, 'dev', 'generator', FALSE, TRUE, FALSE, NULL, NULL, NULL, '2019-01-11 15:45:55', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (32, 6, 0, 1, '异常日志', 'ErrorLog', 'monitor/log/errorLog', 12, 'error', 'errorLog', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-01-13 13:49:03', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (33, 10, 0, 1, 'Markdown', 'Markdown', 'components/MarkDown', 53, 'markdown', 'markdown', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-08 13:46:44', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (34, 10, 0, 1, 'Yaml编辑器', 'YamlEdit', 'components/YamlEdit', 54, 'dev', 'yaml', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-08 15:49:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (35, 1, 3, 1, '部门管理', 'Dept', 'system/dept/index', 6, 'dept', 'dept', FALSE, FALSE, FALSE, 'dept:list', NULL, NULL, '2019-03-25 09:46:00', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (36, NULL, 6, 0, '系统工具', NULL, '', 30, 'sys-tools', 'sys-tools', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-03-29 10:57:35', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (37, 1, 3, 1, '岗位管理', 'Job', 'system/job/index', 7, 'Steve-Jobs', 'job', FALSE, FALSE, FALSE, 'job:list', NULL, NULL, '2019-03-29 13:51:18', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (39, 1, 3, 1, '字典管理', 'Dict', 'system/dict/index', 8, 'dictionary', 'dict', FALSE, FALSE, FALSE, 'dict:list', NULL, NULL, '2019-04-10 11:49:04', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (41, 6, 0, 1, '在线用户', 'OnlineUser', 'monitor/online/index', 10, 'Steve-Jobs', 'online', FALSE, FALSE, FALSE, NULL, NULL, NULL, '2019-10-26 22:08:43', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (44, 2, 0, 2, '用户新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'user:add', NULL, NULL, '2019-10-29 10:59:46', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (45, 2, 0, 2, '用户编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'user:edit', NULL, NULL, '2019-10-29 11:00:08', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (46, 2, 0, 2, '用户删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'user:del', NULL, NULL, '2019-10-29 11:00:23', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (48, 3, 0, 2, '角色创建', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'roles:add', NULL, NULL, '2019-10-29 12:45:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (49, 3, 0, 2, '角色修改', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'roles:edit', NULL, NULL, '2019-10-29 12:46:16', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (50, 3, 0, 2, '角色删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'roles:del', NULL, NULL, '2019-10-29 12:46:51', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (52, 5, 0, 2, '菜单新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'menu:add', NULL, NULL, '2019-10-29 12:55:07', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (53, 5, 0, 2, '菜单编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'menu:edit', NULL, NULL, '2019-10-29 12:55:40', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (54, 5, 0, 2, '菜单删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'menu:del', NULL, NULL, '2019-10-29 12:56:00', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (56, 35, 0, 2, '部门新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'dept:add', NULL, NULL, '2019-10-29 12:57:09', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (57, 35, 0, 2, '部门编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'dept:edit', NULL, NULL, '2019-10-29 12:57:27', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (58, 35, 0, 2, '部门删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'dept:del', NULL, NULL, '2019-10-29 12:57:41', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (60, 37, 0, 2, '岗位新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'job:add', NULL, NULL, '2019-10-29 12:58:27', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (61, 37, 0, 2, '岗位编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'job:edit', NULL, NULL, '2019-10-29 12:58:45', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (62, 37, 0, 2, '岗位删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'job:del', NULL, NULL, '2019-10-29 12:59:04', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (64, 39, 0, 2, '字典新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'dict:add', NULL, NULL, '2019-10-29 13:00:17', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (65, 39, 0, 2, '字典编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'dict:edit', NULL, NULL, '2019-10-29 13:00:42', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (66, 39, 0, 2, '字典删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'dict:del', NULL, NULL, '2019-10-29 13:00:59', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (73, 28, 0, 2, '任务新增', NULL, '', 2, '', '', FALSE, FALSE, FALSE, 'timing:add', NULL, NULL, '2019-10-29 13:07:28', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (74, 28, 0, 2, '任务编辑', NULL, '', 3, '', '', FALSE, FALSE, FALSE, 'timing:edit', NULL, NULL, '2019-10-29 13:07:41', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (75, 28, 0, 2, '任务删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'timing:del', NULL, NULL, '2019-10-29 13:07:54', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (79, 18, 0, 2, '文件删除', NULL, '', 4, '', '', FALSE, FALSE, FALSE, 'storage:del', NULL, NULL, '2019-10-29 13:09:34', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (80, 6, 0, 1, '服务监控', 'ServerMonitor', 'monitor/server/index', 14, 'codeConsole', 'server', FALSE, FALSE, FALSE, 'monitor:list', NULL, 'admin', '2019-11-07 13:06:39', '2020-05-04 18:20:50');
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (82, 36, 0, 1, '生成配置', 'GeneratorConfig', 'generator/config', 33, 'dev', 'generator/config/:tableName', FALSE, TRUE, TRUE, '', NULL, NULL, '2019-11-17 20:08:56', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (83, 10, 0, 1, '图表库', 'Echarts', 'components/Echarts', 50, 'chart', 'echarts', FALSE, TRUE, FALSE, '', NULL, NULL, '2019-11-21 09:04:32', NULL);
INSERT INTO sys_menu (menu_id, pid, sub_count, type, title, name, component, menu_sort, icon, path, i_frame, cache, hidden, permission, create_by, update_by, create_time, update_time) VALUES (116, 36, 0, 1, '生成预览', 'Preview', 'generator/preview', 999, 'java', 'generator/preview/:tableName', FALSE, TRUE, TRUE, NULL, NULL, NULL, '2019-11-26 14:54:36', NULL);
SELECT setval('sys_menu_menu_id_seq', (SELECT COALESCE(MAX(menu_id), 1) FROM sys_menu));

-- ----------------------------
-- Table structure for sys_quartz_job
-- ----------------------------
DROP TABLE IF EXISTS sys_quartz_job CASCADE;
CREATE TABLE sys_quartz_job (
  job_id BIGSERIAL PRIMARY KEY,
  bean_name VARCHAR(255),
  cron_expression VARCHAR(255),
  is_pause BOOLEAN,
  job_name VARCHAR(255),
  method_name VARCHAR(255),
  params VARCHAR(255),
  description VARCHAR(255),
  person_in_charge VARCHAR(100),
  email VARCHAR(100),
  sub_task VARCHAR(100),
  pause_after_failure BOOLEAN,
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP
);
CREATE INDEX idx_sys_quartz_job_is_pause ON sys_quartz_job (is_pause);
COMMENT ON TABLE sys_quartz_job IS '定时任务';

INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (2, 'testTask', '0/5 * * * * ?', TRUE, '测试1', 'run1', 'test', '带参测试，多参使用json', '测试', NULL, NULL, NULL, NULL, 'admin', '2019-08-22 14:08:29', '2020-05-24 13:58:33');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (3, 'testTask', '0/5 * * * * ?', TRUE, '测试', 'run', '', '不带参测试', 'Zheng Jie', '', '6', TRUE, NULL, 'admin', '2019-09-26 16:44:39', '2020-05-24 14:48:12');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (5, 'Test', '0/5 * * * * ?', TRUE, '任务告警测试', 'run', NULL, '测试', 'test', '', NULL, TRUE, 'admin', 'admin', '2020-05-05 20:32:41', '2020-05-05 20:36:13');
INSERT INTO sys_quartz_job (job_id, bean_name, cron_expression, is_pause, job_name, method_name, params, description, person_in_charge, email, sub_task, pause_after_failure, create_by, update_by, create_time, update_time) VALUES (6, 'testTask', '0/5 * * * * ?', TRUE, '测试3', 'run2', NULL, '测试3', 'Zheng Jie', '', NULL, TRUE, 'admin', 'admin', '2020-05-05 20:35:41', '2020-05-05 20:36:07');
SELECT setval('sys_quartz_job_job_id_seq', (SELECT COALESCE(MAX(job_id), 1) FROM sys_quartz_job));

-- ----------------------------
-- Table structure for sys_quartz_log
-- ----------------------------
DROP TABLE IF EXISTS sys_quartz_log CASCADE;
CREATE TABLE sys_quartz_log (
  log_id BIGSERIAL PRIMARY KEY,
  bean_name VARCHAR(255),
  cron_expression VARCHAR(255),
  is_success BOOLEAN,
  job_name VARCHAR(255),
  method_name VARCHAR(255),
  params VARCHAR(255),
  time BIGINT,
  exception_detail TEXT,
  create_time TIMESTAMP
);
COMMENT ON TABLE sys_quartz_log IS '定时任务日志';

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS sys_role CASCADE;
CREATE TABLE sys_role (
  role_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  level INTEGER,
  data_scope VARCHAR(255),
  description VARCHAR(255),
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP,
  CONSTRAINT uniq_sys_role_name UNIQUE (name)
);
CREATE INDEX idx_sys_role_level ON sys_role (level);
COMMENT ON TABLE sys_role IS '角色表';

INSERT INTO sys_role (role_id, name, level, data_scope, description, create_by, update_by, create_time, update_time) VALUES (1, '管理员', 1, '全部', NULL, NULL, 'admin', '2018-11-23 11:04:37', '2020-08-06 16:10:24');
INSERT INTO sys_role (role_id, name, level, data_scope, description, create_by, update_by, create_time, update_time) VALUES (2, '普通用户', 2, '本级', NULL, NULL, 'admin', '2018-11-23 13:09:06', '2020-09-05 10:45:12');
SELECT setval('sys_role_role_id_seq', (SELECT COALESCE(MAX(role_id), 1) FROM sys_role));

-- ----------------------------
-- Table structure for sys_roles_depts
-- ----------------------------
DROP TABLE IF EXISTS sys_roles_depts CASCADE;
CREATE TABLE sys_roles_depts (
  role_id BIGINT NOT NULL,
  dept_id BIGINT NOT NULL,
  PRIMARY KEY (role_id, dept_id)
);
CREATE INDEX idx_sys_roles_depts_role_id ON sys_roles_depts (role_id);
CREATE INDEX idx_sys_roles_depts_dept_id ON sys_roles_depts (dept_id);
COMMENT ON TABLE sys_roles_depts IS '角色部门关联';

-- ----------------------------
-- Table structure for sys_roles_menus
-- ----------------------------
DROP TABLE IF EXISTS sys_roles_menus CASCADE;
CREATE TABLE sys_roles_menus (
  menu_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  PRIMARY KEY (menu_id, role_id)
);
CREATE INDEX idx_sys_roles_menus_menu_id ON sys_roles_menus (menu_id);
CREATE INDEX idx_sys_roles_menus_role_id ON sys_roles_menus (role_id);
COMMENT ON TABLE sys_roles_menus IS '角色菜单关联';

INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (1, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (1, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (2, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (2, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (3, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (5, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (6, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (6, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (7, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (7, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (9, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (9, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (10, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (10, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (11, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (11, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (14, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (14, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (15, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (15, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (18, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (19, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (19, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (21, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (21, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (22, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (22, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (23, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (23, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (24, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (24, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (27, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (27, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (28, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (30, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (30, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (32, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (32, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (33, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (33, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (34, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (34, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (35, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (36, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (36, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (37, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (39, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (41, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (44, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (45, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (46, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (48, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (49, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (50, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (52, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (53, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (54, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (56, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (57, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (58, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (60, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (61, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (62, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (64, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (65, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (66, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (73, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (74, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (75, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (79, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (80, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (80, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (82, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (82, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (83, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (83, 2);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (90, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (92, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (93, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (94, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (97, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (98, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (102, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (103, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (104, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (105, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (106, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (107, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (108, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (109, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (110, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (111, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (116, 1);
INSERT INTO sys_roles_menus (menu_id, role_id) VALUES (116, 2);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS sys_user CASCADE;
CREATE TABLE sys_user (
  user_id BIGSERIAL PRIMARY KEY,
  dept_id BIGINT,
  username VARCHAR(180),
  nick_name VARCHAR(255),
  gender VARCHAR(2),
  phone VARCHAR(255),
  email VARCHAR(180),
  avatar_name VARCHAR(255),
  avatar_path VARCHAR(255),
  password VARCHAR(255),
  is_admin BOOLEAN DEFAULT FALSE,
  enabled BOOLEAN,
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  pwd_reset_time TIMESTAMP,
  create_time TIMESTAMP,
  update_time TIMESTAMP,
  CONSTRAINT uniq_sys_user_email UNIQUE (email),
  CONSTRAINT uniq_sys_user_username UNIQUE (username)
);
CREATE INDEX idx_sys_user_dept_id ON sys_user (dept_id);
CREATE INDEX idx_sys_user_enabled ON sys_user (enabled);
COMMENT ON TABLE sys_user IS '系统用户';

INSERT INTO sys_user (user_id, dept_id, username, nick_name, gender, phone, email, avatar_name, avatar_path, password, is_admin, enabled, create_by, update_by, pwd_reset_time, create_time, update_time) VALUES (1, 2, 'admin', '管理员', '男', '18888888888', '201507802@qq.com', 'avatar-20250121112710866.png', '/Users/jie/Documents/work/private/eladmin-mp/~/avatar/avatar-20250121112710866.png', '{sm3}cee4b3e4e33222ccd81e0c1c1d725d0f:959694b2c16b9044b07c7397f1f981e43794bd4c89e59afde9d9a58aef6518f3', TRUE, TRUE, NULL, 'admin', '2020-05-03 16:38:31', '2018-08-23 09:11:56', '2020-09-05 10:43:31');
INSERT INTO sys_user (user_id, dept_id, username, nick_name, gender, phone, email, avatar_name, avatar_path, password, is_admin, enabled, create_by, update_by, pwd_reset_time, create_time, update_time) VALUES (2, 2, 'test', '测试', '男', '19999999999', '231@qq.com', NULL, NULL, '{sm3}cee4b3e4e33222ccd81e0c1c1d725d0f:959694b2c16b9044b07c7397f1f981e43794bd4c89e59afde9d9a58aef6518f3', FALSE, TRUE, 'admin', 'admin', '2025-01-21 15:25:12', '2020-05-05 11:15:49', '2020-09-05 10:43:38');
SELECT setval('sys_user_user_id_seq', (SELECT COALESCE(MAX(user_id), 1) FROM sys_user));

-- ----------------------------
-- Table structure for sys_users_jobs
-- ----------------------------
DROP TABLE IF EXISTS sys_users_jobs CASCADE;
CREATE TABLE sys_users_jobs (
  user_id BIGINT NOT NULL,
  job_id BIGINT NOT NULL,
  PRIMARY KEY (user_id, job_id)
);
CREATE INDEX idx_sys_users_jobs_user_id ON sys_users_jobs (user_id);
CREATE INDEX idx_sys_users_jobs_job_id ON sys_users_jobs (job_id);
COMMENT ON TABLE sys_users_jobs IS '用户与岗位关联表';

INSERT INTO sys_users_jobs (user_id, job_id) VALUES (1, 11);
INSERT INTO sys_users_jobs (user_id, job_id) VALUES (2, 11);

-- ----------------------------
-- Table structure for sys_users_roles
-- ----------------------------
DROP TABLE IF EXISTS sys_users_roles CASCADE;
CREATE TABLE sys_users_roles (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  PRIMARY KEY (user_id, role_id)
);
CREATE INDEX idx_sys_users_roles_user_id ON sys_users_roles (user_id);
CREATE INDEX idx_sys_users_roles_role_id ON sys_users_roles (role_id);
COMMENT ON TABLE sys_users_roles IS '用户角色关联';

INSERT INTO sys_users_roles (user_id, role_id) VALUES (1, 1);
INSERT INTO sys_users_roles (user_id, role_id) VALUES (2, 2);

-- ----------------------------
-- Table structure for tool_alipay_config
-- ----------------------------
DROP TABLE IF EXISTS tool_alipay_config CASCADE;
CREATE TABLE tool_alipay_config (
  config_id BIGINT PRIMARY KEY,
  app_id VARCHAR(255),
  charset VARCHAR(255),
  format VARCHAR(255),
  gateway_url VARCHAR(255),
  notify_url VARCHAR(255),
  private_key TEXT,
  public_key TEXT,
  return_url VARCHAR(255),
  sign_type VARCHAR(255),
  sys_service_provider_id VARCHAR(255)
);
COMMENT ON TABLE tool_alipay_config IS '支付宝配置类';

INSERT INTO tool_alipay_config (config_id, app_id, charset, format, gateway_url, notify_url, private_key, public_key, return_url, sign_type, sys_service_provider_id) VALUES (1, '2016091700532697', 'utf-8', 'JSON', 'https://openapi.alipaydev.com/gateway.do', 'http://api.auauz.net/api/aliPay/notify', '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', 'http://api.auauz.net/api/aliPay/return', 'RSA2', '2088102176044281');

-- ----------------------------
-- Table structure for tool_email_config
-- ----------------------------
DROP TABLE IF EXISTS tool_email_config CASCADE;
CREATE TABLE tool_email_config (
  config_id BIGINT PRIMARY KEY,
  from_user VARCHAR(255),
  host VARCHAR(255),
  pass VARCHAR(255),
  port VARCHAR(255),
  sender VARCHAR(255)
);
COMMENT ON TABLE tool_email_config IS '邮箱配置';

-- ----------------------------
-- Table structure for tool_local_storage
-- ----------------------------
DROP TABLE IF EXISTS tool_local_storage CASCADE;
CREATE TABLE tool_local_storage (
  storage_id BIGSERIAL PRIMARY KEY,
  real_name VARCHAR(255),
  name VARCHAR(255),
  suffix VARCHAR(255),
  path VARCHAR(255),
  type VARCHAR(255),
  size VARCHAR(256),
  create_by VARCHAR(255),
  update_by VARCHAR(255),
  create_time TIMESTAMP,
  update_time TIMESTAMP
);
COMMENT ON TABLE tool_local_storage IS '本地存储';

-- ----------------------------
-- Table structure for tool_s3_storage
-- ----------------------------
DROP TABLE IF EXISTS tool_s3_storage CASCADE;
CREATE TABLE tool_s3_storage (
  storage_id BIGSERIAL PRIMARY KEY,
  file_name VARCHAR(255) NOT NULL,
  file_real_name VARCHAR(255) NOT NULL,
  file_size VARCHAR(100) NOT NULL,
  file_mime_type VARCHAR(50) NOT NULL,
  file_type VARCHAR(50) NOT NULL,
  file_path TEXT NOT NULL,
  create_by VARCHAR(255) NOT NULL,
  update_by VARCHAR(255) NOT NULL,
  create_time TIMESTAMP NOT NULL,
  update_time TIMESTAMP NOT NULL
);
COMMENT ON TABLE tool_s3_storage IS 's3 协议对象存储';
