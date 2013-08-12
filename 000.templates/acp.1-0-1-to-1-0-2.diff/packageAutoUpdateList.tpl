{include file='header'}

<script type="text/javascript">
	//<![CDATA[
	var checkedAll = true;
	function checkUncheckAllPackages(parent) {
		var inputs = parent.getElementsByTagName('input');
		for (var i = 0, j = inputs.length; i < j; i++) {
			if (inputs[i].getAttribute('type') == 'checkbox') {
				inputs[i].checked = checkedAll;
			}
		}
		
		var selects = parent.getElementsByTagName('select');
		for (var i = 0, j = selects.length; i < j; i++) {
			selects[i].disabled = !checkedAll;
		}
		
		checkedAll = (checkedAll) ? false : true;
	}
	//]]>
</script>

<script type="text/javascript" src="{@RELATIVE_WCF_DIR}acp/js/PackageAutoUpdateBlacklist.class.js"></script>
<script type="text/javascript">
	//<![CDATA[
		language = [];
		language['wcf.global.error.empty'] = '{lang}wcf.global.error.empty{/lang}';
		language['wcf.acp.packageUpdate.blacklist.add.error'] = '{lang}wcf.acp.packageUpdate.blacklist.add.error{/lang}';
		language['wcf.acp.packageUpdate.blacklist.add.wildcardError'] = '{lang}wcf.acp.packageUpdate.blacklist.add.wildcardError{/lang}';
		language['wcf.acp.packageUpdate.blacklist.remove.error'] = '{lang}wcf.acp.packageUpdate.blacklist.remove.error{/lang}';

		document.observe('dom:loaded', function() {
			packageAutoUpdateBlacklist = new PackageAutoUpdateBlacklist({@$packageUpdateList}, {@$packageUpdateData});
		});
	//]]>
</script>

<style type="text/css">
	.formElement .formField .formFieldButtons {
		float: right;
	}
</style>

<form method="post" action="index.php?form=PackageUpdate" id="updateForm">
	<div class="mainHeadline">
		<img src="{@RELATIVE_WCF_DIR}icon/packageUpdateL.png" alt="" />
		<div class="headlineContainer">
			<h2>{lang}wcf.acp.packageUpdate{/lang}</h2>
			{if $availableUpdates|count}<p><label><input type="checkbox" id="allPackagesCheckbox" /> {lang}wcf.acp.packageUpdate.selectAll{/lang}</label></p>{/if}
		</div>
	</div>

	{if !$availableUpdates|count}
		<div class="border content">
			<div class="container-1">
				<p>{lang}wcf.acp.packageUpdate.noneAvailable{/lang}</p>
			</div>
		</div>
	{else}
		{foreach from=$availableUpdates item=availableUpdate}
			<div class="message content"{if $availableUpdate.version.updateType == 'security'} style="border-color: #c00"{/if}>
				<div class="messageInner container-{cycle name='styles' values='1,2'}">
					<h3 class="subHeadline">
						<label>
							<input id="version-{@$availableUpdate.packageID}Checkbox" type="checkbox" name="updates[{@$availableUpdate.packageID}]" value="{$availableUpdate.version.packageVersion}" />
							{$availableUpdate.packageName}{if $availableUpdate.instanceNo > 1} (#{#$availableUpdate.instanceNo}){/if}
						</label>
					</h3>

					<div class="messageBody">
						<div class="formElement">
							<div class="formFieldLabel">
								<label>{lang}wcf.acp.packageUpdate.currentVersion{/lang}</label>
							</div>
							<div class="formField">
								<span>{$availableUpdate.packageVersion}</span>
							</div>
						</div>
						
						<div class="formElement" id="version-{@$availableUpdate.packageID}Div">
							<div class="formFieldLabel">
								<label for="version-{@$availableUpdate.packageID}">{lang}wcf.acp.packageUpdate.updateVersion{/lang}</label>
							</div>
							<div class="formField">
								<div class="formFieldButtons">
									<button id="version-{@$availableUpdate.packageID}Blacklist" type="button" value="{lang}wcf.acp.packageUpdate.blacklist.manage{/lang}" style="display: none;">{lang}wcf.acp.packageUpdate.blacklist.manage{/lang}</button>
								</div>
								<select name="updates[{@$availableUpdate.packageID}]" id="version-{@$availableUpdate.packageID}" disabled="disabled">
								</select>
							</div>
						</div>
						
						{include file=packageAutoUpdateBlacklist sandbox=false}

						{if $availableUpdate.author}
							<div class="formElement">
								<div class="formFieldLabel">
									<label>{lang}wcf.acp.package.list.author{/lang}</label>
								</div>
								<div class="formField">
									<span>{if $availableUpdate.authorURL}<a href="{@RELATIVE_WCF_DIR}acp/dereferrer.php?url={$availableUpdate.authorURL|rawurlencode}" class="externalURL">{$availableUpdate.author}</a>{else}{$availableUpdate.author}{/if}</span>
								</div>
							</div>
						{/if}
						
						{if $availableUpdate.packageDescription}
							<div class="formElement">
								<p class="formFieldLabel">{lang}wcf.acp.package.description{/lang}</p>
								<p class="formField">{$availableUpdate.packageDescription}</p>
							</div>
						{/if}
							
					</div>

					<hr />
				</div>
			</div>			
		{/foreach}
		
		<div class="formSubmit">
			<input type="submit" accesskey="s" value="{lang}wcf.global.button.submit{/lang}" />
			<input type="reset" accesskey="r" value="{lang}wcf.global.button.reset{/lang}" />
			<input type="hidden" name="packageID" value="{@PACKAGE_ID}" />
			{@SID_INPUT_TAG}
	 	</div>
	{/if}
</form>

{include file='footer'}
