/**
 * PackageAutoUpdateBlacklist
 *
 * Initializes, handles and controls the update blacklist GUI located in the
 * automatic packages update page. Management of blacklist items will be done
 * using AJAX requests.
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
var PackageAutoUpdateBlacklist = Class.create({
	initialize: function(list, data) {
		this.list = list;
		this.data = data;

		this.initializeButtons();
		this.initializeListElements();
	},

	// {{{ initializeButtons

	initializeButtons: function() {
		this.initializeAllPackagesCheckbox();

		for(var i = 0, j = this.list.length; i < j; i++) {
			var packageID = this.list[i];

			this.initializePackageCheckbox(packageID);
			this.initializePackageBlacklist(packageID);
			this.initializePackageBlacklistAddSelect(packageID);
			this.initializePackageBlacklistAddButton(packageID);
			this.initializePackageBlacklistRemoveButton(packageID);
		}
	},

	initializeAllPackagesCheckbox: function() {
		$('allPackagesCheckbox').onclick = function() {
			for(var i = 0, j = packageAutoUpdateBlacklist.list.length; i < j; i++) {
				var packageID = packageAutoUpdateBlacklist.list[i];
				var packageCheckbox = $('version-' + packageID + 'Checkbox');

				if(packageCheckbox.disabled) {
					packageCheckbox.checked = false;
					continue;
				}

				if(this.checked) {
					if(!packageCheckbox.checked) {
						packageCheckbox.click();
					}
				} else {
					if(packageCheckbox.checked) {
						packageCheckbox.click();
					}
				}
			}
		};
	},

	initializePackageCheckbox: function(packageID) {
		$('version-' + packageID + 'Checkbox').onclick = function() {
			var packageID = this.id.substring(8, (this.id.length - 8));

			enableFormElements($('version-' + packageID + 'Div'), this.checked);

			if(this.checked) {
				new Effect.Appear($('version-' + packageID + 'Blacklist'), { duration: 0.5 });
			} else {
				new Effect.Fade($('version-' + packageID + 'Blacklist'), { duration: 0.5 });

				var blacklistBlock = $('version-' + packageID + 'BlacklistDiv');
				if(blacklistBlock.visible()) new Effect.BlindUp(blacklistBlock, { duration: 0.5 });
			}
		}
	},

	initializePackageBlacklist: function(packageID) {
		$('version-' + packageID + 'Blacklist').onclick = function() {
			var blacklistBlock = $(this.id + 'Div');
			if(!blacklistBlock.visible()) {
				new Effect.BlindDown(blacklistBlock, { duration: 0.5 });
			} else {
				new Effect.BlindUp(blacklistBlock, { duration: 0.5 });
			}
		}
	},

	initializePackageBlacklistAddSelect: function(packageID) {
		$('version-' + packageID + 'BlacklistAddSelect').onchange = function() {
			var packageID = this.id.substring(8, (this.id.length - 18));
			var blacklistAddInput = $('version-' + packageID + 'BlacklistAddInput');

			if(this.selectedIndex != 0) {
				blacklistAddInput.value = this.value;
				this.selectedIndex = 0;
			}
		}
	},

	initializePackageBlacklistAddButton: function(packageID) {
		$('version-' + packageID + 'BlacklistAdd').onclick = function() {
			var packageID = this.id.substring(8, (this.id.length - 12));
			var version = $(this.id + 'Input').value;

			if(version == '') {
				packageAutoUpdateBlacklist.showError(this.id, language['wcf.global.error.empty']);
				return;
			}

			var wildcardIndex = version.indexOf('*');
			if(((wildcardIndex != -1) && (wildcardIndex != (version.length - 1))) || (version == '*')) {
				packageAutoUpdateBlacklist.showError(this.id, language['wcf.acp.packageUpdate.blacklist.add.wildcardError']);
				return;
			}

			new Ajax.Request('index.php?action=PackageUpdateBlacklistAdd' + SID_ARG_2ND, {
				'method': 'post',
				'parameters': {
					'packageID': packageID,
					'versions[]': packageAutoUpdateBlacklist.data[packageID]['versions'],
					'blacklistPackageVersion': version
				},

				'onSuccess': function(transport) {
					var response = transport.responseText.evalJSON();
					for(var packageID in response) {
						if(Object.prototype.hasOwnProperty.call(response, packageID)) {
							packageAutoUpdateBlacklist.data[packageID] = response[packageID];
						}
					}

					packageAutoUpdateBlacklist.initializeListElements();
					packageAutoUpdateBlacklist.showSuccess(this.id);
				}.bind(this),

				'onFailure': function(transport) {
					packageAutoUpdateBlacklist.showError(this.id, language['wcf.acp.packageUpdate.blacklist.add.error']);
				}.bind(this)
			});
		}
	},

	initializePackageBlacklistRemoveButton: function(packageID) {
		$('version-' + packageID + 'BlacklistRemove').onclick = function() {
			var packageID = this.id.substring(8, (this.id.length - 15));
			var version = $(this.id + 'Select').value;

			new Ajax.Request('index.php?action=PackageUpdateBlacklistRemove' + SID_ARG_2ND, {
				method: 'post',
				parameters: {
					'packageID': packageID,
					'versions[]': packageAutoUpdateBlacklist.data[packageID]['versions'],
					'blacklistPackageVersion': version
				},

				onSuccess: function(transport) {
					var response = transport.responseText.evalJSON();
					for(var packageID in response) {
						if(Object.prototype.hasOwnProperty.call(response, packageID)) {
							packageAutoUpdateBlacklist.data[packageID] = response[packageID];
						}
					}

					packageAutoUpdateBlacklist.initializeListElements();
					packageAutoUpdateBlacklist.showSuccess(this.id);
				}.bind(this),

				'onFailure': function(transport) {
					packageAutoUpdateBlacklist.showError(this.id, language['wcf.acp.packageUpdate.blacklist.remove.error']);
				}.bind(this)
			});
		}
	},

	// }}}
	// {{{ initializeListElements

	initializeListElements: function() {
		for(var i = 0, j = this.list.length; i < j; i++) {
			var packageID = this.list[i];

			this.initializeVersionListElement(packageID);
			this.initializeBlacklistAddElement(packageID);
			this.initializeBlacklistRemoveElement(packageID);
		}
	},

	initializeVersionListElement: function(packageID) {
		var versionListBlock = $('version-' + packageID + 'Div');
		var versionListCheckbox = $('version-' + packageID + 'Checkbox');
		var versionList = $('version-' + packageID);
		this.removeVersionOptionElements(versionList);

		if(this.data[packageID]['notBlacklistedVersions'].length > 0) {
			this.addVersionOptionElements(versionList, this.data[packageID]['notBlacklistedVersions']);
			versionList.selectedIndex = (this.data[packageID]['notBlacklistedVersions'].length - 1);

			if(!versionListBlock.visible()) new Effect.BlindDown(versionListBlock, { duration: 0.5 });

			if(versionListCheckbox.disabled) {
				versionListCheckbox.disabled = false;
				versionListCheckbox.checked = true;
			}

		} else {
			if(versionListBlock.visible()) new Effect.BlindUp(versionListBlock, { duration: 0.5 });

			versionListCheckbox.disabled = true;
			versionListCheckbox.checked = false;

			var blacklistBlock = $('version-' + packageID + 'BlacklistDiv');
			if(!blacklistBlock.visible()) new Effect.BlindDown(blacklistBlock, { duration: 0.5 });
		}
	},

	initializeBlacklistAddElement: function(packageID) {
		var blacklistAddSelect = $('version-' + packageID + 'BlacklistAddSelect');
		this.removeVersionOptionElements(blacklistAddSelect);
		this.addVersionOptionElement(blacklistAddSelect, '');

		if(this.data[packageID]['notBlacklistedVersions'].length > 0) {
			this.addVersionOptionElements(blacklistAddSelect, this.data[packageID]['notBlacklistedVersions']);

			if(!blacklistAddSelect.visible())
				new Effect.BlindDown(blacklistAddSelect, { duration: 0.5 });
		} else {
			if(blacklistAddSelect.visible())
				new Effect.BlindUp(blacklistAddSelect, { duration: 0.5 });
		}
	},

	initializeBlacklistRemoveElement: function(packageID) {
		var blacklistRemoveBlock = $('version-' + packageID + 'BlacklistRemoveDiv');
		var blacklistRemoveSelect = $('version-' + packageID + 'BlacklistRemoveSelect');
		this.removeVersionOptionElements(blacklistRemoveSelect);

		if(this.data[packageID]['blacklist'].length > 0) {
			this.addVersionOptionElements(blacklistRemoveSelect, this.data[packageID]['blacklist']);

			if(!blacklistRemoveBlock.visible())
				new Effect.BlindDown(blacklistRemoveBlock, { duration: 0.5 });
		} else {
			if(blacklistRemoveBlock.visible())
				new Effect.BlindUp(blacklistRemoveBlock, { duration: 0.5 });
		}
	},

	// }}}
	// {{{ list element handling

	addVersionOptionElements: function(element, versions) {
		for(var i = 0, j = versions.length; i < j; i++) {
			this.addVersionOptionElement(element, versions[i]);
		}
	},

	addVersionOptionElement: function(element, version) {
		var optionElement = document.createElement('option');
		optionElement.text = version;
		optionElement.value = version;

		element.add(optionElement, null);
	},

	removeVersionOptionElements: function(element) {
		for(var i = 0, j = element.childNodes.length; i < j; i++) {
			element.removeChild(element.firstChild);
		}
	},

	// }}}
	// {{{ success and error

	showSuccess: function(elementPrefix) {
		this.hideError(elementPrefix);

		new Effect.Appear($(elementPrefix + 'Success'), { duration: 0.5 });
		window.setTimeout("if($('" + elementPrefix + "Success').visible()) new Effect.Fade($('" + elementPrefix + "Success'), { duration: 0.5 })", 5000);
	},

	hideSuccess: function(elementPrefix) {
		var success = $(elementPrefix + 'Success');
		if(success.visible())
			new Effect.Fade(success, { duration: 0.5 });
	},

	showError: function(elementPrefix, message) {
		this.hideSuccess(elementPrefix);

		$(elementPrefix + 'Div').addClassName('formError');

		var error = $(elementPrefix + 'Error');
		error.replaceChild(document.createTextNode(message), error.firstChild);
		if(!error.visible()) {
			new Effect.BlindDown(error, { duration: 0.5 });
		} else {
			new Effect.Pulsate(error, { duration: 0.5, pulses: 3 });
		}
	},

	hideError: function(elementPrefix) {
		$(elementPrefix + 'Div').removeClassName('formError');

		var error = $(elementPrefix + 'Error');
		if(error.visible())
			new Effect.BlindUp(error, { duration: 0.5 });
	}

	// }}}
});
