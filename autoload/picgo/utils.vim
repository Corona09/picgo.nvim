"{{{ 检测系统 Check which OS
function! picgo#utils#check_os()
	if has('win32') || has('win64')
		return 'windows'
	elseif has('linux')
		return 'linux'
	elseif has('mac')
		return 'mac'
	else
		return 'unkown'
	endif
endfunction
"}}}

" {{{ 检测当前的显示环境 Detect current display server (x11 or wayland)
function! picgo#utils#check_display_server() abort
	return $XDG_SESSION_TYPE
endfunction
" }}}

" {{{ 处理 picgo 的返回结果 Handle result of picgo
function! picgo#utils#handle_result(result) abort
	" 检查是否失败 check whether failed
	let l:index = match(a:result, '\[PicGo ERROR\]')
	if l:index > 0
		return ["Failed", ""]
	endif
		
	let l:index = match(a:result, '\[PicGo SUCCESS\]:')

	if l:index > 0
		let l:url = a:result[l:index+17 : -2]
		return ["Success", l:url]
	endif

	return ["", ""]
endfunction
" }}}

" {{{ 将特定格式的图像代码插入到光标下 Insert image code
function picgo#utils#insert_image(url) abort
	let lnum = line(".")
	let colnum = col(".")
	let l:img = g:picgo#image_code_template
	
	let i = 0
	while i < len(l:img)
		let l:img[i] = substitute(l:img[i], "${url}", a:url, "g")
		let i = i + 1
	endwhile
	call append(lnum, l:img)

endfunction
" }}}

" {{{ 检查环境 Check environment
function! picgo#utils#check_env() abort
	if !executable('picgo')
		if g:picgo#show_warning
			return [0, "[picgo.nvim] No picgo is executable! please see https://github.com/PicGo/PicGo-Core"]
		endif
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
			if g:picgo#show_warning
				return [0, "[picgo.nvim] No wl-paste is executable! please see https://github.com/bugaevc/wl-clipboard"]
			endif
		endif
	else
		" x server
		if !executable('xclip')
			if g:picgo#show_warning
				return [0, "[picgo.nvim] No xclip is executable! please see https://github.com/astrand/xclip"]
			endif
		endif
	endif

	return [1, l:display_server]
endfunc
" }}}
