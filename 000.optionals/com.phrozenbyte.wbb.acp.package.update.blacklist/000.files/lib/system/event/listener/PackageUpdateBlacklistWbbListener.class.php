<?php
/**
 * PackageUpdateBlacklistWbbListener
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
 * @category 	Package Administration - Update Blacklist (WBB Components)
 * @package		com.phrozenbyte.wbb.acp.package.update.blacklist
 * @author		Daniel Rudolf
 * @copyright	2011 Daniel Rudolf
 * @license		GNU General Public License 3 or later <http://www.gnu.org/licenses/>
 * @link		http://www.phrozenbyte.de/
 * @version		1.0.1
 * @since		1.0.0
 */

require_once(WCF_DIR.'lib/system/event/EventListener.class.php');
require_once(WCF_DIR.'lib/acp/package/update/PackageUpdateBlacklist.class.php');

class PackageUpdateBlacklistWbbListener implements EventListener {
	public function execute($eventObj, $className, $eventName) {
		if($className === 'IndexPage') {
			WCF::getTPL()->assign('minorUpdates', $this->runPackageUpdateBlacklist(WCF::getTPL()->get('minorUpdates')));
			WCF::getTPL()->assign('majorUpdates', $this->runPackageUpdateBlacklist(WCF::getTPL()->get('majorUpdates')));
			return;
		}
		
		throw new SystemException('PackageUpdateBlacklistWbbListener was called unexpected');
	}
	
	protected function runPackageUpdateBlacklist($updates) {
		if(count($updates) > 0) {
			$packageUpdateBlacklist = new PackageUpdateBlacklist();

			foreach($updates as &$update)
				$packageUpdateBlacklist->addPackage($update['packageID'], array_keys($update['versions']));
				
			$packageUpdateBlacklist->parseData();
			$packageUpdateData = $packageUpdateBlacklist->getData();
			
			foreach($updates as $i => &$update) {
				foreach($packageUpdateData[$update['packageID']]['blacklistedVersions'] as $version)
					unset($update['versions'][$version]);
				
				if(count($update['versions']) > 0) {
					$update['version'] = end($update['versions']);
				} else {
					unset($updates[$i]);
				}
			}
		}
		
		return $updates;
	}
}

?>
