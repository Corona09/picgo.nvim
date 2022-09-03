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

" Detect current display server (x11 or wayland)
function! s:check_display_server() abort
	return $XDG_SESSION_TYPE
endfunction

" Upload Image From Clipboard
function! picgo#paste_from_clipboard() abort
	if !executable('picgo')
		echoerr "no picgo is executable! please see https://github.com/PicGo/PicGo-Core"
	endif

	" detect os
	if s:check_os() != 'linux'
		echoerr "Unsupported System! Only Linux is allowed."
	endif

	" make temp file
	let l:now = strftime('%Y-%m-%d_%H-%M-%S')
	let l:tmpfile = system('mktemp -t ' . l:now . '.XXXXXXXXX --suffix .png')
	echo l:tmpfile
	let l:url = ""

	" detect display server
	if s:check_display_server() == "wayland"
		" wayland
		if !executable('wl-paste')
			echoerr "no wl-paste is executable! please see https://github.com/bugaevc/wl-clipboard"
		endif

		" output image file in clipboard to temp file
		call system("wl-paste --no-newline --type image/png > " . l:tmpfile)
		echo "Uploading..."
		let l:url =  system("picgo u " . l:tmpfile)
	else
		" x server
		if !executable('xclip')
			echoerr "no xclip is executable! please see https://github.com/astrand/xclip"
		endif

		call system("xclip -selection clipboard -t image/png -o > " . l:tmpfile)
		let l:url = system("picgo u " . l:tmpfile)
	endif

	" delete temp file
	" call system('rm -f ' . l:tmpfile)

	return l:url

endfunction

let g:loaded_picgo = 1
if exists("g:loaded_picgo")
	finish
endif

" call picgo#paste_from_clipboard()
