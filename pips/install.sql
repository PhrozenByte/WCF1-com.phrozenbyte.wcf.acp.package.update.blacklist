CREATE TABLE IF NOT EXISTS `wcf1_package_update_blacklist` (
	`packageID` int(10) NOT NULL DEFAULT '0',
	`blacklistedPackageVersion` varchar(255) NOT NULL DEFAULT '',
	PRIMARY KEY (`packageID`,`blacklistedPackageVersion`)
) DEFAULT CHARSET=utf8;
