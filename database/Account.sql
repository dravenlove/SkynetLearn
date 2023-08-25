DROP TABLE IF EXISTS `account`;
CREATE TABLE `account` (
    `account_id` bigint(20) NOT NULL,
    `password` char(20) DEFAULT NULL,
    PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;