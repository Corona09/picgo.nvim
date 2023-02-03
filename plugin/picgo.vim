" 检查环境 Check environment
let s:check_env_result = picgo#utils#check_env()
if !s:check_env_result[0]
	echoerr s:check_env_result[1]
endif

" 部分设置的默认值 Some default values
if !exists('g:picgo#insert_image_code')
	let g:picgo#insert_image_code = 1
endif

if !exists('g:picgo#image_code_template')
	let g:picgo#image_code_template = [ '![](${url})' ]
endif

if !exists('g:picgo#show_warning')
	let g:picgo#show_warning = 1
endif

" 自定义命令 Custom command
command! -nargs=0 UploadImageFromClipboard call picgo#upload#from_clipboard()
command! -nargs=1 UploadImageFromFileSystem call picgo#upload#from_file_system(<f-args>)
