# picgo.nvim

## Introduction

This plugin can upload image fro clipboard or from file system (still developing). Although there are similar plugins like [nvim-picgo](https://github.com/askfiy/nvim-picgo) or [coc-picgo](https://github.com/PLDaily/coc-picgo), there are either not campatible with latest picgo or already lost maintainance.

For now, this plugin only support linux, both wayland and x11.

## Dependencies

- [picgo-core](https://github.com/PicGo/PicGo-Core)
- [xclip](https://github.com/astrand/xclip) (for x11)
- [wl-clipboard](https://github.com/bugaevc/wl-clipboard) (for wayland)

## Installation

use dein:
```vim
call dein#add('Corona09/picgo.nvim')
```

## Usage

### Upload Image from Clipboard

```vim
UploadImageFromClipboard
" or
nnoremap YOUR_KEY :UploadImageFromClipboard <CR>
```

After image was uploaded, you can also press `p` to insert its url.

## Configuration

<details close>
	<summary><code>g:picgo#image_code_template</code></summary>

```vim
" picgo#image_cdoe_template is an array of string
" the plugin will replace ${url} with image url returned by picgo
" the default value is as [ '![]( ${url} )' ]
let g:picgo#image_code_template = [ '![]( ${url} )' ]

```
</details>

<details close>
	<summary><code>g:picgo#insert_image_code</code></summary>

```vim
" if you do not want to insert code after uploading
" you can set g:picgo#insert_image_code to 0
" default value : 0
let g:picgo#insert_image_code = 1
```
</details>

<details close>
	<summary><code>g:pigco#show_warning</code></summary>
```vim
" set to 0 to disable warning for picgo/xclip/wl-clipboard
" default value: 1
let g:picgo#show_warning = 0
```
</details>

---

## Known issues

- Cannot upload from clipboard while copy image from nautilus

## TODO
- [x] Upload from file system.
- [ ] Optimize action of inserting image code.
- [ ] Add doc.
- [ ] Multiple config.
