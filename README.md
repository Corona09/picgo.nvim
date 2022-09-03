Usage:

```vim
call picgo#paste_from_clipboard()
nnoremap YOUR_KEY :call picgo#paste_from_clipboard() <CR>
```

---

TODO:
- [x] 检测当前系统
- [x] 检测当前环境 (x11/wayland)
- [x] 检测当前是否存在命令 (xclip/wl-paste)
- [x] 从剪贴板上传
- 从文件系统上传
    - [ ] 检测给定文件是否存在
	- [ ] 检查给定文件是否是图片
	- [ ] 上传图片
	- [ ] 获取 url
	- [ ] 将 url 存放到寄存器
