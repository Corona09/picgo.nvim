if exists("g:picgo#loaded")
	finish
endif

let g:picgo#loaded = 1

if !exists('g:picgo#insert_image_code')
	let g:picgo#insert_image_code = 0
endif

if !exists('g:picgo#image_code_template')
	let g:picgo#image_code_template = [ '![](${url})' ]
endif

command! -nargs=0 UploadImageFromClipboard call picgo#upload#from_clipboard()
