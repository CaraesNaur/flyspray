<?php
	if (!isset($supertask_id)) {
		$supertask_id = 0;
	}
?>
<script type="text/javascript">
function checkContent() {
	var instance;
	for (instance in CKEDITOR.instances) {
		CKEDITOR.instances[instance].updateElement();
	}
	var summary = document.getElementById("itemsummary").value;
	if (summary.trim().length == 0) {
		return true;
	}
	var detail = document.getElementById("details").value;
	var project_id = document.getElementsByName('project_id')[0].value;

	var xmlHttp = new XMLHttpRequest();
	xmlHttp.open("POST", "<?php echo Filters::noXSS($baseurl); ?>js/callbacks/searchtask.php", false);
	xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlHttp.send("summary=" + summary + "&detail=" + detail +"&project_id=" + project_id);
	if (xmlHttp.status === 200) {
		if (xmlHttp.responseText > 0) {
			var res = confirm("There is already a similar task, do you still want to create?");
			return res;
		}
		return true;
	}
	return false;
}
</script>
<?php echo tpl_form(Filters::noXSS(createUrl('newtask', $proj->id, $supertask_id)), 'newtask', 'post', 'multipart/form-data', 'onsubmit="return checkContent()"'); ?>
	<input type="hidden" name="supertask_id" value="<?php echo Filters::noXSS($supertask_id); ?>" />

<?php
# Grab fields wanted for this project so we can only show those we want
$fields = explode( ' ', $proj->prefs['visible_fields'] );
?>
<div id="taskdetails">
	<div id="taskfields">
		<ul class="fieldslist">
			<!-- Task Type -->
			<?php if (in_array('tasktype', $fields)) { ?>
			<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="tasktype"><?= eL('tasktype') ?></label>
				<span class="value">
				<select name="task_type" id="tasktype">
					<?php echo tpl_options($proj->listTaskTypes(), Req::val('task_type')); ?>
				</select>
				</span>
			</li>

			<!-- Category -->
			<?php if (in_array('category', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="category"><?= eL('category') ?></label>
				<span class="value">
				<select class="adminlist" name="product_category" id="category">
					<?php echo tpl_options($proj->listCategories(), Req::val('product_category')); ?>
				</select>
				</span>
			</li>

			<!-- Status -->
			<?php if (in_array('status', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="status"><?= eL('status') ?></label>
				<span class="value">
				<select id="status" name="item_status" <?php echo tpl_disableif(!$user->perms('modify_all_tasks')); ?>>
					<?php echo tpl_options($proj->listTaskStatuses(), Req::val('item_status', ($user->perms('modify_all_tasks') ? STATUS_NEW : STATUS_UNCONFIRMED))); ?>
				</select>
				</span>
			</li>

			<?php if ($user->perms('modify_all_tasks')): ?>
			<!-- Assigned To -->
			<?php if (in_array('assignedto', $fields)) { ?>
				<li class="wideitem">
			<?php } else { ?>
				<li class="wideitem" style="display:none">
			<?php } ?>
				<label><?= eL('assignedto') ?></label>
				<?php if ($user->perms('modify_all_tasks')): ?>
				<?php $this->display('common.multiuserselect.tpl'); ?>
				<?php endif; ?>
			</li>
			<?php endif; ?>

			<!-- os -->
			<?php if (in_array('os', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="os"><?= eL('operatingsystem') ?></label>
				<span class="value">
				<select id="os" name="operating_system">
					<?php echo tpl_options($proj->listOs(), Req::val('operating_system')); ?>
				</select>
				</span>
			</li>

			<!-- Severity -->
			<?php if (in_array('severity', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="severity"><?= eL('severity') ?></label>
				<span class="value">
				<select onchange="getElementById('edit_summary').className = 'summary severity' + this.value;
													getElementById('itemsummary').className = 'text severity' + this.value;"
													id="severity" class="adminlist" name="task_severity">
					<?php echo tpl_options($fs->severities, Req::val('task_severity', 2)); ?>
				</select>
				</span>
			</li>

			<!-- Priority-->
			<?php if (in_array('priority', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="priority"><?= eL('priority') ?></label>
				<span class="value">
				<select id="priority" name="task_priority" <?php echo tpl_disableif(!$user->perms('modify_all_tasks')); ?>>
					<?php echo tpl_options($fs->priorities, Req::val('task_priority', 4)); ?>
				</select>
				</span>
			</li>

			<!-- Reported Version-->
			<?php if (in_array('reportedin', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="reportedver"><?= eL('reportedversion') ?></label>
				<span class="value">
				<select class="adminlist" name="product_version" id="reportedver">
					<?php echo tpl_options($proj->listVersions(false, 2), Req::val('product_version')); ?>
				</select>
				</span>
			</li>

			<!-- Due Version -->
			<?php if (in_array('dueversion', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="dueversion"><?= eL('dueinversion') ?></label>
				<span class="value">
				<select id="dueversion" name="closedby_version" <?php echo tpl_disableif(!$user->perms('modify_all_tasks')); ?>>
					<option value="0"><?= eL('undecided') ?></option>
					<?php echo tpl_options($proj->listVersions(false, 3),$proj->prefs['default_due_version'], false); ?>
				</select>
				</span>
			</li>

			<?php if ($user->perms('modify_all_tasks')): ?>
			<!-- Due Date -->
			<?php if (in_array('duedate', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="due_date"><?= eL('duedate') ?></label>
				<span class="value">
				<?php echo tpl_datepicker('due_date', '', Req::val('due_date')); ?>
				</span>
			</li>
			<?php endif; ?>

			<?php
				if($proj->prefs['use_effort_tracking'] && $user->perms('view_estimated_effort')) {
			?>
			<li>
				<label for="estimated_effort"><?= eL('estimatedeffort') ?></label>
				<span class="value">
				<input id="estimated_effort" name="estimated_effort" class="text fi-x-small ta-e" type="text" size="5" maxlength="100" value="0:00" />
				<?= eL('hours') ?>
				</span>
			</li>
			<?php
				}
			?>

			<?php if ($user->perms('manage_project')): ?>
			<!-- Private -->
			<?php if (in_array('private', $fields)) { ?>
				<li>
			<?php } else { ?>
				<li style="display:none">
			<?php } ?>
				<label for="private"><?= eL('private') ?></label>
				<span class="value">
				<?php echo tpl_checkbox('mark_private', Req::val('mark_private', 0), 'private'); ?>
				</span>
			</li>
			<?php endif; ?>
		</ul>
	</div>

	<div id="taskdetailsfull">
		<h2><?php echo Filters::noXSS($proj->prefs['project_title']); ?> :: <?= eL('newtask') ?></h2>
		<div>
			<label class="severity<?php echo Filters::noXSS(Req::val('task_severity', 2)); ?> summary" id="edit_summary" for="itemsummary"><?php echo Filters::noXSS(L('summary')); ?></label>
			<div id="itemsummarywrap">
				<input id="itemsummary" required="required" placeholder="<?= eL('summary') ?>" title="<?= eL('tooltipshorttasktitle') ?>" type="text" value="<?php echo Filters::noXSS(Req::val('item_summary')); ?>"
					name="item_summary" maxlength="100" class="fi-stretch" />
			</div>
		</div>
		<?php if ($proj->prefs['use_tags']): ?>
		<div>
			<div id="edit_tags">
				<label for="tags" title="<?= eL('tagsinfo') ?>"><?= eL('tags') ?>:</label>
				<div id="tagsinputwrap">
					<input title="<?= eL('tagsinfo') ?>" placeholder="<?= eL('tags') ?>" type="text" name="tags" id="tags" class="fi-stretch" maxlength="200" value="<?php echo Filters::noXSS(Req::val('tags','')); ?>" />
					<button id="tagstoggle"><span class="fas fa-tags"></span><span class="fas fa-caret-down"></span></button>
				</div>
			</div>
		</div>

		<div id="tags_info">
			<span class="fas fa-circle-exclamation fa-2x"></span>
			<?= eL('tagsinfo') ?>
		</div>

		<div id="tagrender" class="box"></div>
		<fieldset id="availtaglist" style="display: none;">
			<legend><?= eL('tagsavail') ?></legend>
			<?php
			foreach ($taglist as $tagavail) {
							echo tpl_tag($tagavail['tag_id']);
			} ?>
			</fieldset>
		<?php endif; ?>

		<div id="descwrap">
		<?php if (defined('FLYSPRAY_HAS_PREVIEW')): ?>
			<div class="hide preview" id="preview"></div>
			<button tabindex="9" type="button" onclick="showPreview('details', '<?php echo Filters::noJsXSS($baseurl); ?>', 'preview')"><?php echo Filters::noXSS(L('preview')); ?></button>
		<?php endif; ?>
		<?php echo TextFormatter::textarea('detailed_desc', 15, 70, array('id' => 'details', 'class' => 'richtext txta-large'), Req::val('detailed_desc', $proj->prefs['default_task'])); ?>
		</div>

		<ul class="form_elements" style="margin-top: 2em;">
			<?php if ($user->isAnon()): ?>
			<li>
				<label class="inline" for="anon_email"><?= eL('youremail') ?></label>
				<div clas="valuewrap">
					<input type="text" class="text fi-large" id="anon_email" name="anon_email" size="30" required="required" value="<?php echo Filters::noXSS(Req::val('anon_email')); ?>" />
				</div>
			</li>
			<?php endif; ?>
			<?php if (!$user->isAnon()): ?>
			<li>
				<label class="inline left" for="notifyme"><?= eL('notifyme') ?></label>
				<div class="valuewrap">
					<input class="text" type="checkbox" id="notifyme" name="notifyme" value="1" checked="checked" />
			</li>
			<?php endif; ?>
		</ul>

		<?php if ($user->perms('create_attachments')): ?>
		<div id="attachmentsbox">
			<div id="addlinkbox">
				<div>
					<button id="addlinkbox_addalink" tabindex="10" type="button" onclick="addLinkField('addlinkbox')"><?= eL('addalink') ?></button>
					<button id="addlinkbox_addanotherlink" tabindex="10" style="display:none" type="button" onclick="addLinkField('addlinkbox')"><?= eL('addanotherlink') ?></button>
				</div>

				<span class="newitem" style="display: none">
					<input tabindex="8" class="text fi-large" type="text" size="28" maxlength="150" name="userlink[]" />
					<a href="javascript://" class="button" title="<?= eL('remove') ?>" tabindex="9" onclick="removeLinkField(this, 'addlinkbox');"><span class="fas fa-xmark fa-lg"></span></a>
				</span>
				<noscript>
					<span>
						<input tabindex="8" class="text fi-large" type="text" size="28" maxlength="150" name="userlink[]" />
						<a href="javascript://" class="button" title="<?= eL('remove') ?>" tabindex="9" onclick="removeLinkField(this, 'addlinkbox');"><span class="fas fa-xmark fa-lg"></span></a>
					</span>
				</noscript>
			</div>

			<div id="uploadfilebox">
				<div>
					<button id="uploadfilebox_attachafile" tabindex="7" type="button" onclick="addUploadFields('uploadfilebox')">
						<?= eL('uploadafile') ?> (<?= eL('max') ?> <?php echo Filters::noXSS($fs->max_file_size); ?> <?= eL('MiB') ?>)
					</button>
					<button id="uploadfilebox_attachanotherfile" tabindex="7" style="display: none" type="button" onclick="addUploadFields('uploadfilebox')">
						<?= eL('attachanotherfile') ?> (<?= eL('max') ?> <?php echo Filters::noXSS($fs->max_file_size); ?> <?= eL('MiB') ?>)
					</button>
				</div>
				<span class="newitem" style="display: none"><?php // this span is shown/copied in javascript when adding files ?>
					<input tabindex="5" class="file" type="file" size="55" name="userfile[]" />
					<a href="javascript://" class="button" title="<?php echo Filters::noXSS(L('remove')); ?>" tabindex="6" onclick="removeUploadField(this, 'uploadfilebox');"><span class="fas fa-xmark fa-lg"></span></a>
				</span>
				<noscript>
					<span>
						<input tabindex="5" class="file" type="file" size="55" name="userfile[]" />
						<a href="javascript://" class="button" title="<?php echo Filters::noXSS(L('remove')); ?>" tabindex="6" onclick="removeUploadField(this, 'uploadfilebox');"><span class="fas fa-xmark fa-lg"></span></a>
					</span>
				</noscript>
			</div>
		</div>
		<?php endif; ?>

		<div class="buttons">
			<?php if (!$user->perms('modify_all_tasks')): ?>
			<input type="hidden" name="item_status"	 value="1" />
			<input type="hidden" name="task_priority" value="2" />
			<?php endif; ?>
			<input type="hidden" name="action" value="newtask.newtask" />
			<input type="hidden" name="project_id" value="<?php echo Filters::noXSS($proj->id); ?>" />
			<button class="button positive" style="display:block;margin-top:20px" accesskey="s" type="submit"><?= eL('addthistask') ?></button>
		</div>
	</div>
</div>
</form>
