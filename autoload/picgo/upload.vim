" {{{ 从剪贴板上传图像 Upload Image From Clipboard
function! picgo#upload#from_clipboard() abort
	if !executable('picgo')
		echoerr "no picgo is executable! please see https://github.com/PicGo/PicGo-Core"
	endif

	" 检测系统环境 Detect os
	if picgo#utils#check_os() != 'linux'
		echoerr "Unsupported System! Only Linux is allowed."
	endif

	" 创建临时文件 Make temp file
	let l:now = strftime('%Y-%m-%d_%H-%M-%S')
	let l:tmpfile = system('mktemp -t ' . l:now . '.XXXXXXXXX --suffix .png')
	echo l:tmpfile
	let l:result = ""

	" 检测显示环境是 wayland 还是 x11  Detect which display server is on, wayland or x11
	if picgo#utils#check_display_server() == "wayland"
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

	let l:url = picgo#utils#handle_result(l:result)

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

	if !(exists('g:picgo#insert_image_code') && g:picgo#insert_image_code == 0)
		" 插入图像 Insert Image
		call picgo#utils#insert_image(l:url)
	endif

	return l:url

endfunction
" }}}
