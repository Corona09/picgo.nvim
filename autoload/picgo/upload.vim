let s:upload_script = fnamemodify(expand('<sfile>'), ':h') . "/../../bin/upload.sh"

" {{{ 处理上传脚本输出的回调函数 Callback to handle result by uploading script.
function! s:stdout_callback(job_id, data, event) abort
	if empty(a:data) || len(a:data) <= 1 | return | endif

	let l:result = join(a:data)
	let l:handle_result = picgo#utils#handle_result(l:result)

	" 上传失败 Failed
	if l:handle_result[0] == "Failed"
		echoerr "[picgo.nvim] Failed to upload image. Press p to paste picgo output."
		let @" = l:result
		return l:result
	elseif l:handle_result[0] == "Success"
		let l:url = l:handle_result[1]
		
		" 上传成功 Success to upload
		echomsg "[picgo.nvim] Upload successfully. You can press 'p' to paste image url."
		let l:url = 'https://' . l:url
		let @" = l:url
		
		if exists('g:picgo#insert_image_code') && g:picgo#insert_image_code == 1
			call picgo#utils#insert_image(l:url)
		endif
	else
		" 什么也不做 Do nothing
	endif

endfunction
" }}}

" {{{ 从剪贴板上传图像 Upload image file from clipboard
function! picgo#upload#from_clipboard() abort
	echo "Uploading..."
	" 执行脚本 Execute script
	call jobstart("sh " . s:upload_script,
				\ {'on_stdout': function('s:stdout_callback')})
endfunction
" }}}

" 从文件系统上传图像 Upload image from file system
function! picgo#upload#from_file_system(abs_path) abort
	echo "Upload..."
	call jobstart("sh " . s:upload_script . ' ' . a:abs_path,
				\ {'on_stdout': function('s:stdout_callback')})
endfunction
