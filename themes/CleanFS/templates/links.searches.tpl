<strong id="nosearches" <?php if(count($user->searches)): ?>class="hide"<?php endif; ?>><?php echo Filters::noXSS(L('nosearches')); ?></strong>
<?php if(count($user->searches)): ?>
<input type="hidden" name="csrftoken" id="deletesearchtoken" value="<?php echo $_SESSION['csrftoken']; ?>">
<table id="mysearchestable">
<tbody>
<?php foreach ($user->searches as $search): ?>
<tr id="rs<?php echo Filters::noXSS($search['id']); ?>" <?php if($search == end($user->searches)): ?> class="last"<?php endif; ?>>
	<td>
		<a href="<?php echo Filters::noXSS($baseurl); ?>?do=index&amp;<?php echo http_build_query(unserialize($search['search_string']), '', '&amp;'); ?>"><?php echo Filters::noXSS($search['name']); ?></a>
	</td>
	<td class="searches_delete">
		<a href="javascript:deletesearch('<?php echo Filters::noXSS($search['id']); ?>','<?php echo Filters::noJsXSS($baseurl); ?>')" class="button">
			<span title="<?php echo Filters::noXSS(L('delete')); ?>" class="fas fa-trash-can fa-lg"></span>
		</a>
	</td>
</tr>
<?php endforeach; ?>
</tbody>
</table>
<?php endif; ?>
