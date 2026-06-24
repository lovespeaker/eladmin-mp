<h1 style="text-align: center">ELADMIN 后台管理系统</h1>

#### 项目简介
一个基于 Spring Boot 2.7.18 、 Mybatis-Plus、 JWT、Spring Security、Redis、Vue的前后端分离的后台管理系统

**开发文档：**  [https://eladmin.vip](https://eladmin.vip)

**体验地址：**  [https://eladmin.vip/demo](https://eladmin.vip/demo)

**账号密码：** `admin / 123456`

#### 项目源码

| github                                 |   gitee  |
|--------------------------------------| --- |
| https://github.com/elunez/eladmin-mp |  https://gitee.com/elunez/eladmin-mp   |


#### 主要特性
- 使用最新技术栈，社区资源丰富。
- 高效率开发，代码生成器可一键生成前后端代码
- 支持数据字典，可方便地对一些状态进行管理
- 支持接口限流，避免恶意请求导致服务层压力过大
- 支持接口级别的功能权限与数据权限，可自定义操作
- 自定义权限注解与匿名接口注解，可快速对接口拦截与放行
- 对一些常用地前端组件封装：表格数据请求、数据字典等
- 前后端统一异常拦截处理，统一输出异常，避免繁琐的判断
- 支持在线用户管理与服务器性能监控，支持限制单用户登录
- 支持运维管理，可方便地对远程服务器的应用进行部署与管理

####  系统功能
- 用户管理：提供用户的相关配置，新增用户后，默认密码为123456
- 角色管理：对权限与菜单进行分配，可根据部门设置角色的数据权限
- 菜单管理：已实现菜单动态路由，后端可配置化，支持多级菜单
- 部门管理：可配置系统组织架构，树形表格展示
- 岗位管理：配置各个部门的职位
- 字典管理：可维护常用一些固定的数据，如：状态，性别等
- 系统日志：记录用户操作日志与异常日志，方便开发人员定位排错
- SQL监控：采用druid 监控数据库访问性能，默认用户名admin，密码123456
- 定时任务：整合Quartz做定时任务，加入任务日志，任务运行情况一目了然
- 代码生成：高灵活度生成前后端代码，减少大量重复的工作任务
- 邮件工具：配合富文本，发送html格式的邮件
- 亚马逊S3云存储：支持市面上大多数对象存储，兼容亚马逊S3协议，如七牛云，阿里云等
- 支付宝支付：整合了支付宝支付并且提供了测试账号，可自行测试
- 服务监控：监控服务器的负载情况
- 运维管理：一键部署你的应用

#### 项目结构
项目采用按功能分模块的开发方式，结构如下

- `eladmin-common` 为系统的公共模块，各种工具类，公共配置存在该模块

- `eladmin-system` 为系统核心模块也是项目入口模块，也是最终需要打包部署的模块

- `eladmin-logging` 为系统的日志模块，其他模块如果需要记录日志需要引入该模块

- `eladmin-tools` 为第三方工具模块，包含：邮件、亚马逊S3云存储、本地存储、支付宝

- `eladmin-generator` 为系统的代码生成模块，支持生成前后端CRUD代码

#### 详细结构

```
- eladmin-common 公共模块
    - annotation 为系统自定义注解
    - aspect 自定义注解的切面
    - base 提供了 Entity 基类
    - config 项目通用配置
        - Mybatis-Plus 配置
        - Web配置跨域与静态资源映射、Swagger配置，文件上传临时路径配置
        - Redis配置，Redission配置, 异步线程池配置
        - 权限拦截配置：AuthorityConfig、Druid 删除广告配置
    - exception 项目统一异常的处理
    - utils 系统通用工具类，列举一些常用的工具类
        - BigDecimaUtils 金额计算工具类
        - RequestHolder 请求工具类
        - SecurityUtils 安全工具类
        - StringUtils 字符串工具类
        - SpringBeanHolder Spring Bean工具类
        - RedisUtils Redis工具类
        - EncryptUtils 加密工具类
        - FileUtil 文件工具类
- eladmin-system 系统核心模块（系统启动入口）
    - sysrunner 程序启动后处理数据
	- modules 系统相关模块(登录授权、系统监控、定时任务、系统模块、运维模块)
- eladmin-logging 系统日志模块
- eladmin-tools 系统第三方工具模块
    - email 邮件工具
    - amazon 亚马逊S3云存储工具
    - alipay 支付宝支付工具
    - local-storage 本地存储工具
- eladmin-generator 系统代码生成模块
```




准备工作
确保本地已安装：JDK 8+、Maven、Node.js 16+、PostgreSQL、Redis、MinIO（可选）

1. 初始化数据库
在 PostgreSQL 中创建数据库，然后导入 SQL：


# 创建数据库
psql -U postgres -c "CREATE DATABASE \"eladmin-mp\";"

# 导入表结构和初始数据
psql -U postgres -d eladmin-mp -f sql/eladmin_postgresql.sql

# 如果使用 Quartz 定时任务，还需要导入
psql -U postgres -d eladmin-mp -f sql/quartz_postgresql.sql
2. 启动后端

cd eladmin

# 安装依赖并启动（默认使用 dev 环境）
mvn clean install -DskipTests
mvn spring-boot:run -pl eladmin-system
主启动类：AppRun.java，端口 8000。

3. 启动前端

cd eladmin-web

# 安装依赖
npm install

# 启动开发服务器
npm run dev
前端默认运行在 http://localhost:8012（vue-cli-service 默认端口，如有自定义可看 vue.config.js）。

4. 登录
地址：http://localhost:8012
账号：admin
密码：123456
注意：dev 环境的 PostgreSQL 连接信息在 application-dev.yml，默认是 localhost:5432、用户 postgres、密码 wshjr123。如果不一样需要先改配置再启动。






本项目基于 eladmin (Copyright 2019-2025 Zheng Jie, Apache 2.0) 二次开发
已移除无用模块：代码生成、定时任务、运维监控等模块
保留框架基础权限、用户、菜单核心模块
原始 Apache 2.0 许可证见根目录 LICENSE 文件


