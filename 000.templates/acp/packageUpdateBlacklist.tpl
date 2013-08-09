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

{include file='header'}
<script type="text/javascript" src="{@RELATIVE_WCF_DIR}js/MultiPagesLinks.class.js"></script>
<script type="text/javascript" src="{@RELATIVE_WCF_DIR}acp/js/PackageUpdateBlacklist.class.js"></script>
<script type="text/javascript">
	//<![CDATA[
		language = [];
		language['wcf.acp.packageUpdate.blacklist.versionPrompt'] = '{lang}wcf.acp.packageUpdate.blacklist.versionPrompt{/lang}';
	//]]>
</script>

<style type="text/css">
	.imageButton {
		cursor: pointer;
	}
</style>

<div class="mainHeadline">
	<img src="{@RELATIVE_WCF_DIR}icon/packageL.png" alt="" />
	<div class="headlineContainer">
		<h2>{lang}wcf.acp.packageUpdate.blacklist{/lang}</h2>
	</div>
</div>

{if $success == 'add'}
	<p class="success" id="success">{lang}wcf.acp.packageUpdate.blacklist.add.success{/lang}</p>
{elseif $success == 'remove'}
	<p class="success" id="success">{lang}wcf.acp.packageUpdate.blacklist.remove.success{/lang}</p>
{/if}
<p class="error" id="addError" style="display: none;">{lang}wcf.acp.packageUpdate.blacklist.add.error{/lang}</p>
<p class="error" id="wildcardAddError" style="display: none;">{lang}wcf.acp.packageUpdate.blacklist.add.wildcardError{/lang}</p>
<p class="error" id="removeError" style="display: none;">{lang}wcf.acp.packageUpdate.blacklist.remove.error{/lang}</p>

<div class="contentHeader">
	{pages print=true assign=pagesLinks link="index.php?page=PackageUpdateBlacklist&pageNo=%d&sortField=$sortField&sortOrder=$sortOrder&packageID="|concat:PACKAGE_ID:SID_ARG_2ND_NOT_ENCODED}

	<div class="largeButtons">
		<ul>
			<li><a title="{lang}wcf.acp.package.list{/lang}" href="index.php?page=PackageList&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}"><img alt="" src="../wcf/icon/packageM.png"> <span>{lang}wcf.acp.package.list{/lang}</span></a></li>
			{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
		</ul>
	</div>
</div>

<div class="border titleBarPanel">
	<div class="containerHead"><h3>{lang}wcf.acp.packageUpdate.blacklist.count{/lang}</h3></div>
</div>
<div class="border borderMarginRemove">
	<table class="tableList">
		<thead>
			<tr class="tableHead">
				<th{if $sortField == 'packageID'} class="active"{/if} colspan="2"><div><a href="index.php?page=PackageUpdateBlacklist&amp;pageNo={@$pageNo}&amp;sortField=packageID&amp;sortOrder={if $sortField == 'packageID' && $sortOrder == 'ASC'}DESC{else}ASC{/if}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}">{lang}wcf.acp.package.list.id{/lang}{if $sortField == 'packageID'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}S.png" alt="" />{/if}</a></div></th>
				<th{if $sortField == 'packageName'} class="active"{/if} colspan="2"><div><a href="index.php?page=PackageUpdateBlacklist&amp;pageNo={@$pageNo}&amp;sortField=packageName&amp;sortOrder={if $sortField == 'packageName' && $sortOrder == 'ASC'}DESC{else}ASC{/if}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}">{lang}wcf.acp.package.list.name{/lang}{if $sortField == 'packageName'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}S.png" alt="" />{/if}</a></div></th>
				<th{if $sortField == 'packageVersion'} class="active"{/if}><div><a href="index.php?page=PackageUpdateBlacklist&amp;pageNo={@$pageNo}&amp;sortField=packageVersion&amp;sortOrder={if $sortField == 'packageVersion' && $sortOrder == 'ASC'}DESC{else}ASC{/if}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}">{lang}wcf.acp.packageUpdate.blacklist.column.version{/lang}{if $sortField == 'packageVersion'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}S.png" alt="" />{/if}</a></div></th>
				<th{if $sortField == 'updateDate'} class="active"{/if}><div><a href="index.php?page=PackageUpdateBlacklist&amp;pageNo={@$pageNo}&amp;sortField=updateDate&amp;sortOrder={if $sortField == 'updateDate' && $sortOrder == 'ASC'}DESC{else}ASC{/if}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}">{lang}wcf.acp.packageUpdate.blacklist.column.updateDate{/lang}{if $sortField == 'updateDate'} <img src="{@RELATIVE_WCF_DIR}icon/sort{@$sortOrder}S.png" alt="" />{/if}</a></div></th>
				<th colspan="2"><div><span class="emptyHead">{lang}wcf.acp.packageUpdate.blacklist.column.blacklist{/lang}</span></div></th>

				{if $additionalColumns|isset}{@$additionalColumns}{/if}
			</tr>
		</thead>
		<tbody>
			{foreach from=$packages item=package}
				{assign var=packageID value=$package.packageID}
				{cycle values="container-1,container-2" print=false assign=containerStyle}

				{assign var=rowspan value=""}
				{if $blacklist.$packageID|isset && $blacklist.$packageID|count > 0}
					{assign var=blacklistItemCount value=$blacklist.$packageID|count}
					{assign var=rowspan value=' rowspan="'|concat:$blacklistItemCount+1|concat:'"'}
				{/if}

				{capture append=blacklistJavaScript}
					$('blacklist-{$packageID}Add').onclick = function() { packageUpdateBlacklistPage.add({$packageID}); }
				{/capture}

				<tr class="{$containerStyle}">
					<td class="columnIcon"{@$rowspan}>
						{if $this->user->getPermission('admin.system.package.canUpdatePackage')}
							<a href="index.php?form=PackageStartInstall&amp;action=update&amp;activePackageID={@$packageID}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}"><img src="{@RELATIVE_WCF_DIR}icon/packageUpdateS.png" alt="" title="{lang}wcf.acp.package.view.button.update{/lang}" /></a>
						{else}
							<img src="{@RELATIVE_WCF_DIR}icon/packageUpdateDisabledS.png" alt="" title="{lang}wcf.acp.package.view.button.update{/lang}" />
						{/if}
						{if $this->user->getPermission('admin.system.package.canUninstallPackage') && $package.package != 'com.woltlab.wcf' && $packageID != PACKAGE_ID}
							<a onclick="return confirm('{lang}wcf.acp.package.view.button.uninstall.sure{/lang}')" href="index.php?page=Package&amp;action=startUninstall&amp;activePackageID={@$packageID}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}"><img src="{@RELATIVE_WCF_DIR}icon/deleteS.png" alt="" title="{lang}wcf.acp.package.view.button.uninstall{/lang}" /></a>
						{else}
							<img src="{@RELATIVE_WCF_DIR}icon/deleteDisabledS.png" alt="" title="{lang}wcf.acp.package.view.button.uninstall{/lang}" />
						{/if}

						{if $package.additionalButtons|isset}{@$package.additionalButtons}{/if}
					</td>
					<td class="columnID"{@$rowspan}>{@$packageID}</td>
					<td class="columnIcon"{@$rowspan}>
						{if $package.standalone}
							<img src="{@RELATIVE_WCF_DIR}icon/packageTypeStandaloneS.png" alt="" title="{lang}wcf.acp.package.list.standalone{/lang}" />
						{elseif $package.plugin}
							<img src="{@RELATIVE_WCF_DIR}icon/packageTypePluginS.png" alt="" title="{lang}wcf.acp.package.list.plugin{/lang}" />
						{else}
							<img src="{@RELATIVE_WCF_DIR}icon/packageS.png" alt="" title="{lang}wcf.acp.package.list.other{/lang}" />
						{/if}
					</td>
					<td class="columnText" title="{$package.packageDescription}" id="packageName{@$packageID}"{@$rowspan}>
						<a href="index.php?page=PackageView&amp;activePackageID={@$packageID}&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}"><span>{$package.packageName}{if $package.instanceNo > 1 && $package.instanceName == ''} (#{#$package.instanceNo}){/if}</span></a>
					</td>
					<td class="columnText"{@$rowspan}>{$package.packageVersion}</td>
					<td class="columnDate"{@$rowspan}>{@$package.updateDate|shorttime}</td>
					<td class="columnIcon">
						<img src="{@RELATIVE_WCF_DIR}icon/addS.png" alt="{lang}wcf.acp.packageUpdate.blacklist.add{/lang}" title="{lang}wcf.acp.packageUpdate.blacklist.add{/lang}" class="imageButton" id="blacklist-{$packageID}Add" />
					</td>
					<td class="columnEmpty"></td>

					{if $package.additionalColumns|isset}{@$package.additionalColumns}{/if}
				</tr>
				{if $blacklist.$packageID|isset && $blacklist.$packageID|count > 0}
					{foreach from=$blacklist.$packageID key=i item=blacklistItem}
						{capture append=blacklistJavaScript}
							$('blacklist-{$packageID}-{$i}Remove').onclick = function() { packageUpdateBlacklistPage.remove({$packageID}, '{$blacklistItem|encodejs}'); }
						{/capture}

						<tr class="{$containerStyle}">
							<td class="columnIcon">
								<img src="{@RELATIVE_WCF_DIR}icon/removeS.png" alt="{lang}wcf.acp.packageUpdate.blacklist.remove{/lang}" title="{lang}wcf.acp.packageUpdate.blacklist.remove{/lang}" class="imageButton" id="blacklist-{$packageID}-{$i}Remove" />
							</td>
							<td class="columnText">{$blacklistItem}</td>
						</tr>
					{/foreach}
				{/if}
			{/foreach}
		</tbody>
	</table>
</div>
<script type="text/javascript">
	//<![CDATA[
		document.observe('dom:loaded', function() {
			packageUpdateBlacklistPage = new PackageUpdateBlacklistPage();
			{@$blacklistJavaScript}
		});
	//]]>
</script>

<div class="contentFooter">
	{@$pagesLinks}

	<div class="largeButtons">
		<ul>
			<li><a title="{lang}wcf.acp.package.list{/lang}" href="index.php?page=PackageList&amp;packageID={@PACKAGE_ID}{@SID_ARG_2ND}"><img alt="" src="../wcf/icon/packageM.png"> <span>{lang}wcf.acp.package.list{/lang}</span></a></li>
			{if $additionalLargeButtons|isset}{@$additionalLargeButtons}{/if}
		</ul>
	</div>
</div>

{include file='footer'}
