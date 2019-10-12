/*
changelist

v1.0.2
alter table t_patch_info add `apply_success_size` int COMMENT '被应用成功的次数'
alter table t_patch_info add `apply_size` int COMMENT '被应用次数'

v1.0.5
alter table t_app_info add `package_name` varchar(64) DEFAULT NULL COMMENT 'android的包名 iOS的bundle_id'

v1.1.0
增加t_full_update_info、t_childuser_app表
*/

/*用户表*/
CREATE TABLE `t_user` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `parent_id` int DEFAULT NULL COMMENT '父账号id',
  `username` varchar(32) NOT NULL COMMENT '用户名',
  `mobile` varchar(16) DEFAULT NULL COMMENT '手机号',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `password` varchar(32) NOT NULL COMMENT '登录密码',
  `avatar` varchar(128) DEFAULT NULL COMMENT '头像',
  `account_type` int DEFAULT NULL COMMENT '账户类型 0: admin 1: 开发人员 1: 测试人员',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `MOBILE` (`mobile`),
  UNIQUE KEY `EMAIL` (`email`),
  UNIQUE KEY `USERNAME` (`username`),
  FOREIGN KEY(parent_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*应用信息表*/
CREATE TABLE `t_app_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `appname` varchar(32) NOT NULL COMMENT '应用名字',
  `platform` varchar(8) NOT NULL COMMENT '平台',
  `uid` varchar(32) DEFAULT NULL COMMENT '应用的唯一标示',
  `description` varchar(32) NOT NULL COMMENT '应用描述',
  `secret` varchar(32) NOT NULL COMMENT '应用秘钥',
  `public_key` varchar(64) DEFAULT NULL COMMENT '公钥',
  `private_key` varchar(64) DEFAULT NULL COMMENT '私钥',
  `package_name` varchar(64) DEFAULT NULL COMMENT 'android的包名 IOS的bundle_id',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UID` (`uid`),
  FOREIGN KEY(user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*版本信息表*/
CREATE TABLE `t_version_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `app_uid` varchar(64) NOT NULL COMMENT '应用id',
  `version_name` varchar(32) NOT NULL COMMENT '版本名字',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(user_id) REFERENCES t_user(id),
  FOREIGN KEY(app_uid) REFERENCES t_app_info(uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*补丁信息表*/
CREATE TABLE `t_patch_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `app_uid` varchar(32) NOT NULL COMMENT '应用id',
  `uid` varchar(32) NOT NULL COMMENT 'uid',
  `version_name` varchar(32) NOT NULL COMMENT '版本名字',
  `patch_version` int COMMENT '补丁版本',
  `publish_version` int COMMENT '发布版本',
  `status` int COMMENT '0 未发布 1 已发布',
  `publish_type` int COMMENT '0 灰度发布 1 正常发布',
  `patch_size` long COMMENT '补丁大小',
  `file_hash` varchar(64) NOT NULL COMMENT '文件的hash值',
  `description` varchar(32) NOT NULL COMMENT '补丁描述',
  `tags` varchar(256) DEFAULT NULL COMMENT '灰度发布的tag用，分割',
  `storage_path` varchar(256) NOT NULL COMMENT '存储路径',
  `download_url` varchar(256) DEFAULT NULL COMMENT '下载地址',
  `apply_success_size` int COMMENT '被应用成功的次数',
  `apply_size` int COMMENT '被应用的次数',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `UUID` (`uid`),
  FOREIGN KEY(user_id) REFERENCES t_user(id),
  FOREIGN KEY(app_uid) REFERENCES t_app_info(uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*测试人员表(与账号和应用向关联)*/
CREATE TABLE `t_tester` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `app_uid` varchar(32) NOT NULL COMMENT '应用id',
  `tag` varchar(32) DEFAULT NULL COMMENT '标记值',
  `email` varchar(32) DEFAULT NULL COMMENT '邮箱',
  `description` varchar(32) NOT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(user_id) REFERENCES t_user(id),
  FOREIGN KEY(app_uid) REFERENCES t_app_info(uid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*机型黑名单*/
CREATE TABLE `t_model_blacklist` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `regular_exp` varchar(64) NOT NULL COMMENT '正则表达式',
  `description` varchar(32) NOT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*渠道*/
CREATE TABLE `t_channel` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `channel_name` varchar(64) NOT NULL COMMENT '渠道的名字',
  `description` varchar(32) DEFAULT NULL COMMENT '描述',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(user_id) REFERENCES t_user(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*全量更新信息*/
CREATE TABLE `t_full_update_info` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `app_uid` varchar(64) NOT NULL COMMENT '应用id',
  `latest_version` varchar(32) NOT NULL COMMENT '最新版本的versionName',
  `title` varchar(32) DEFAULT NULL COMMENT '弹出更新提示的标题',
  `description` varchar(32) NOT NULL COMMENT '更新说明',
  `lowest_support_version` varchar(32) DEFAULT NULL COMMENT '低于这个版本的都强制更新',
  `default_url` varchar(256) NOT NULL COMMENT '默认的下载地址(没有传渠道号)',
  `channel_url` varchar(256) NOT NULL COMMENT '渠道下载地址',
  `file_size` varchar(32) DEFAULT NULL COMMENT '文件大小',
  `network_type` varchar(32) DEFAULT NULL COMMENT '2G|3G|4G|WIFI',
  `status` int COMMENT '当前状态  0暂停 1已开启',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(app_uid) REFERENCES t_app_info(uid),
  UNIQUE KEY `APP_UID` (`app_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*子账号和应用关联表*/
CREATE TABLE `t_childuser_app` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `user_id` int COMMENT '用户id',
  `app_uid` varchar(32) NOT NULL COMMENT 'app的uid',
  `appname` varchar(32) NOT NULL COMMENT '应用名字(冗余字段)',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '修改时间',
  PRIMARY KEY (`id`),
  FOREIGN KEY(user_id) REFERENCES t_user(id),
  FOREIGN KEY(app_uid) REFERENCES t_app_info(uid),
  UNIQUE KEY `APP_UID` (`app_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* 错误码 */
CREATE TABLE `t_error_code` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(50) NOT NULL COMMENT '错误码',
  `name` varchar(200) DEFAULT NULL COMMENT '错误对照信息',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;

/* 错误日志表 */
CREATE TABLE `t_patch_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `app_uid` varchar(32) NOT NULL COMMENT '应用id',
  `token` varchar(100) DEFAULT NULL,
  `version_name` varchar(32) NOT NULL,
  `patch_uid` varchar(32) DEFAULT NULL,
  `patch_version` int(11) NOT NULL,
  `error_code` varchar(50) NOT NULL COMMENT '错误码',
  `error_msg` varchar(2000) DEFAULT NULL COMMENT '错误对照信息',
  `tags` varchar(256) DEFAULT NULL,
  `platform` varchar(32) DEFAULT 'Android' COMMENT '平台 Android/IOS',
  `os_version` varchar(32) DEFAULT NULL COMMENT '手机系统',
  `model` varchar(32) DEFAULT NULL COMMENT '手机型号',
  `channel` varchar(32) DEFAULT NULL COMMENT '渠道号',
  `device_id` varchar(100) DEFAULT NULL,
  `sdk_version` varchar(32) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
