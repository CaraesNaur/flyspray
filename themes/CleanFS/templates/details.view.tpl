<div id="actionbar">
<?php if ($task_details['is_closed']): /* if task is closed */ ?>
	<?php if ($user->can_close_task($task_details)): ?>
		<div class="actionitem" id="reopentaskitem">
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
			<input type="hidden" name="action" value="reopen" />
			<button><?php echo L('reopenthistask'); ?></button>
			</form>
		</div>
	<?php elseif (!$user->isAnon() && !Flyspray::adminRequestCheck(2, $task_details['task_id'])): ?>
		<div class="actionitem" id="requestreopenitem">
			<button class="submit main" id="reqreopentask"><?= eL('reopenrequest') ?> ...</button>
			<div id="requestreopen" class="popup hide">
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),'form3',null,null,'id="formclosetask"'); ?>
				<label for="reason"><?= eL('reasonforreq') ?></label>
				<textarea id="reason" name="reason_given" class="txta-small"></textarea>
				<div class="buttons">
				<input type="hidden" name="action" value="requestreopen" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<button type="submit"><?= eL('submitreq') ?></button>
				</div>
				</form>
			</div>
		</div>
	<?php endif; ?>
<?php else:  /* if task is open */ ?>
	<?php if ($user->can_close_task($task_details) && !$d_open): ?>
	<div class="actionitem" id="closetaskitem">
		<a href="<?php echo Filters::noXSS(createURL('details', $task_details['task_id'], null, array('showclose' => !Req::val('showclose')))); ?>"
		id="closetask" class="button main" accesskey="y"><?= eL('closetask') ?> ...</a>

		<div id="closeform" class="<?php if (Req::val('action') != 'details.close' && !Req::val('showclose')): ?>hide <?php endif; ?>popup">
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'id="formclosetask"'); ?>
			<div>
			<select class="adminlist" name="resolution_reason" onmouseup="event.stopPropagation();">
				<option value="0"><?= eL('selectareason') ?></option>
				<?php echo tpl_options($proj->listResolutions(), Req::val('resolution_reason')); ?>
			</select>
			</div>
			<div>
			<label class="text" for="closure_comment"><?= eL('closurecomment') ?></label>
			<textarea class="text txta-small" id="closure_comment" name="closure_comment" rows="3" cols="25"><?php echo Filters::noXSS(Req::val('closure_comment')); ?></textarea>
			<?php if($task_details['percent_complete'] != '100'): ?>
				<div>
					<?php echo tpl_checkbox('mark100', Req::val('mark100', !(Req::val('action') == 'details.close')), 'mark100'); ?>
					<label for="mark100"><?= eL('mark100') ?></label>
				</div>
			<?php endif; ?>
			</div>
			<div class="buttons">
			<input type="hidden" name="action" value="details.close"/>
			<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>"/>
			<button type="submit"><?= eL('closetask') ?></button>
			</div>
			</form>
		</div>
	</div>
	<?php elseif (!$d_open && !$user->isAnon() && !Flyspray::adminRequestCheck(1, $task_details['task_id'])): ?>
	<div class="actionitem" id="requestcloseitem">
		<a id="reqclosetask" class="button main"><?= eL('requestclose') ?> ...</a>
		<div id="reqcloseform" class="popup hide">
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])), 'form3', null, null, 'id="formclosetask"'); ?>
			<label for="reason"><?= eL('reasonforreq') ?></label>
			<textarea id="reason" class="txta-small" name="reason_given"></textarea>
			<div class="buttons">
			<input type="hidden" name="action" value="requestclose"/>
			<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>"/>
			<button type="submit"><?= eL('submitreq') ?></button>
			</div>
			</form>
		</div>
	</div>
	<?php elseif(!$user->isAnon()): ?>
	<div class="actionitem" id="requestclosedisableditem">
		<a id="reqclosedisabled" class="button"><?= eL('closetask') ?><span class="fas fa-exclamation-triangle fa-lg"></span></a>
		<div id="reqclosedinfo" class="popup hide">
			<h4><span class="fas fa-circle-info fa-lg"></span><?= eL('information') ?></h4>
			<p><?= eL('taskclosedisabled') ?></p>
			<ul>
		<?php
			foreach ($deps as $dependency) {
				echo "<li>" . tpl_tasklink($dependency['task_id']) ."</li>";
			}
		?>
			</ul>
		</div>
	</div>
	<?php endif; ?>

	<?php if ($user->can_edit_task($task_details)): ?>
	<div class="actionitem" id="edittaskitem">
		<a id="edittask" class="button" accesskey="e" href="<?php echo Filters::noXSS(createURL('edittask', $task_details['task_id'])); ?>"> <?= eL('edittask') ?></a>
	</div>
	<?php endif; ?>

	<?php if ($user->can_take_ownership($task_details)): ?>
	<div class="actionitem" id="assigntomeitem">
		<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])), null, null, null, 'style="display:inline"'); ?>
		<input type="hidden" name="action" value="takeownership" />
		<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
		<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
		<button type="submit" id="own"><?= eL('assigntome') ?></button>
		</form>
	</div>
	<?php endif; ?>

	<?php if ($user->can_add_to_assignees($task_details) && !empty($task_details['assigned_to'])): ?>
	<div class="actionitem" id="addmetoassigneesitem">
		<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'style="display:inline"'); ?>
		<input type="hidden" name="action" value="addtoassignees" />
		<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
		<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
		<button type="submit" id="own_add"><?= eL('addmetoassignees') ?></button>
		</form>
	</div>
	<?php endif; ?>

	<div class="actionitem" id="quickactionsitem">
		<button id="actions"><?= eL('quickaction') ?></button>
		<div id="actionsform" style="display: none;">
			<ul>
			<?php if ($user->can_edit_task($task_details)): ?>
			<li>
				<a accesskey="e" href="<?php echo Filters::noXSS(createURL('edittask', $task_details['task_id'])); ?>"><span class="fas fa-pen fa-lg"></span><?= eL('edittask') ?> <span class="fas fa-arrow-right"></span></a>
			</li>
			<?php endif; ?>

			<?php if ($user->can_set_task_parent($task_details)): ?>
			<li>
				<input type="checkbox" id="s_parent" /><label for="s_parent"><span class="fas fa-turn-up fa-flip-horizontal fa-lg"></span><?= eL('setparent') ?> ...</label>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'id="setparentform"'); ?>
				<label for="supertask_id"><?= eL('parenttaskid') ?></label>
				<input type="hidden" name="action" value="details.setparent" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				FS# <input class="text fi-x-small" type="text" value="" id="supertask_id" name="supertask_id" size="5" maxlength="10" />
				<button type="submit" name="submit"><?= eL('set') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($user->can_associate_task($task_details)): ?>
			<li><input type="checkbox" id="s_associate"/><label for="s_associate"><span class="fas fa-turn-down fa-lg"></span><?= eL('associatesubtask') ?> ...</label>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'id="associateform"'); ?>
				<label for="associate_subtask_id"><?= eL('associatetaskid') ?></label>
				<input type="hidden" name="action" value="details.associatesubtask"/>
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>"/>
				FS# <input class="text fi-x-small" type="text" value="" id="associate_subtask_id" name="associate_subtask_id" size="5" maxlength="10"/>
				<button type="submit" name="submit"><?= eL('set') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($proj->id && $user->perms('open_new_tasks')): ?>
			<li>
				<a href="<?php echo Filters::noXSS(createURL('newtask', $proj->id, $task_details['task_id'])); ?>"><span class="fas fa-square-plus fa-lg"></span><?= eL('addnewsubtask') ?> <span class="fas fa-arrow-right"></span></a>
			</li>
			<?php endif; ?>

			<li>
				<a href="<?php echo Filters::noXSS(createURL('depends', $task_details['task_id'])); ?>"><span class="fas fa-diagram-project fa-lg"></span><?= eL('depgraph') ?> <span class="fas fa-arrow-right"></span></a>
			</li>

			<?php if ($user->can_add_task_dependency($task_details)): ?>
			<li>
				<input type="checkbox" id="s_adddependent"/><label for="s_adddependent"><span class="fas fa-clipboard-check fa-lg"></span><?= eL('adddependenttask') ?> ...</label>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'id="adddepform"'); ?>
				<input type="hidden" name="action" value="details.newdep" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<label for="dep_task_id"><?= eL('newdependency') ?></label>
				FS# <input class="text fi-x-small" type="text" value="<?php echo Filters::noXSS(Req::val('dep_task_id')); ?>" id="dep_task_id" name="dep_task_id" size="5" maxlength="10" />
				<button type="submit" name="submit"><?= eL('add') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($user->can_take_ownership($task_details)): ?>
			<li>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<input type="hidden" name="action" value="takeownership" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<button class="actionbutton" type="submit"><span class="fas fa-person-circle-check fa-lg"></span><?= eL('assigntome') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($user->can_add_to_assignees($task_details) && !empty($task_details['assigned_to'])): ?>
			<li>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<input type="hidden" name="action" value="addtoassignees" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<button class="actionbutton" type="submit"><span class="fas fa-person-circle-plus fa-lg"></span><?= eL('addmetoassignees') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($user->can_vote($task_details) > 0): ?>
			<li>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<input type="hidden" name="action" value="details.addvote" />
				<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<button class="actionbutton" type="submit"><span class="fas fa-star fa-lg"></span><?= eL('voteforthistask') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if (!$user->isAnon() && !$watched): ?>
			<li>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<input type="hidden" name="action" value="details.add_notification" />
				<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
				<input type="hidden" name="user_id" value="<?php echo Filters::noXSS($user->id); ?>" />
				<button class="actionbutton" type="submit"><span class="fas fa-eye fa-lg"></span><?= eL('watchthistask') ?></button>
				</form>
			</li>
			<?php endif; ?>

			<?php if ($user->can_change_private($task_details)): ?>
			<li>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<?php if ($task_details['mark_private']): ?>
					<input type="hidden" name="action" value="makepublic"/>
					<button><span class="fas fa-door-open"></span><?php echo eL('makepublic') ?></button>
				<?php elseif (!$task_details['mark_private']): ?>
					<input type="hidden" name="action" value="makeprivate"/>
					<button class="actionbutton"><span class="fas fa-door-closed fa-lg"></span><?php echo eL('privatethistask') ?></button>
				<?php endif; ?>
				</form>
			</li>
			<?php endif; ?>
			</ul>
		</div>
	</div>
	<?php endif; ?>
</div>
<!-- end actionbar -->

<?php if ($user->can_edit_task($task_details)): ?>
<script type="text/javascript">
function show_hide(elem, flag)
{
	elem.style.display = "none";
	if(flag)
		elem.nextElementSibling.style.display = "block";
	else
		elem.previousElementSibling.style.display = "block";
}
function quick_edit(elem, id)
{
	var e = document.getElementById(id);
	var name = e.name;
	var value = e.value;
	var text;
	if(e.selectedIndex != null)
		text = e.options[e.selectedIndex].text;
	else
		text = document.getElementById(id).value; // for due date and estimated effort
	var xmlHttp = new XMLHttpRequest();

	xmlHttp.onreadystatechange = function(){
		if(xmlHttp.readyState == 4){
			var target = elem.previousElementSibling;
			if (xmlHttp.status == 200) {
				if (target.getElementsByClassName('progress_bar_container').length > 0) {
					target.getElementsByTagName('span')[0].innerHTML = text;
					target.getElementsByClassName('progress_bar')[0].style.width = text;
				} else {
					target.innerHTML = text + ' <i class="fas fa-check"></i>';
				}
				//target.className='fas fa-check';
				//elem.className='fas fa-check';
				show_hide(elem, false);
			} else {
				// TODO show error message returned from the server and let quickedit form open
				//target.className='fas fa-triangle-exclamation';
				elem.className='fas fa-triangle-exclamation';
			}
		}
	}
	xmlHttp.open("POST", "<?php echo Filters::noXSS($baseurl); ?>js/callbacks/quickedit.php", true);
	xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
	xmlHttp.send("name=" + name + "&value=" + value + "&task_id=<?php echo Filters::noXSS($task_details['task_id']); ?>&csrftoken=<?php echo $_SESSION['csrftoken'] ?>");
}
</script>
<?php endif; ?>

<!-- Grab fields wanted for this project so we can only show those we want -->
<?php $fields = explode(' ', $proj->prefs['visible_fields']); ?>

<div id="taskdetails">
	<div id="taskfields">
		<?php if ($prev_id || $next_id): ?>
		<div id="navigation">
			<?php if ($prev_id): ?>
				<?php echo tpl_tasklink($prev_id, L('previoustask'), false, array('id'=>'prev', 'accesskey' => 'p')); ?>
			<?php endif; ?>

			<?php if ($prev_id && $next_id): ?> | <?php endif; ?>
			<?php if(isset($_COOKIE['tasklist_type']) && $_COOKIE['tasklist_type'] == 'project'):
				$params = $_GET; unset($params['do'], $params['action'], $params['task_id'], $params['switch'], $params['project']);
			?>
			<a href="<?php echo Filters::noXSS(createURL('project', $proj->id, null, array('do' => 'index') + $params)); ?>"><?= eL('tasklist') ?></a>
			<?php endif; ?>
			<?php if ($next_id): ?>
				<?php echo tpl_tasklink($next_id, L('nexttask'), false, array('id'=>'next', 'accesskey' => 'n')); ?>
			<?php endif; ?>
		</div>
		<?php endif; ?>

	<?php if($user->can_edit_task($task_details)) : ?>
		<div id="quickedithint" align="center"><?= eL('clicktoedit') ?></div>
	<?php endif; ?>

	<ul class="fieldslist">
	<!-- Status -->
	<?php if (in_array('status', $fields)): ?>
	<li>
		<span class="label"><?= eL('status') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
		<?php if ($task_details['is_closed']): ?>
			<?= eL('closed') ?>
		<?php else: ?>
			<?= Filters::noXSS($task_details['status_name']) ?>
			<?php if ($reopened): ?>
			&nbsp; <strong class="reopened"><?= eL('reopened') ?></strong>
			<?php endif; ?>
		<?php endif; ?>
		</span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="status" name="item_status">
					<?php echo tpl_options($proj->listTaskStatuses(), Req::val('item_status', $task_details['item_status'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'status')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a onclick="show_hide(this.parentNode.parentNode, false)" href="javascript:void(0)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Progress -->
	<?php if (in_array('progress', $fields)): ?>
	<li>
		<span class="label"><?= eL('percentcomplete') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
			<div class="progress_bar_container" style="width: 90px">
				<span><?php echo Filters::noXSS($task_details['percent_complete']); ?>%</span>
				<div class="progress_bar" style="width:<?php echo Filters::noXSS($task_details['percent_complete']); ?>%"></div>
			</div>
		</span>
		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="percent" name="percent_complete">
					<?php $arr = array(); for ($i = 0; $i<=100; $i+=10) $arr[$i] = $i.'%'; ?>
					<?php echo tpl_options($arr, Req::val('percent_complete', $task_details['percent_complete'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'percent')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Task Type -->
	<?php if (in_array('tasktype', $fields)): ?>
	<li>
		<span class="label"><?= eL('tasktype') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value"><?php echo Filters::noXSS($task_details['tasktype_name']); ?></span>
		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="tasktype" name="task_type">
					<?php echo tpl_options($proj->listTaskTypes(), Req::val('task_type', $task_details['task_type'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'tasktype')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</span>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Category -->
	<?php if (in_array('category', $fields)): ?>
		<li>
		<span class="label"><?= eL('category') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
			<?php foreach ($parent as $cat): ?>
				<?php echo Filters::noXSS($cat['category_name']); ?> &#8594;
			<?php endforeach; ?>
			<?php echo Filters::noXSS($task_details['category_name']); ?>
		</span>
		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="category" name="product_category">
					<?php echo tpl_options($proj->listCategories(), Req::val('product_category', $task_details['product_category'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'category')" href="javascript:void(0)" class="button"><?= L('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
		</li>
	<?php endif; ?>

	<!-- Assigned To -->
	<?php if (in_array('assignedto', $fields)): ?>
	<li>
		<span class="label"><?= eL('assignedto') ?></span>
		<span class="value">
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
		<?php endif; ?>
		</span>
	</li>
	<?php endif; ?>

	<!-- OS -->
	<?php if (in_array('os', $fields)): ?>
	<li>
		<span class="label"><?= eL('operatingsystem') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif;?> class="value"><?php echo Filters::noXSS($task_details['os_name']); ?></span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="os" name="operating_system">
					<?php echo tpl_options($proj->listOs(), Req::val('operating_system', $task_details['operating_system'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'os')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Severity -->
	<?php if (in_array('severity', $fields)): ?>
	<li>
		<span class="label"><?= eL('severity') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif;?> class="value"><?php echo Filters::noXSS($task_details['severity_name']); ?></span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
			<select id="severity" name="task_severity">
				<?php echo tpl_options($fs->severities, Req::val('task_severity', $task_details['task_severity'])); ?>
			</select>
			<a onclick="quick_edit(this.parentNode.parentNode, 'severity')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
			<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Priority -->
	<?php if (in_array('priority', $fields)): ?>
	<li>
		<span class="label"><?= eL('priority') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value"><?php echo Filters::noXSS($task_details['priority_name']); ?></span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="priority" name="task_priority">
					<?php echo tpl_options($fs->priorities, Req::val('task_priority', $task_details['task_priority'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'priority')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Reported In -->
	<?php if (in_array('reportedin', $fields)): ?>
	<li>
		<span class="label"><?= eL('reportedversion') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
			<?php echo Filters::noXSS($task_details['reported_version_name']); ?>
		</span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="reportedver" name="product_version">
					<?php echo tpl_options($proj->listVersions(false, 2, $task_details['product_version']), Req::val('reportedver', $task_details['product_version'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'reportedver')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Due Version -->
	<?php if (in_array('dueversion', $fields)): ?>
	<li>
		<span class="label"><?= eL('dueinversion') ?></span>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
			<?php if ($task_details['due_in_version_name']): ?>
			<?php echo Filters::noXSS($task_details['due_in_version_name']); ?>
			<?php else: ?>
			<?= eL('undecided') ?>
			<?php endif; ?>
		</span>
		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<select id="dueversion" name="closedby_version">
					<option value="0"><?= eL('undecided') ?></option>
					<?php echo tpl_options($proj->listVersions(false, 3), Req::val('closedby_version', $task_details['closedby_version'])); ?>
				</select>
				<a onclick="quick_edit(this.parentNode.parentNode, 'dueversion')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Due Date -->
	<?php if (in_array('duedate', $fields)): ?>
	<li>
		<span class="label"><?= eL('duedate') ?></span>
		<?php
		$days = floor((strtotime(date('c', $task_details['due_date'])) - strtotime(date('Y-m-d'))) / (60 * 60 * 24));
		$due='';
		$dueclass='';
		if ($task_details['due_date'] > 0) {
			if ($days < $fs->prefs['days_before_alert'] && $days > 0) {
				$due=$days.' '.L('daysleft');
				$dueclass=' duewarn';
			} elseif ($days < 0) {
				$due=str_replace('-', '', $days).' '.L('dayoverdue');
				$dueclass=' overdue';
			} elseif ($days == 0) {
				$due=L('duetoday');
				$dueclass=' duetoday';
			} else {
				$due= $days.' '.L('daysleft');
			}
		}
		?>
		<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value<?= $dueclass ?>">
			<?php echo Filters::noXSS(formatDate($task_details['due_date'], false, L('undecided'))); ?>
			<br/>
			<span><?= Filters::noXSS($due) ?></span>
		</span>

		<?php if ($user->can_edit_task($task_details)): ?>
		<div class="editvalue">
			<div>
				<?php echo tpl_datepicker('due_date', '', Req::val('due_date', $task_details['due_date'])); ?>
				<a onclick="quick_edit(this.parentNode.parentNode, 'due_date')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
		</div>
		<?php endif; ?>
	</li>
	<?php endif; ?>

	<!-- Effort Tracking -->
	<?php if ($proj->prefs['use_effort_tracking']): ?>
		<?php if ($user->perms('view_estimated_effort')): ?>
		<li>
			<span class="label"><?= eL('estimatedeffort') ?></span>
			<span <?php if ($user->can_edit_task($task_details)): ?>onclick="show_hide(this, true)"<?php endif; ?> class="value">
			<?php
				$displayedeffort = effort::secondsToString($task_details['estimated_effort'], $proj->prefs['hours_per_manday'], $proj->prefs['estimated_effort_format']);
				if (empty($displayedeffort)) {
					$displayedeffort = eL('undecided');
				}
				echo $displayedeffort;
			?>
			</span>
			<?php if ($user->can_edit_task($task_details)): ?>
			<div class="editvalue">
			<div>
				<input type="text" size="15" class="fi-x-small ta-e" id="estimatedeffort" name="estimated_effort" value="<?php echo effort::SecondsToEditString($task_details['estimated_effort'], $proj->prefs['hours_per_manday'], $proj->prefs['estimated_effort_format']); ?>" />
				<a onclick="quick_edit(this.parentNode.parentNode, 'estimatedeffort')" href="javascript:void(0)" class="button"><?= eL('confirmedit') ?></a>
				<a href="javascript:void(0)" onclick="show_hide(this.parentNode.parentNode, false)" class="button"><?= eL('canceledit') ?></a>
			</div>
			</div>
			<?php endif; ?>
		</li>
		<?php endif; ?>

		<?php if ($user->perms('view_current_effort_done')): ?>
		<li>
			<span class="label"><?= eL('currenteffortdone') ?></span>
			<?php
			$total_effort = 0;
			foreach ($effort->details as $details) {
				$total_effort += $details['effort'];
			}
			?>
			<span class="value">
				<?php echo effort::secondsToString($total_effort, $proj->prefs['hours_per_manday'], $proj->prefs['current_effort_done_format']); ?>
			</span>
		</li>
		<?php endif; ?>
	<?php endif; ?>

	<!-- Votes -->
	<?php if (in_array('votes', $fields)): ?>
	<li class="votes">
		<span class="label"><?= eL('votes') ?></span>
		<span class="value">
		<?php if (count($votes)): ?>
			<a href="javascript:showhidestuff('showvotes')"><?php echo Filters::noXSS(count($votes)); ?> </a>
			<div id="showvotes" class="hide">
				<ul class="reports">
				<?php foreach ($votes as $vote): ?>
				<li><?php echo tpl_userlink($vote); ?> (<?php echo Filters::noXSS(formatDate($vote['date_time'])); ?>)</li>
				<?php endforeach; ?>
				</ul>
			</div>
		<?php endif; ?>
		<?php if ($user->can_vote($task_details) > 0): ?>
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id'])),null,null,null,'style="display:inline"'); ?>
			<input type="hidden" name="action" value="details.addvote" />
			<input type="hidden" name="task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
			<button class="fakelinkbutton" type="submit" title="<?= eL('addvote') ?>">+1</button>
			</form>
		<?php elseif ($user->can_vote($task_details) == -2): ?>	(<?= eL('alreadyvotedthistask') ?>)
		<?php elseif ($user->can_vote($task_details) == -3): ?> (<?= eL('alreadyvotedthisday') ?>)
		<?php elseif ($user->can_vote($task_details) == -4): ?> (<?= eL('votelimitreached') ?>)
		<?php endif; ?>
		</span>
	</li>
	<?php endif; ?>

	<!-- Private -->
	<?php if (in_array('private', $fields)): ?>
	<li>
		<span class="label"><?= eL('private') ?></span>
		<span class="value">
		<?php if ($user->can_change_private($task_details) && $task_details['mark_private']): ?>
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
			<input type="hidden" name="action" value="makepublic"/>
			<button type="submit" class="fakelinkbutton"><?php echo ucfirst(eL('makepublic')); ?></button>
			</form>
			<?php elseif ($user->can_change_private($task_details) && !$task_details['mark_private']): ?>
				<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
				<input type="hidden" name="action" value="makeprivate"/>
				<button type="submit" class="fakelinkbutton"><?php echo ucfirst(eL('makeprivate')); ?></button>
				</form>
			<?php endif; ?>
		</span>
	</li>
	<?php endif; ?>

	<!-- Watching -->
	<?php if (!$user->isAnon()): ?>
	<li>
		<span class="label"><?= eL('watching') ?></span>
		<span class="value">
			<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
			<input type="hidden" name="ids" value="<?php echo Filters::noXSS($task_details['task_id']); ?>"/>
			<input type="hidden" name="user_id" value="<?php echo Filters::noXSS($user->id); ?>"/>
			<?php if (!$watched): ?>
				<input type="hidden" name="action" value="details.add_notification"/>
				<button type="submit" accesskey="w" class="fakelinkbutton"><?php echo ucfirst(eL('watchtask')); ?></button>
			<?php else: ?>
				<input type="hidden" name="action" value="remove_notification"/>
				<button type="submit" accesskey="w" class="fakelinkbutton"><?php echo ucfirst(eL('stopwatching')); ?></button>
			<?php endif; ?>
			</form>
		</span>
	</li>
	<?php endif; ?>
	</ul>

	<div id="fineprint">
	<p><?= eL('attachedtoproject') ?>: <a
		href="<?php echo Filters::noXSS($_SERVER['SCRIPT_NAME']); ?>?project=<?php echo Filters::noXSS($task_details['project_id']); ?>"><?php echo Filters::noXSS($task_details['project_title']); ?></a>
	</p>
	<p><?= eL('openedby') ?> <?php echo tpl_userlink($task_details['opened_by']); ?>

	<?php if ($task_details['anon_email'] && $user->perms('view_tasks')): ?>
		(<?php echo Filters::noXSS($task_details['anon_email']); ?>)
	<?php endif; ?>
	-
	<span title="<?php echo Filters::noXSS(formatDate($task_details['date_opened'], true)); ?>"><?php echo Filters::noXSS(formatDate($task_details['date_opened'], false)); ?></span></p>
	<?php if ($task_details['last_edited_by']): ?>
		<p>
		<?= eL('editedby') ?> <?php echo tpl_userlink($task_details['last_edited_by']); ?>
			-
		<span title="<?php echo Filters::noXSS(formatDate($task_details['last_edited_time'], true)); ?>"><?php echo Filters::noXSS(formatDate($task_details['last_edited_time'], false)); ?></span>
		</p>
	<?php endif; ?>
	</div>
</div>

<div id="taskdetailsfull">
	<h2 class="summary severity<?php echo Filters::noXSS($task_details['task_severity']); ?>">
	FS#<?php echo Filters::noXSS($task_details['task_id']); ?> - <?php echo Filters::noXSS($task_details['item_summary']); ?>
	</h2>

	<div class="tags box"><?php foreach($tags as $tag): ?>
		<?= tpl_tag($tag['tag_id'], false, $tag['added'], $tag['added_by']) ?>
		<?php endforeach; ?></div>
	<div id="taskdetailstext"><?php echo $task_text; ?></div>

	<?php
		$attachments = $proj->listTaskAttachments($task_details['task_id']);
		$this->display('common.attachments.tpl', 'attachments', $attachments);
	?>

	<?php
		$links = $proj->listTaskLinks($task_details['task_id']);
		$this->display('common.links.tpl', 'links', $links);
	?>

	<?php if (!$task_details['supertask_id'] == 0) {
		$supertask = Flyspray::getTaskDetails($task_details['supertask_id'], true);
		if ($user->can_view_task($supertask)) {
			?><p class="supertask"><span class ="fas fa-circle-info fa-2x"></span> <?php echo eL('taskissubtaskof').' '.tpl_tasklink($supertask);?></p><?php
		}
	} ?>
</div>

<?php if(count($deps) > 0 || count($blocks) > 0 || count($subtasks) > 0): ?>
<div id="taskinfo">

<!-- The task depends upon: -->
<?php if(count($deps) > 0): ?>
	<h3><?php echo (count($deps)==1) ? eL('taskdependsontask') : eL('taskdependsontasks'); ?></h3>

	<table id="dependency_table" class="table" width="100%">
	<thead>
	<tr>
<?php /*
		<th><?= eL('id') ?></th>
		<th><?= eL('project') ?></th>
*/ ?>
		<th><?= eL('summary') ?></th>
		<th><?= eL('priority') ?></th>
		<th><?= eL('severity') ?></th>
		<th><?= eL('assignedto') ?></th>
		<th><?= eL('progress') ?></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<?php foreach ($deps as $dependency): ?>
	<tr class="severity<?php echo Filters::noXSS($dependency['task_severity']); ?>">
<?php /*
	<td><?php echo $dependency['task_id'] ?></td>
	<td><?php echo $dependency['project_title'] ?></td>
*/ ?>
	<td class="task_summary">
		<?php if ($task_details['project_id'] != $dependency['project_id']) : ?>
		<div class="otherprojtitle"><?php echo $dependency['project_title'] ?></div>
		<?php endif; ?>
		<?php echo tpl_tasklink($dependency['task_id']); ?>
	</td>
	<td><?php echo $fs->priorities[$dependency['task_priority']] ?></td>
	<td class="task_severity"><?php echo $fs->severities[$dependency['task_severity']] ?></td>
	<td><?php
		$assignedcount=count($dependency['assigned_to']);
		if ($assignedcount> 0) {
			for ($i=0; $i< $assignedcount; $i++) {
				if ($i>0) {
					echo ", ";
				}
				echo $dependency['assigned_to'][$i];
			}
		}
		else {
			echo eL('noone');
		}
	?></td>
	<td class="task_progress">
		<div class="progress_bar_container">
			<span><?php echo Filters::noXSS($dependency['percent_complete']); ?>%</span>
			<div class="progress_bar" style="width:<?php echo Filters::noXSS($dependency['percent_complete']); ?>%"></div>
		</div>
	</td>
	<td>
		<?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
		<input type="hidden" name="depend_id" value="<?php echo Filters::noXSS($dependency['depend_id']); ?>" />
		<input type="hidden" name="return_task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
		<input type="hidden" name="action" value="removedep" />
		<button type="submit" title="<?= eL('remove') ?>" class="fas fa-link-slash"></button>
		</form>
	</td>
	</tr>
	<?php endforeach; ?>
	</tbody>
	</table>
<?php endif; ?>

<!-- This task blocks the following tasks: -->
<?php if(count($blocks) > 0): ?>
	<h3><?php echo (count($blocks)==1) ? eL('taskblock') : eL('taskblocks'); ?></h3>

	<table id="blocking_table" class="table" width="100%">
	<thead>
	<tr>
<?php /*
		<th><?= eL('id') ?></th>
		<th><?= eL('project') ?></th>
*/ ?>
		<th><?= eL('summary') ?></th>
		<th><?= eL('priority') ?></th>
		<th><?= eL('severity') ?></th>
		<th><?= eL('assignedto') ?></th>
		<th><?= eL('progress') ?></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<?php foreach ($blocks as $dependency): ?>
	<tr class="severity<?php echo Filters::noXSS($dependency['task_severity']); ?>">
<?php /*
		<td><?php echo $dependency['task_id'] ?></td>
		<td><?php echo $dependency['project_title'] ?></td>
*/ ?>
		<td class="task_summary">
			<?php if ($task_details['project_id'] != $dependency['project_id']) : ?>
			<div class="otherprojtitle"><?php echo $dependency['project_title'] ?></div>
			<?php endif; ?>
			<?php echo tpl_tasklink($dependency['task_id']); ?>
		</td>
		<td><?php echo $fs->priorities[$dependency['task_priority']] ?></td>
		<td class="task_severity"><?php echo $fs->severities[$dependency['task_severity']] ?></td>
		<td><?php
		$depassignedcount = count($dependency['assigned_to']);
		if ($depassignedcount > 0) {
			for ($i = 0; $i < $depassignedcount; $i++) {
				if ($i>0) {
					echo ", ";
				}
				echo $dependency['assigned_to'][$i];
			}
		} else {
			echo eL('noone');
		}
		?></td>
		<td class="task_progress">
			<div class="progress_bar_container">
			<span><?php echo Filters::noXSS($dependency['percent_complete']); ?>%</span>
			<div class="progress_bar" style="width:<?php echo Filters::noXSS($dependency['percent_complete']); ?>%"></div>
			</div>
		</td>
		<td>
		<?php echo tpl_form(Filters::noXSS(createURL('details', $dependency['task_id']))); ?>
			<input type="hidden" name="depend_id" value="<?php echo Filters::noXSS($dependency['depend_id']); ?>" />
			<input type="hidden" name="return_task_id" value="<?php echo Filters::noXSS($task_details['task_id']); ?>" />
			<input type="hidden" name="action" value="removedep" />
			<button type="submit" title="<?= eL('remove') ?>" class="fas fa-link-slash"></button>
		</form>
		</td>
		</tr>
	<?php endforeach; ?>
	</tbody>
	</table>
<?php endif; ?>

<!-- This task has the following sub-tasks: -->

<?php if(!count($subtasks)==0): ?>
	<h3><?php echo (count($subtasks)==1) ? eL('taskhassubtask') : eL('taskhassubtasks'); ?></h3>

	<table id="subtask_table" class="table" width="100%">
	<thead>
	<tr>
<?php /*

		<th><?= eL('id') ?></th>
		<th><?= eL('project') ?></th>
*/ ?>
		<th><?= eL('summary') ?></th>
		<th><?= eL('priority') ?></th>
		<th><?= eL('severity') ?></th>
		<th><?= eL('assignedto') ?></th>
		<th><?= eL('progress') ?></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<?php foreach ($subtasks as $subtaskOrgin): ?>
		<?php $subtask = $fs->getTaskDetails($subtaskOrgin['task_id']); ?>
		<tr id="task<?php echo $subtask['task_id']; ?>" class="severity<?php echo Filters::noXSS($subtask['task_severity']); ?>">
<?php /*

		<td><?php echo $subtask['task_id'] ?></td>
		<td><?php echo $subtask['project_title'] ?></td>
*/ ?>
		<td class="task_summary">
			<?php if ($task_details['project_id'] != $subtask['project_id']) : ?>
			<div class="otherprojtitle"><?php echo $subtask['project_title'] ?></div>
			<?php endif; ?>
			<?php echo tpl_tasklink($subtask['task_id']); ?>
		</td>
		<td><?php echo $fs->priorities[$subtask['task_priority']] ?></td>
		<td class="task_severity"><?php echo $fs->severities[$subtask['task_severity']] ?></td>
		<td><?php
			$subassignedcount = count($subtaskOrgin['assigned_to']);
			if ($subassignedcount > 0) {
				for ($i=0; $i < $subassignedcount; $i++) {
					if ($i>0) {
						echo ", ";
					}
					echo $subtaskOrgin['assigned_to'][$i];
				}
			}
			else {
				echo eL('noone');
			}
		?></td>
		<td class="task_progress">
			<div class="progress_bar_container">
				<span><?php echo Filters::noXSS($subtask['percent_complete']); ?>%</span>
				<div class="progress_bar" style="width:<?php echo Filters::noXSS($subtask['percent_complete']); ?>%"></div>
			</div>
		</td>
		<td><?php echo tpl_form(Filters::noXSS(createURL('details', $task_details['task_id']))); ?>
			<input type="hidden" name="subtaskid" value="<?php echo Filters::noXSS($subtask['task_id']); ?>" />
			<input type="hidden" name="action" value="removesubtask" />
			<button type="submit" title="<?= eL('remove') ?>" class="fas fa-link-slash"></button>
			</form>
		</td>
		</tr>
	<?php endforeach; ?>
	</tbody>
	</table>
<?php endif; ?>
</div>
<?php endif; ?>
</div>

<?php if ($task_details['is_closed']): ?>
<div id="taskclosed">
	<p>
		<?= eL('closedby') ?> <?php echo tpl_userlink($task_details['closed_by']); ?>
	</p>
	<p>
		<?php echo Filters::noXSS(formatDate($task_details['date_closed'], true)); ?>
	</p>
	<p>
		<strong><?= eL('reasonforclosing') ?></strong> <?php echo Filters::noXSS($task_details['resolution_name']); ?>
	</p>
	<?php if ($task_details['closure_comment']): ?>
	<p>
		<strong><?= eL('closurecomment') ?></strong>
	</p>
	<div>
		<?php echo wordwrap(TextFormatter::render($task_details['closure_comment']), 40, "\n", true); ?>
	</div>
	<?php endif; ?>
</div>
<?php endif; ?>

<?php if (count($penreqs)): ?>
<div id="actionbuttons" class="box">
	<div class="pendingreq">
		<strong><?php echo Filters::noXSS(formatDate($penreqs[0]['time_submitted'])); ?>: <?= eL('request'.$penreqs[0]['request_type']) ?></strong>
		<?php if ($penreqs[0]['reason_given']): ?>
			<?= eL('reasonforreq') ?>: <?php echo Filters::noXSS($penreqs[0]['reason_given']); ?>
		<?php endif; ?>
	</div>
</div>
<?php endif; ?>
