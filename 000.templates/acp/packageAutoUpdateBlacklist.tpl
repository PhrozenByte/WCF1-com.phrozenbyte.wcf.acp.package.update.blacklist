{*
	Package Administration - Update Blacklist
	Copyright (C) 2011  Daniel Rudolf <drudolf@phrozenbyte.de>

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*}

<div class="formGroup" id="version-{@$availableUpdate.packageID}BlacklistDiv" style="display: none;">
	<div class="formGroupLabel">
		<label>{lang}wcf.acp.packageUpdate.blacklist.list{/lang}</label>
	</div>
	<div class="formGroupField">
		<fieldset>
			<legend>{lang}wcf.acp.packageUpdate.blacklist.list{/lang}</legend>
			<div class="formElement" id="version-{@$availableUpdate.packageID}BlacklistAddDiv">
				<div class="formFieldLabel">
					<label for="version-{@$availableUpdate.packageID}BlacklistAddInput">{lang}wcf.acp.packageUpdate.blacklist.add{/lang}</label>
				</div>
				<div class="formField">
					<div class="formFieldButtons">
						<img id="version-{@$availableUpdate.packageID}BlacklistAddSuccess" src="{@RELATIVE_WCF_DIR}icon/successS.png" alt="{lang}wcf.acp.packageUpdate.blacklist.add.success{/lang}" title="{lang}wcf.acp.packageUpdate.blacklist.add.success{/lang}" style="display: none;" />
						<button id="version-{@$availableUpdate.packageID}BlacklistAdd" type="button" value="{lang}wcf.acp.packageUpdate.blacklist.add{/lang}">{lang}wcf.acp.packageUpdate.blacklist.add{/lang}</button>
					</div>
					<input id="version-{@$availableUpdate.packageID}BlacklistAddInput" class="inputText comboInputSelectBox" type="text" />
					<select id="version-{@$availableUpdate.packageID}BlacklistAddSelect" class="comboInputSelectBox">
						<option value=""></option>
					</select>
					<p class="innerError" id="version-{@$availableUpdate.packageID}BlacklistAddError" style="display: none;" />
				</div>
				<div class="formFieldDesc" id="version-{@$availableUpdate.packageID}BlacklistAddInputHelpMessage">
					<p>{lang}wcf.acp.packageUpdate.blacklist.add.help{/lang}</p>
				</div>
			</div>
			<div class="formElement" id="version-{@$availableUpdate.packageID}BlacklistRemoveDiv">
				<div class="formFieldLabel">
					<label for="version-{@$availableUpdate.packageID}BlacklistRemoveSelect">{lang}wcf.acp.packageUpdate.blacklist.remove{/lang}</label>
				</div>
				<div class="formField">
					<div class="formFieldButtons">
						<img id="version-{@$availableUpdate.packageID}BlacklistRemoveSuccess" src="{@RELATIVE_WCF_DIR}icon/successS.png" alt="Version erfolgreich eingeblendet" title="{lang}wcf.acp.packageUpdate.blacklist.remove.success{/lang}" style="display: none;" />
						<button id="version-{@$availableUpdate.packageID}BlacklistRemove" type="button" value="{lang}wcf.acp.packageUpdate.blacklist.remove{/lang}">{lang}wcf.acp.packageUpdate.blacklist.remove{/lang}</button>
					</div>
					<select id="version-{@$availableUpdate.packageID}BlacklistRemoveSelect"></select>
				</div>
				<div class="formFieldDesc" id="version-{@$availableUpdate.packageID}BlacklistRemoveHelpMessage">
					<p>{lang}wcf.acp.packageUpdate.blacklist.remove.help{/lang}</p>
				</div>
			</div>
		</fieldset>
	</div>
</div>
<script type="text/javascript">
	//<![CDATA[
		inlineHelp.register('version-{@$availableUpdate.packageID}BlacklistAddInput');
		inlineHelp.register('version-{@$availableUpdate.packageID}BlacklistRemoveSelect');
	//]]>
</script>
