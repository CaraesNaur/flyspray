<?php echo tpl_form(Filters::noXSS(createUrl('details', $task_details['task_id'])),null,null,null,'id="taskeditform"'); ?>
<!-- Grab fields wanted for this project so we can only show those we want -->
<?php $fields = explode( ' ', $proj->prefs['visible_fields'] );
// FIXME The template should respect the ordering of 'visible_fields',
// aren't they?
//
// Maybe define a 'put visible_fields in default ordering'-button in
// project settings to let them make consistent with other projects
// and a no-brainer.
//
// But let also project managers have the choice to sort to the order
// they want it.

// FIXME If user wants a task to be moved to other project and a hidden list value (not in visible_fields) would be not legal in the target project:
// Should we show that dropdown-list even if the field is not in the $fields-array to give the user the chance to resolve the issue?
// The field list dropdown is not a secret for webtech-people, it is just not visible by css display:none;
?>
<div id="taskdetails">
	<input type="hidden" name="action" value="details.update" />
	<input type="hidden" name="edit" value="1" />
	<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
	<input type="hidden" name="edit_start_time" value="<?php echo Filters::noXSS(Req::val('edit_start_time', time())); ?>" />
	<div id="taskfields">
	<ul class="fieldslist">
	<!-- Status -->
	<li class="<?php
		# show the tasktype if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invalidstatus'])
			? 'errorinput' : (
				in_array('status', $fields) ? '' : ' hidden'
		); ?>">
		<label for="status"><?= eL('status') ?></label>
		<span class="value">
		<?php echo tpl_select($statusselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invalidstatus'])) { ?>
		<span class="errormessage"><?= eL('invalidstatus') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Progress -->
	<li class="<?php echo isset($_SESSION['ERRORS']['invalidprogress']) ? 'errorinput' : ''; echo in_array('progress', $fields) ? '' : ' hidden'; ?>">
		<label for="percent"><?php echo Filters::noXSS(L('percentcomplete')); ?></label>
		<span class="value">
		<select id="percent" name="percent_complete" <?php echo tpl_disableif(!$user->perms('modify_all_tasks')) ?>>
		<?php $arr = array(); for ($i = 0; $i<=100; $i+=10) $arr[$i] = $i.'%'; ?>
		<?php echo tpl_options($arr, Req::val('percent_complete', $task_details['percent_complete'])); ?>
		</select>
		<?php if (isset($_SESSION['ERRORS']['invalidprogress'])) { ?>
		<span class="errormessage"><?= eL('invalidprogress') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Task Type -->
	<li class="<?php
		# show the tasktype if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invalidtasktype'])
			? 'errorinput' : (
				in_array('tasktype', $fields) ? '' : ' hidden'
		); ?>">
		<label for="tasktype"><?= eL('tasktype') ?></label>
		<span class="value">
		<?php echo tpl_select($tasktypeselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invalidtasktype'])) { ?>
		<span class="errormessage"><?= eL('invalidtasktype') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Category -->
	<li class="<?php
		# show the category if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invalidcategory'])
			? 'errorinput' : (
				in_array('category', $fields) ? '' : ' hidden'
		); ?>">
		<label for="category"><?= eL('category') ?></label>
		<span class="value">
		<?php echo tpl_select($catselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invalidcategory'])) { ?>
		<span class="errormessage"><?= eL('invalidcategory') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Assigned To -->
	<li class="wideitem<?php echo in_array('assignedto', $fields) ? '' : ' hidden'; ?>">
		<label><?= eL('assignedto') ?></label>
		<span class="value">
		<?php if ($user->perms('edit_assignments')): ?>
			<input type="hidden" name="old_assigned" value="<?php echo Filters::noXSS($old_assigned); ?>" />
		<?php $this->display('common.multiuserselect.tpl'); ?>
		<?php else: ?>
			<?php if (empty($assigned_users)): ?>
				<?= eL('noone') ?>
			<?php else: ?>
			<ul class="assignedto">
			<?php foreach ($assigned_users as $userid): ?>
				<li>
				<span>
				<?php if($fs->prefs['enable_avatars'] == 1): ?>
					<?php echo tpl_userlinkavatar($userid, 24); ?>
				<?php endif; ?>
					<?php echo tpl_userlink($userid); ?>
				</span>
				</li>
			<?php endforeach; ?>
			</ul>
			<?php
			endif;
		endif; ?>
		</span>
	</li>
	<!-- OS -->
	<li class="<?php
		# show the os if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invalidos'])
			? 'errorinput' : (
				in_array('os', $fields) ? '' : ' hidden'
		); ?>">
		<label for="os"><?= eL('operatingsystem') ?></label>
		<span class="value">
		<?php echo tpl_select($osselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invalidos'])) { ?>
		<span class="errormessage"><?= eL('invalidos') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Severity -->
	<li class="<?php echo isset($_SESSION['ERRORS']['invalidseverity']) ? 'errorinput' : ''; echo in_array('severity', $fields) ? '' : ' hidden'; ?>">
		<label for="severity"><?php echo Filters::noXSS(L('severity')); ?></label>
		<span class="value">
		<select id="severity" name="task_severity">
		<?php echo tpl_options($fs->severities, Req::val('task_severity', $task_details['task_severity'])); ?>
		</select>
		<?php if (isset($_SESSION['ERRORS']['invalidseverity'])) { ?>
		<span class="errormessage"><?= eL('invalidseverity') ?>
		<?php } ?>
		</span>
	</li>
	<!-- Priority -->
	<li<?php echo in_array('priority', $fields) ? '' : ' style="display:none"'; ?>>
		<label for="priority" class="<?php echo isset($_SESSION['ERRORS']['invalidpriority']) ? ' errorinput' : ''; ?>"<?php echo isset($_SESSION['ERRORS']['invalidpriority']) ? ' title="'.eL('invalidpriority').'"':''; ?>><?php echo Filters::noXSS(L('priority')); ?></label>
		<span class="value">
		<select id="priority" name="task_priority" <?php echo tpl_disableif(!$user->perms('modify_all_tasks')) ?>>
		<?php echo tpl_options($fs->priorities, Req::val('task_priority', $task_details['task_priority'])); ?>
		</select>
		</span>
	</li>
	<!-- Reported In -->
	<li class="<?php
		# show the reportedversion if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invalidreportedversion'])
			? 'errorinput' : (
				in_array('reportedin', $fields) ? '' : 'hidden'
		); ?>">
		<label for="reportedver"><?= eL('reportedversion') ?></label>
		<span class="value">
		<?php echo tpl_select($reportedversionselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invalidreportedversion'])) { ?>
		<span class="errormessage"><?= eL('invalidreportedversion') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Due Version -->
	<li class="<?php
		# show the dueversion if invalid when moving tasks - even if not in the visible list.
		echo isset($_SESSION['ERRORS']['invaliddueversion'])
			? 'errorinput' : (
				in_array('dueversion', $fields) ? '' : ' hidden'
		); ?>">
		<label for="dueversion"><?= eL('dueinversion') ?></label>
		<span class="value">
		<?php echo tpl_select($dueversionselect); ?>
		<?php if (isset($_SESSION['ERRORS']['invaliddueversion'])) { ?>
		<span class="errormessage"><?= eL('invaliddueversion') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Due Date -->
	<li class="<?php echo isset($_SESSION['ERRORS']['invaliddue_date']) ? 'errorinput' : ''; echo (in_array('duedate', $fields) && $user->perms('modify_all_tasks')) ? '' : ' hidden'; ?>">
		<label for="due_date"><?= eL('duedate') ?></label>
		<span class="value">
		<?php echo tpl_datepicker('due_date', '', Req::val('due_date', $task_details['due_date'])); ?>
		<?php if (isset($_SESSION['ERRORS']['invaliddue_date'])) { ?>
		<span class="errormessage"><?= eL('invalidduedate') ?></span>
		<?php } ?>
		</span>
	</li>
	<!-- Private -->
	<?php if ($user->can_change_private($task_details)): ?>
	<li<?php echo in_array('private', $fields) ? '' : ' class="hidden"'; ?>>
		<label for="private"><?= eL('private') ?></label>
		<span class="value">
		<?php echo tpl_checkbox('mark_private', Req::val('mark_private', $task_details['mark_private']), 'private'); ?>
		</span>
	</li>
	<?php endif; ?>

	<?php if ($proj->prefs['use_effort_tracking'] && $user->perms('view_estimated_effort')): ?>
	<li>
		<label for="estimated_effort"><?= eL('estimatedeffort') ?></label>
		<span class="value">
		<input id="estimated_effort" name="estimated_effort" class="text fi-x-small ta-e" type="text" size="5" maxlength="10" value="<?php echo Filters::noXSS(effort::secondsToEditString($task_details['estimated_effort'], $proj->prefs['hours_per_manday'], $proj->prefs['estimated_effort_format'])); ?>" />
		<?= eL('hours') ?>
		</span>
	</li>
	<?php endif; ?>

	<!-- If no currently selected project is not there, push it on there so don't have to change things -->
	<?php
	$id = Req::val('project_id', $proj->id);
	$selected = false;
	foreach ($fs->projects as $value => $label) {
		if ($label[0] == $id) {
			$selected = true;
			break;
		}
	}

	if (! $selected) {
		$title = '---';
		$foo = array( $id, $title, 'project_id' => $id, 'project_title' => $title);
		array_unshift( $fs->projects,  $foo);
	}

	?>

	<!-- If there is only one choice of projects, then don't bother showing it -->
	<li class="<?php
		# show the targetproject selector if invalid when moving tasks
		echo isset($_SESSION['ERRORS']['invalidtargetproject']) ? 'errorinput' : ''; ?>">
		<label for="project_id"><?= eL('attachedtoproject') ?></label>
		<span class="value">
			<select name="project_id" id="project_id">
			<?php echo tpl_options($fs->projects, Req::val('project_id', $proj->id)); ?>
			</select>
		<?php if (isset($_SESSION['ERRORS']['invalidtargetproject'])) { ?>
			<span class="errormessage"><?= eL('invalidtargetproject') ?></span>
		<?php } ?>
		</span>
	</li>
	</ul>
	<div id="fineprint">
		<div>
			<?= eL('openedby') ?> <?php echo tpl_userlink($task_details['opened_by']); ?>
			 - <span title="<?php echo formatDate($task_details['date_opened'], true); ?>"><?php echo formatDate($task_details['date_opened'], false); ?></span>
		</div>
		<?php if ($task_details['last_edited_by']): ?>
		<div>
			<?= eL('editedby') ?>  <?php echo tpl_userlink($task_details['last_edited_by']); ?>
			- <span title="<?php echo Filters::noXSS(formatDate($task_details['last_edited_time'], true)); ?>"><?php echo Filters::noXSS(formatDate($task_details['last_edited_time'], false)); ?></span>
		</div>
		<?php endif; ?>
	</div>
</div>
<div id="taskdetailsfull">
	<div>
		<label for="itemsummary"<?php echo isset($_SESSION['ERRORS']['summaryrequired']) ? ' class="summary errorinput" title="'.eL('summaryrequired').'"':' class="summary"'; ?>>FS#<?php echo Filters::noXSS($task_details['task_id']); ?> <?php echo Filters::noXSS(L('summary')); ?>:</label>
		<div id="itemsummarywrap">
			<input placeholder="<?= eL('summary') ?>" type="text" name="item_summary" id="itemsummary" class="fi-stretch" maxlength="100" value="<?php echo Filters::noXSS(Req::val('item_summary', $task_details['item_summary'])); ?>" />
		</div>
	</div>

	<?php if ($proj->prefs['use_tags']): ?>
		<?php
		foreach($tags as $tag): $tagnames[]= Filters::noXSS($tag['tag']); endforeach;
		isset($tagnames) ? $tagstring=implode(';',$tagnames) : $tagstring='';
		?>
		<div>
			<label for="tags" title="<?= eL('tagsinfo') ?>"><?= eL('tags') ?>:</label>
			<div id="tagsinputwrap">
				<input placeholder="<?= eL('tags') ?>" type="text" name="tags" id="tags" class="fi-stretch" maxlength="200" value="<?php echo Filters::noXSS(Req::val('tags', $tagstring)); ?>" />
				<button id="tagstoggle"><span class="fas fa-tags"></span><span class="fas fa-caret-down"></span></button>
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
	<?php echo TextFormatter::textarea('detailed_desc', 15, 70, array('id' => 'details', 'class' => 'richtext txta-large'), Req::val('detailed_desc', $task_details['detailed_desc'])); ?>
	<?php
	/* Our CKEditor 4.16 setup has undo/redo plugin and the reset button in this template has no functionality if javascript is enabled */
	if ($conf['general']['syntax_plugin'] == 'html'): ?>
		<noscript><button type="reset"><?= eL('reset') ?></button></noscript>
	<?php else: ?>
		<button type="reset"><?= eL('reset') ?></button>
	<?php endif; ?>
	</div>

	<div id="attachmentsbox">
	<div id="addlinkbox">
	<?php
	$links = $proj->listTaskLinks($task_details['task_id']);
	$this->display('common.editlinks.tpl', 'links', $links); ?>
	<?php if ($user->perms('create_attachments')): ?>
		<input id="link1" tabindex="8" class="text fi-large" type="text" maxlength="150" name="userlink[]" />
		<script>
		// hide the fallback input field if javascript is enabled
		document.getElementById("link1").style.display='none';
		</script>
		<div>
			<button id="addlinkbox_addalink" tabindex="10" type="button" onclick="addLinkField('addlinkbox')">
				<?= eL('addalink') ?>
			</button>
			<button id="addlinkbox_addanotherlink" tabindex="10" style="display: none" type="button" onclick="addLinkField('addlinkbox')">
				<?= eL('addanotherlink') ?>
			</button>
		</div>
		<span class="newitem" style="display: none"><?php /* this span is shown/copied by javascript when adding links */ ?>
			<input tabindex="8" class="text fi-large" type="text" maxlength="150" name="userlink[]" />
			<a href="javascript://" tabindex="9" class="button" title="<?= eL('remove') ?>" onclick="removeLinkField(this, 'addlinkbox');"><span class="fas fa-xmark fa-lg"></span></a>
		</span>
	<?php endif; ?>
	</div>
	<div id="uploadfilebox">
	<?php
	$attachments = $proj->listTaskAttachments($task_details['task_id']);
	$this->display('common.editattachments.tpl', 'attachments', $attachments);
	if ($user->perms('create_attachments')): ?>
		<input id="file1" tabindex="5" class="file" type="file" size="55" name="usertaskfile[]" />
		<script>
		// hide the fallback input field if javascript is enabled
		document.getElementById("file1").style.display='none';
		</script>
		<div>
			<button id="uploadfilebox_attachafile" tabindex="7" type="button" onclick="addUploadFields()">
				<?= eL('uploadafile') ?> (<?= eL('max') ?> <?php echo Filters::noXSS($fs->max_file_size); ?> <?= eL('MiB') ?>)
			</button>
			<button id="uploadfilebox_attachanotherfile" tabindex="7" style="display: none" type="button" onclick="addUploadFields()">
				<?= eL('attachanotherfile') ?> (<?= eL('max') ?> <?php echo Filters::noXSS($fs->max_file_size); ?> <?= eL('MiB') ?>)
			</button>
		</div>
		<span class="newitem" style="display: none"><?php /* this span is shown/copied by javascript when adding files */ ?>
			<input tabindex="5" class="file" type="file" size="55" name="usertaskfile[]" />
			<a href="javascript://" tabindex="6" class="button" title="<?= eL('remove') ?>" onclick="removeUploadField(this);"><span class="fas fa-xmark fa-lg"></span></a>
		</span>
	<?php endif; ?>
	</div>
	</div>

	<?php if ($user->perms('add_comments') && (!$task_details['is_closed'] || $proj->prefs['comment_closed'])): ?>
	<div>
		<label class="button" id="toggle_add_comment"><?= eL('addcomment') ?><span class="fas fa-comment"></span></label>
		<div id="edit_add_comment" style="display:none;">
			<label for="comment_text"><?php echo Filters::noXSS(L('comment')); ?></label>
			<textarea accesskey="r" tabindex="8" id="comment_text" name="comment_text" class="txta-small" cols="50" rows="6" disabled="disabled"></textarea>
		</div>
	</div>
	<?php endif; ?>

	<div class="buttons">
		<button type="submit" class="positive" accesskey="s" onclick="return checkok('<?php echo Filters::noJsXSS($baseurl); ?>js/callbacks/checksave.php?time=<?php echo Filters::noXSS(time()); ?>&amp;task_id=<?php echo Filters::noXSS($task_details['task_id']); ?>', '<?php echo Filters::noJsXSS(L('alreadyedited')); ?>', 'taskeditform')"><?php echo Filters::noXSS(L('savedetails')); ?></button>
		<a class="button" href="<?php echo Filters::noXSS(createUrl('details', $task_details['task_id'])); ?>"><?= eL('canceledit') ?></a>
	</div>
</div>
</div>
</form>
