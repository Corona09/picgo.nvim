# Usage

## Upload Image from Clipboard

```vim
UploadImageFromClipboard
" or
nnoremap YOUR_KEY :UploadImageFromClipboard <CR>
```

After image was uploaded, you can also press `p` to insert its url.

# Configuration

<details close>
	<summary><code>g:picgo#image_code_template</code></summary>

```vim
" picgo#image_cdoe_template is an array of string
" the plugin will replace ${url} with image url returned by picgo
" the default value is as below
let g:picgo#image_cdoe_template = [
			\ '<center>',
			\ '    <img',
			\ '        style="width: 100%"',
			\ '        src="${url}"',
			\ '    />',
			\ '</center>'
			\ ]

```
</details>

<details close>
	<summary><code>g:picgo#insert_image_code</code></summary>

```vim
" if you do not want to insert code after uploading
" you can set g:picgo#insert_image_code to 0
" default value : 1
let g:picgo#insert_image_code = 0
```
</details>

---

TODO:
- [ ] 异步执行
- [ ] 从文件系统上传
    - [ ] 检测给定文件是否存在
	- [ ] 检查给定文件是否是图片
	- [ ] 上传图片
	- [ ] 获取 url
	- [ ] 将 url 存放到寄存器
- [ ] 优化代码插入
