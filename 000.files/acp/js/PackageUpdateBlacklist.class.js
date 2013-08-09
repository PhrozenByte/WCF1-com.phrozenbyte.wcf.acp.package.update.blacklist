/**
 * PackageUpdateBlacklistPage
 *
 * Adds/Removes blacklist items using AJAX requests
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

var PackageUpdateBlacklistPage = Class.create({
	// {{{ blacklist management

	add: function(packageID) {
		var version = prompt(language['wcf.acp.packageUpdate.blacklist.versionPrompt'], '');

		if((version != null) && (version != '')) {
			var wildcardIndex = version.indexOf('*');
			if(((wildcardIndex != -1) && (wildcardIndex != (version.length - 1))) || (version == '*')) {
				this.showError($('wildcardAddError'));
				return;
			}

			new Ajax.Request('index.php?action=PackageUpdateBlacklistAdd' + SID_ARG_2ND, {
				'method': 'post',
				'parameters': {
					'packageID': packageID,
					'blacklistPackageVersion': version
				},
				'onSuccess': function(transport) {
					window.location.href = this.removeSuccessParameters(window.location.href) + '&success=add';
				}.bind(this),
				'onFailure': function(transport) {
					this.showError($('addError'));
				}.bind(this)
			});
		} else {
			this.hideErrorSuccess();
		}
	},

	remove: function(packageID, blacklistItem) {
		new Ajax.Request('index.php?action=PackageUpdateBlacklistRemove' + SID_ARG_2ND, {
			'method': 'post',
			'parameters': {
				'packageID': packageID,
				'blacklistPackageVersion': blacklistItem
			},
			'onSuccess': function(transport) {
				window.location.href = this.removeSuccessParameters(window.location.href) + '&success=remove';
			}.bind(this),
			'onFailure': function(transport) {
				this.showError($('removeError'));
			}.bind(this)
		});
	},

	// }}}
	// {{{ helper

	removeSuccessParameters: function(uri) {
		var addIndex = uri.indexOf('&success=add');
		if(addIndex != -1) uri = uri.substr(0, addIndex) + uri.substr(addIndex + 12);

		var removeIndex = uri.indexOf('&success=remove');
		if(removeIndex != -1) uri = uri.substr(0, removeIndex) + uri.substr(removeIndex + 15);

		return uri;
	},

	showError: function(error) {
		var effects = [];
		effects.push((!error.visible())
			? new Effect.BlindDown(error, { duration: 0.5 })
			: new Effect.Pulsate(error, { duration: 0.5, pulses: 3 })
		);

		this.hideErrorSuccess(effects, error);
	},

	hideErrorSuccess: function(additionalEffects, dontHide) {
		var effects = (typeof(additionalEffects) != 'undefined') ? additionalEffects : [];

		if($('addError').visible() && (dontHide != $('addError')))
			effects.push(new Effect.BlindUp($('addError'), { sync: true }));
		if($('wildcardAddError').visible() && (dontHide != $('wildcardAddError')))
			effects.push(new Effect.BlindUp($('wildcardAddError'), { sync: true }));
		if($('removeError').visible() && (dontHide != $('removeError')))
			effects.push(new Effect.BlindUp($('removeError'), { sync: true }));
		if(($('success') != null) && $('success').visible() && (dontHide != $('success')))
			effects.push(new Effect.BlindUp($('success'), { sync: true }));

		if(effects.length > 0)
			new Effect.Parallel(effects, { duration: 0.5 });
	}

	// }}}
});
