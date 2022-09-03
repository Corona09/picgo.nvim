"{{{ 检测系统 Check which OS
function! s:check_os()
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
function! s:check_display_server() abort
	return $XDG_SESSION_TYPE
endfunction
" }}}

" {{{ 处理 picgo 的返回结果 Handle result of picgo
function! s:handle_result(result) abort
	let l:index = match(a:result, '\[PicGo SUCCESS\]:')

	if l:index < 0
		return "Failed"
	endif

	let l:url = a:result[l:index+18 : -2]
	return l:url
endfunction
" }}}

" {{{ 将特定格式的图像代码插入到光标下 Insert image code
function s:insert_image(url) abort
	let lnum = line(".")
	let colnum = col(".")
	let l:img = g:picgo_img_template
	" let l:img = substitute(g:picgo_img_template, "${url}", a:url, "g")
	
	let i = 0
	while i < len(l:img)
		let l:img[i] = substitute(l:img[i], "${url}", a:url, "g")
		let i = i + 1
	endwhile
	call append(lnum, l:img)

endfunction
" }}}

" {{{ 从剪贴板上传图像 Upload Image From Clipboard
function! picgo#paste_from_clipboard() abort
	if !executable('picgo')
		echoerr "no picgo is executable! please see https://github.com/PicGo/PicGo-Core"
	endif

	" 检测系统环境 Detect os
	if s:check_os() != 'linux'
		echoerr "Unsupported System! Only Linux is allowed."
	endif

	" 创建临时文件 Make temp file
	let l:now = strftime('%Y-%m-%d_%H-%M-%S')
	let l:tmpfile = system('mktemp -t ' . l:now . '.XXXXXXXXX --suffix .png')
	echo l:tmpfile
	let l:result = ""

	" 检测显示环境是 wayland 还是 x11  Detect which display server is on, wayland or x11
	if s:check_display_server() == "wayland"
		" wayland
		if !executable('wl-paste')
			echoerr "no wl-paste is executable! please see https://github.com/bugaevc/wl-clipboard"
		endif

		" output image file in clipboard to temp file
		call system("wl-paste --no-newline --type image/png > " . l:tmpfile)
		echo "Uploading..."
		let l:result =  system("picgo u " . l:tmpfile)
	else
		" x server
		if !executable('xclip')
			echoerr "no xclip is executable! please see https://github.com/astrand/xclip"
		endif

		call system("xclip -selection clipboard -t image/png -o > " . l:tmpfile)
		let l:result = system("picgo u " . l:tmpfile)
	endif

	let l:url = s:handle_result(l:result)

	" 上传失败 Failed
	if l:url == "Failed"
		echoerr "Failed to upload image " . l:tmpfile
		let @" = "Failed to upload image " . l:tmpfile
		return l:result
	endif

	" 成功上传 Success
	echo "url: " . l:url
	echo "Upload successfully. You can press 'p' to paste image url."
	let l:url = 'https://' . l:url
	let @" = l:url
	call system("rm -f " . l:tmpfile)
	" 插入图像 Insert Image
	call s:insert_image(l:url)

	return l:url

endfunction
" }}}

if exists("g:loaded_picgo")
	finish
endif

let g:loaded_picgo = 1
let g:picgo_img_template = [
			\ '<center>',
			\ '    <img',
			\ '        style="width: 100%"',
			\ '        src="${url}"',
			\ '    />',
			\ '</center>'
			\ ]
	
