" Detect os (windows or linux or macos)
function! utils#check_os()
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
function! utils#check_display_server() abort
	return $XDG_SESSION_TYPE
endfunction
