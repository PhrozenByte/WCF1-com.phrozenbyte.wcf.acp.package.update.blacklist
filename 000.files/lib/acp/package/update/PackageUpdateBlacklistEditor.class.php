<?php
/**
 * PackageUpdateBlacklistEditor
 *
 * Add/Remove blacklist items
 *
 * PHP Version 5
 *
 * LICENSE:
 * Package Administration - Update Blacklist
 * Copyright (C) 2011  Daniel Rudolf <drudolf@phrozenbyte.de>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category 	Package Administration
 * @package		com.phrozenbyte.wcf.acp.package.update.blacklist
 * @author		Daniel Rudolf
 * @copyright	2011 Daniel Rudolf
 * @license		GNU General Public License 3 or later <http://www.gnu.org/licenses/>
 * @link		http://www.phrozenbyte.de/
 * @version		1.0.0
 * @since		1.0.0
 */

require_once(WCF_DIR.'lib/acp/package/update/PackageUpdateBlacklist.class.php');

class PackageUpdateBlacklistEditor extends PackageUpdateBlacklist {
	public static function add($packageID, $packageVersion) {
		$sql = "INSERT IGNORE INTO	wcf".WCF_N."_package_update_blacklist "
			  ."					(packageID, blacklistedPackageVersion) "
			  ."VALUES				('".escapeString($packageID)."', '".escapeString($packageVersion)."')";
		WCF::getDB()->sendQuery($sql);
		return (WCF::getDB()->getAffectedRows() > 0) ? true : false;
	}

	public static function remove($packageID, $packageVersion) {
		$sql = "DELETE IGNORE FROM	wcf".WCF_N."_package_update_blacklist "
			  ."WHERE				packageID = '".escapeString($packageID)."' "
			  ."	AND				blacklistedPackageVersion = '".escapeString($packageVersion)."'";
		WCF::getDB()->sendQuery($sql);
		return (WCF::getDB()->getAffectedRows() > 0) ? true : false;
	}
}

?>
