# Preface

我经常用 fugitive 查看 git 日志时，每次提交详情打开它都是以 unified 的形式显示每个 commit 的改动，看的我头疼，我还是喜欢 GUI 模式下 side-by-side 的模式左右分屏查看，所以我做了这个插件。

它既有独立运行模式，也可以很好的同 fugitive / flog / gv.vim 等插件协同工作。

## Example

在 gv.vim 或者 fugitive 里查看提交日志时，按 `dd` 就会弹出改动窗口：

![](https://skywind3000.github.io/images/p/gdv/flog1.png)

这个插件会自动提取你光标所在行的 commit hash 然后在浮窗里展开该提交的改动列表，你按回车就弹出比较页面：

![](https://skywind3000.github.io/images/p/gdv/diffview.png)

这样你就能方便对比查看了，查看完了 `:tabclose` 就能回到刚才的页面（我配置了个 ALT+w 关闭 tabpage 很方便）。

## Installation

使用 vim-plug 安装的话：

```viml
Plug 'tpope/vim-fugitive'
Plug 'skywind3000/vim-quickui'
Plug 'skywind3000/vim-git-diffview'
```

该插件依赖 [vim-fugitive](https://github.com/tpope/vim-fugitive) 和 [vim-quickui](https://github.com/skywind3000/vim-quickui) 两个插件。

## Command

本插件只有一条命令：

```viml
:GitDiffView [commit]
```

如果提供 `commit` 的话，就会显示该 commit 的改动信息：

![](https://skywind3000.github.io/images/p/gdv/select.png)

第一列是 parent commit 的序号，第二列是 parent commit 的 hash 后面两列是文件改动状态和文件名，此时按回车就能查看具体改动文件。

如果没有提供 `commit` 的话，本插件会根据当前窗口和光标位置进行判断：

| 支持插件 | 窗口/buffer |
|-|-|
| fugitive | 日志窗口，即 `:Gclog` 显示出来的那个 quickfix 窗口 |
| fugitive | commit 窗口，即日志窗口里按回车弹出的 commit 详情窗口 |
| fugitive | status 窗口，即运行 `:G` 命令打开的那个提交窗口 |
| gv.vim | 日志窗口，就是 `:GV` 命令打开那个 | 
| flog | 日志窗口，就是 `:Flog` 命令打开的那个 |

在这些窗口上运行 `:GitDiffView` 都会根据光标位置自动识别你想对比什么东西。

## Keymap

插件会自动在上面提到的几个页面里增加 buffer local 的 keymap，可以修改：

```viml
let g:gdv_keymap = 'dd'
```

默认是 'dd'，比如你改成 'o' 的话，就变成在这些窗口按 o 运行 `:GitDiffView` 命令。

如果改成空字符串的话，就不会自动初始化 keymap。

## Right

还有一个配置是弹出对比窗口的位置：

```viml
let g:gdv_tab_right = 0
```

默认这个值是 `0` 代表在当前 tabpage 的左边打开 diffview 的 tabpage，这样比较友好，因为你关闭它后又会回到先前的 tabpage 了。

改成 `1` 的话就会在右边打开 tabpage，但是关闭它会去到更右边一个 tabpage 而不会回到原来页面。

## Credit

TODO

