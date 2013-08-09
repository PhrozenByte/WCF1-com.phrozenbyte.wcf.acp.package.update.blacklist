<?php
/**
 * PackageUpdateBlacklist
 *
 * Blacklist Management
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
 * @version		1.0.0
 * @since		1.0.0
 */

class PackageUpdateBlacklist {
	protected $packageList = array();
	protected $packageVersions = array();

	protected $blacklist = array();
	protected $data = array();

	// {{{ package handling

	public function __construct($packageID = null, $packageVersions = null) {
		if(!is_null($packageID))
			$this->addPackage($packageID, $packageVersions);
	}

	public function addPackage($packageID, $packageVersions = null) {
		$this->packageList[] = $packageID;

		if(!is_null($packageVersions))
			$this->packageVersions[$packageID] = $packageVersions;
	}

	// }}}
	// {{{ blacklist parsing

	public function parseData() {
		$this->blacklist = self::get($this->packageList);

		foreach($this->packageList as $packageID) {
			$this->data[$packageID] = array(
				'packageID' => $packageID,

				'versions' => array(),
				'blacklistedVersions' => array(),
				'notBlacklistedVersions' => array(),

				'blacklist' => array(),
				'blacklistToVersions' => array(),
				'versionsToBlacklist' => array()
			);

			$blacklist =& $this->data[$packageID]['blacklist'];
			if(isset($this->blacklist[$packageID])) {
				$blacklist = $this->blacklist[$packageID];
			}

			$versions =& $this->data[$packageID]['versions'];
			$blacklistedVersions =& $this->data[$packageID]['blacklistedVersions'];
			$notBlacklistedVersions =& $this->data[$packageID]['notBlacklistedVersions'];
			if(isset($this->packageVersions[$packageID])) {
				$versions = $this->packageVersions[$packageID];
				$notBlacklistedVersions = $this->packageVersions[$packageID];
			}

			if((count($blacklist) > 0) && (count($versions) > 0)) {
				$blacklistToVersions =& $this->data[$packageID]['blacklistToVersions'];
				$versionsToBlacklist =& $this->data[$packageID]['versionsToBlacklist'];

				foreach($versions as &$version) {
					foreach($blacklist as &$blacklistItem) {
						$wildcard = (substr($blacklistItem, -1) === '*');
						$matchWithWildcard = ($wildcard && (substr($version, 0, (strlen($blacklistItem) - 1)) === substr($blacklistItem, 0, -1)));
						$matchWithoutWildcard = (!$wildcard && ($blacklistItem === $version));

						if($matchWithWildcard || $matchWithoutWildcard) {
							$blacklistToVersions[$blacklistItem][] = $version;
							$versionsToBlacklist[$version][] = $blacklistItem;

							$blacklistedVersions[] = $version;
							unset($notBlacklistedVersions[array_search($version, $versions)]);
						}
					}
				}

				if((count($versions) !== count($notBlacklistedVersions)) && (count($notBlacklistedVersions) > 0)) {
					$notBlacklistedVersions = array_combine(
						range(0, (count($notBlacklistedVersions) - 1)),
						$notBlacklistedVersions
					);
				}
			}
		}
	}

	// }}}
	// {{{ get results

	public function getPackageCount() {
		return count($this->data);
	}

	public function getData() {
		return $this->data;
	}

	public function getPackageData($packageID) {
		return $this->data[$packageID];
	}

	// }}}
	// {{{ get the blacklist

	public static function get($package = null) {
		if(is_null($package)) {
			$sql = 'SELECT	* '
				  .'FROM	wcf'.WCF_N.'_package_update_blacklist';
		} elseif(is_array($package)) {
			$sql = 'SELECT	* '
				  .'FROM	wcf'.WCF_N.'_package_update_blacklist '
				  .'WHERE	packageID IN ('.implode(',', ArrayUtil::toIntegerArray($package)).')';
		} else {
			$sql = 'SELECT	* '
				  .'FROM	wcf'.WCF_N.'_package_update_blacklist '
				  .'WHERE	packageID = '.intval($package);
		}

		$blacklist = array();
		$result = WCF::getDB()->sendQuery($sql);
		while($row = WCF::getDB()->fetchArray($result)) {
			if(!isset($blacklist[$row['packageID']])) {
				$blacklist[$row['packageID']] = array($row['blacklistedPackageVersion']);
			} else {
				$blacklist[$row['packageID']][] = $row['blacklistedPackageVersion'];
			}
		}

		return $blacklist;
	}

	// }}}
}

?>
