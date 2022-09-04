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

" {{{ 检查环境 Check environment
function! s:check_env() abort
	if !executable('picgo')
		return [0, "[picgo.nvim] No picgo is executable! please see https://github.com/PicGo/PicGo-Core"]
	endif

	" 检测系统环境 Detect os
	if picgo#utils#check_os() != 'linux'
		return [0,  "[picgo.nvim] Unsupported System! Only Linux is allowed."]
	endif

	" 检测显示环境是 wayland 还是 x11  Detect which display server is on, wayland or x11
	let l:display_server = picgo#utils#check_display_server()
	if l:display_server == "wayland"
		" wayland
		if !executable('wl-paste')
			return [0, "[picgo.nvim] No wl-paste is executable! please see https://github.com/bugaevc/wl-clipboard"]
		endif
	else
		" x server
		if !executable('xclip')
			return [0, "[picgo.nvim] No xclip is executable! please see https://github.com/astrand/xclip"]
		endif
	endif

	return [1, l:display_server]
endfunc
" }}}

" {{{ 从剪贴板上传图像 Upload image file from clipboard
function! picgo#upload#from_clipboard() abort
	" 检查环境 Check environment
	let l:check_env_result = s:check_env()
	if !l:check_env_result[0]
		echoerr l:check_env_result[1]
	endif

	echo "Uploading..."
	" 执行脚本 Execute script
	call jobstart("sh " . s:upload_script, {'on_stdout': function('s:stdout_callback')})
endfunction
" }}}
