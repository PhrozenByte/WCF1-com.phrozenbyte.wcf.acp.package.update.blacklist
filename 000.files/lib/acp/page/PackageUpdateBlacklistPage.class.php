<?php
/**
 * PackageUpdateBlacklistPage
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

require_once(WCF_DIR.'lib/acp/page/PackageListPage.class.php');
require_once(WCF_DIR.'lib/acp/package/Package.class.php');
require_once(WCF_DIR.'lib/acp/package/update/PackageUpdateBlacklist.class.php');

class PackageUpdateBlacklistPage extends PackageListPage {
	public $templateName = 'packageUpdateBlacklist';
	public $blacklist;
	public $success;

	/**
	 * @see Page::readParameters()
	 */
	public function readParameters() {
		parent::readParameters();

		if(isset($_GET['success'])) {
			$success = strval($_GET['success']);
			if(($success === 'add') || ($success === 'remove'))
				$this->success = $success;
		}
	}

	/**
	 * @see Page::readData()
	 */
	public function readData() {
		parent::readData();

		$this->blacklist = PackageUpdateBlacklist::get();
	}

	/**
	 * @see Page::assignVariables()
	 */
	public function assignVariables() {
		parent::assignVariables();

		WCF::getTPL()->assign('blacklist', $this->blacklist);
		WCF::getTPL()->assign('success', $this->success);
	}

	/**
	 * @see Page::show()
	 */
	public function show() {
		WCF::getUser()->checkPermission('admin.system.package.canUpdatePackage');
		parent::show();
	}
}

?>
