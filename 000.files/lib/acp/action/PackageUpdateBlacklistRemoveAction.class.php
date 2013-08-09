<?php
/**
 * PackageUpdateBlacklistRemoveAction
 *
 * Remove a blacklist item (via AJAX)
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

require_once(WCF_DIR.'lib/action/AbstractAction.class.php');
require_once(WCF_DIR.'lib/acp/package/update/PackageUpdateBlacklistEditor.class.php');

class PackageUpdateBlacklistRemoveAction extends AbstractAction {
	public $packageID = 0;
	public $versions = array();
	public $blacklistPackageVersion = '';

	/**
	 * @see Action::readParameters()
	 */
	public function readParameters() {
		parent::readParameters();

		if(isset($_POST['packageID'])) $this->packageID = intval($_POST['packageID']);
		if(isset($_POST['versions']) && is_array($_POST['versions'])) $this->versions = $_POST['versions'];
		if(isset($_POST['blacklistPackageVersion'])) $this->blacklistPackageVersion = strval($_POST['blacklistPackageVersion']);

		if(($this->packageID === 0) || ($this->blacklistPackageVersion === ''))
			throw new IllegalLinkException();
	}

	/**
	 * @see Action::execute()
	 */
	public function execute() {
		parent::execute();

		WCF::getUser()->checkPermission('admin.system.package.canUpdatePackage');

		if(PackageUpdateBlacklistEditor::remove($this->packageID, $this->blacklistPackageVersion)) {
			if(count($this->versions) > 0) {
				$packageUpdateBlacklist = new PackageUpdateBlacklist($this->packageID, $this->versions);
				$packageUpdateBlacklist->parseData();

				header('Content-type: application/json');
				echo json_encode($packageUpdateBlacklist->getData());
				exit;
			} else {
				header('HTTP/1.0 204 No Content');
				exit;
			}
		} else {
			header('HTTP/1.0 404 Not Found');
			exit;
		}
	}
}

?>
