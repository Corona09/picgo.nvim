Usage:

```vim
call picgo#paste_from_clipboard()
nnoremap YOUR_KEY :call picgo#paste_from_clipboard() <CR>
```

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
