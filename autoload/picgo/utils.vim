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
	let l:index = match(a:result, '\[PicGo SUCCESS\]:')

	if l:index < 0
		return "Failed"
	endif

	let l:url = a:result[l:index+18 : -2]
	return l:url
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