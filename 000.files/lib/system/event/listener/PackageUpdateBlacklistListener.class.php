<?php
/**
 * PackageUpdateBlacklistListener
 *
 * Make the blacklist functionality available...
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
 * @category 	Package Administration - Update Blacklist
 * @package		com.phrozenbyte.wcf.acp.package.update.blacklist
 * @author		Daniel Rudolf
 * @copyright	2011 Daniel Rudolf
 * @license		GNU General Public License 3 or later <http://www.gnu.org/licenses/>
 * @link		http://www.phrozenbyte.de/
 * @version		1.0.1
 * @since		1.0.0
 */

require_once(WCF_DIR.'lib/system/event/EventListener.class.php');
require_once(WCF_DIR.'lib/acp/package/update/PackageUpdateBlacklist.class.php');

class PackageUpdateBlacklistListener implements EventListener {
	public function execute($eventObj, $className, $eventName) {
		switch($className) {
			case 'PackageAutoUpdateListPage':
				$this->handlePackageAutoUpdateListPage();
				break;

			case 'PackageListPage':
				$this->handlePackageListPage();
				break;

			default:
				throw new SystemException('PackageUpdateBlacklistListener was called unexpected');
		}
	}

	protected function handlePackageAutoUpdateListPage() {
		$availableUpdates = WCF::getTPL()->get('availableUpdates');
		if(count($availableUpdates) > 0) {
			$packageUpdateList = array();
			$packageUpdateBlacklist = new PackageUpdateBlacklist();

			foreach($availableUpdates as $packageID => &$availableUpdate) {
				$packageUpdateList[] = $packageID;
				$packageUpdateBlacklist->addPackage($packageID, array_keys($availableUpdate['versions']));
			}

			$packageUpdateBlacklist->parseData();

			WCF::getTPL()->assign('packageUpdateList', json_encode($packageUpdateList));
			WCF::getTPL()->assign('packageUpdateData', json_encode($packageUpdateBlacklist->getData()));
		}
	}

	protected function handlePackageListPage() {
		WCF::getTPL()->append('additionalLargeButtons',
			 '<li>'
			.'    <a title="'.WCF::getLanguage()->get('wcf.acp.packageUpdate.blacklist').'" href="index.php?page=PackageUpdateBlacklist&amp;packageID='.PACKAGE_ID.SID_ARG_2ND.'">'
			.'        <img alt="" src="../wcf/icon/packageM.png"> <span>'.WCF::getLanguage()->get('wcf.acp.packageUpdate.blacklist').'</span>'
			.'    </a>'
			.'</li>'
		);
	}
}

?>
