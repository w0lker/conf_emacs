;;; package -- 核心配置
;;; Commentary:
;;; Code:

(defconst *is-frame* (memq window-system '(mac ns x)))

;; 禁止图形特性
(setq use-file-dialog nil)
(setq use-dialog-box nil)

;; 隐藏启动画面
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

;; scratch默认不显示任何内容
(setq initial-scratch-message nil)

;; 不显示菜单
(if (and (functionp 'menu-bar-mode)
	 (unless window-system))
    (menu-bar-mode -1))

;; 不显示工具栏
(if (functionp 'tool-bar-mode)
    (tool-bar-mode -1))

;; 不显示滚动条
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;; 无边框
(let ((no-border '(internal-border-width . 0)))
  (add-to-list 'default-frame-alist no-border)
  (add-to-list 'initial-frame-alist no-border))

(fetch-package 'molokai-theme)
(require 'molokai-theme)
(with-eval-after-load 'molokai-theme
  (load-theme 'molokai t)
  )

(fetch-package 'smart-mode-line)
(require 'smart-mode-line)
(with-eval-after-load 'smart-mode-line
  (setq sml/no-confirm-load-theme t)
  (setq sml/shorten-directory t)
  (setq sml/shorten-modes t)
  (setq sml/vc-mode-show-backend nil)

  (custom-set-faces
   '(sml/modes ((t :foreground "#202000")))
   '(sml/prefix ((t :foreground "#d83b5d")))
   '(sml/folder ((t :foreground "#99cc66")))
   '(sml/filename ((t :foreground "#99cc66")))
   '(sml/process ((t :foreground "#99cc66")))
   '(sml/vc ((t :foreground "#203c04")))
   '(sml/vc-edited ((t :foreground "#92e56d")))
   '(sml/minor-modes ((t :foreground "#99cc66"))))

  (if window-system
      (progn
	(fetch-package 'smart-mode-line-powerline-theme)
	(require 'smart-mode-line-powerline-theme)
	(setq sml/theme 'powerline))
    (setq sml/theme 'dark))

  (sml/setup)
  )

;; 字体大小调整
(set-default-font "Menlo 11")
(fetch-package 'default-text-scale)
(require 'default-text-scale)
(with-eval-after-load 'default-text-scale
  (when window-system
    (global-set-key (kbd "C-M-=") 'default-text-scale-increase)
    (global-set-key (kbd "C-M--") 'default-text-scale-decrease))
  )

;; 设置窗口标题格式
(setq frame-title-format '((:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b"))))

(defun core/frame-maybe-adjust-visual-fill-column ()
  "自动适配列数."
  (if visual-fill-column-mode
      (add-hook 'after-setting-font-hook 'visual-fill-column--adjust-window nil t)
    (remove-hook 'after-setting-font-hook 'visual-fill-column--adjust-window t)))
(add-hook 'visual-fill-column-mode-hook 'core/frame-maybe-adjust-visual-fill-column)

(fetch-package 'smooth-scrolling)
(require 'smooth-scrolling)
(smooth-scrolling-mode t)

;; mac 下配置
(when (eq system-type 'darwin)
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'meta)

  ;; 使用C-M-f触发全屏模式
  (when (fboundp 'toggle-frame-fullscreen)
    (global-set-key (kbd "C-M-f") 'toggle-frame-fullscreen))
  )

(defun core/frame-console-hide-menu-bar (frame)
  "如果不是窗口，隐藏当前 FRAME 菜单拦."
  (with-selected-frame frame
    (unless window-system
      (set-frame-parameter nil 'menu-bar-lines 0))))
(add-hook 'after-make-frame-functions 'core/frame-console-hide-menu-bar)

(defun core/frame-console-fix-up-control-arrows ()
  "控制台下 C-<方向键> 修复."
  (let ((map (if (boundp 'input-decode-map) input-decode-map function-key-map)))
    (define-key map "\e[1;5A" [C-up])
    (define-key map "\e[1;5B" [C-down])
    (define-key map "\e[1;5C" [C-right])
    (define-key map "\e[1;5D" [C-left])
    (define-key map "\e[5A"   [C-up])
    (define-key map "\e[5B"   [C-down])
    (define-key map "\e[5C"   [C-right])
    (define-key map "\e[5D"   [C-left])))
(add-hook 'after-make-console-frame-hooks 'core/frame-console-fix-up-control-arrows)

(defun core/frame-console-mouse-support ()
  "控制台下鼠标支持."
  (xterm-mouse-mode 1)
  (when (fboundp 'mwheel-install)
    (mwheel-install)))
(add-hook 'after-make-console-frame-hooks 'core/frame-console-mouse-support)

(defun core/frame-console-suspend-frame ()
  "控制台下使用`C-z`暂停程序."
  (interactive)
  (unless window-system (suspend-frame)))
(global-set-key (kbd "C-z") 'core/frame-console-suspend-frame)

(with-eval-after-load 'files
  ;; 如果 gnu ls 可用就使用
  (let ((gls (executable-find "gls")))
    (when gls
      (setq insert-directory-program gls)))
  )

(require 'recentf)
(with-eval-after-load 'recentf
  (setq recentf-max-saved-items 2000)
  (setq recentf-auto-cleanup 'never) ;; 使用tramp模式的时候需要关闭，否则会判断文件的可访问性
  (setq-default recentf-save-file  (concat user-temp-dir "recentf")) ;; 保存目录
  (setq-default recentf-exclude '("/tmp/" "\\.emacs\\.d/temp/"))
  (recentf-mode t)
  (global-set-key (kbd "C-x C-r") 'recentf-open-files))

(fetch-package 'ido)
(require 'ido)
(with-eval-after-load 'ido
  (ido-mode 1)
  (ido-everywhere 1)
  (defconst ido-save-directory-list-file (concat user-temp-dir "ido.last")) ;; 保存目录
  (setq ido-enable-flex-matching t) ;; 非常开放的匹配方式 aa 可以匹配 alpha
  (setq ido-enable-regexp t) ;; 支持正则表达式
  (setq ido-use-filename-at-point nil)
  (setq ido-auto-merge-work-directories-length -1)
  (setq ido-use-virtual-buffers t)
  (setq ido-default-buffer-method 'selected-window) ;; 允许一个 buffer 同时在不同的的 frame 中打开

  (fetch-package 'smex)
  ;; 支持 M-x 命令自动补全
  (require 'smex)
  (defconst smex-save-file (concat user-temp-dir "smex-items"))
  (global-set-key [remap execute-extended-command] 'smex)

  (fetch-package 'ido-ubiquitous)
  ;; 尽量让 ido 支持更多场景的补全
  (require 'ido-ubiquitous)
  (ido-ubiquitous-mode 1)

  (fetch-package 'ido-yes-or-no)
  (require 'ido-yes-or-no)
  (ido-yes-or-no-mode 1)

  (fetch-package 'crm-custom)
  (require 'crm-custom)
  (crm-custom-mode 1)

  (fetch-package 'ido-select-window)
  (require 'ido-select-window)
  (global-set-key (kbd "C-x o") 'ido-select-window)
  )

(with-eval-after-load 'dired
  (setq dired-recursive-deletes 'top)
  (setq dired-dwim-target t)

  (define-key dired-mode-map [mouse-2] 'dired-find-file)

  (fetch-package 'dired+)
  (require 'dired+)
  ;; 使用 快捷键 ( 触发详情和关闭文件详情
  (setq diredp-hide-details-initially-flag nil)
  (global-dired-hide-details-mode t)

  (fetch-package 'dired-sort)
  (require 'dired-sort)

  (fetch-package 'diff-hl)
  (require 'diff-hl)
  (add-hook 'dired-mode-hook 'diff-hl-dired-mode)

  (with-eval-after-load 'guide-key
    (add-hook 'dired-mode-hook (lambda () (guide-key/add-local-guide-key-sequence "%"))))

  (with-eval-after-load 'evil
    (evil-set-initial-state 'dired-mode 'normal))
  )

(fetch-package 'ibuffer)
(require 'ibuffer)
(with-eval-after-load 'ibuffer
  (setq-default ibuffer-show-empty-filter-groups nil)
  (setq-default ibuffer-filter-group-name-face 'font-lock-doc-face)

  (require 'uniquify) ;; 同名 buffer 处理
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator " • ")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*")

  (defun core/ibuffer-friendly-size-column-show ()
    "配置 size-h 列使用比较友好的显示方式."
    (define-ibuffer-column size-h
      (:name "Size" :inline t)
      (cond
       ((> (buffer-size) 1000000) (format "%7.1fM" (/ (buffer-size) 1000000.0)))
       ((> (buffer-size) 1000) (format "%7.1fk" (/ (buffer-size) 1000.0)))
       (t (format "%8d" (buffer-size))))))
  (add-hook 'ibuffer-hook 'core/ibuffer-friendly-size-column-show)

  (defun core/ibuffer-name-sort ()
    "设置 buffer 按照文件名排序."
    (unless (eq ibuffer-sorting-mode 'filename/process)
      (ibuffer-do-sort-by-filename/process)))
  (add-hook 'ibuffer-hook 'core/ibuffer-name-sort)

  (fetch-package 'ibuffer-vc)
  ;; 添加版本控制信息支持
  (require 'ibuffer-vc)
  (add-hook 'ibuffer-hook 'ibuffer-vc-set-filter-groups-by-vc-root)

  (with-eval-after-load 'evil
    (evil-set-initial-state 'ibuffer-mode 'normal))

  (with-eval-after-load 'fullframe
    (fullframe ibuffer ibuffer-quit))

  (global-set-key (kbd "C-x C-b") 'ibuffer)
  )

(with-eval-after-load 'tramp
  (defconst tramp-persistency-file-name (concat user-temp-dir "tramp"))

  ;; 指定默认使用的方法
  ;; 使用ssh会比scp快
  ;; 在使用的时候，可以临时指定其它的方法
  ;; C-x C-f /method:user@remotehost:filename
  (setq tramp-default-method "ssh")

  ;; 优化大文件的网络传输，如问题：tramp: Waiting for remote host to process data
  (setq tramp-chunksize 500)

  (defun tramp-shell (&optional buffer)
    "当使用tramp连到某个远程文件后，创建一个连接到当前远程文件的shell BUFFER."
    (interactive)
    (let* ((tramp-path (when (tramp-tramp-file-p default-directory)
			 (tramp-dissect-file-name default-directory)))
	   (host (tramp-file-name-real-host tramp-path))
	   (user (if (tramp-file-name-user tramp-path)
		     (format "%s@" (tramp-file-name-user tramp-path)) ""))
	   (new-buffer-name (format "*shell:%s%s*" user host)))
      (shell (if host new-buffer-name buffer))))

  (fetch-package 'vagrant)
  (require 'vagrant)
  (fetch-package 'vagrant-tramp)
  (require 'vagrant-tramp)
  )

;; 使用 shift+方向键 选择面板
(fetch-package 'windmove)
(require 'windmove)
(windmove-default-keybindings)

;; 使用C-c <left> 和C-c <right>来对窗口配置进行 redo 或者 undo。这样在窗口乱了后可以恢复到原来不乱的状态
(fetch-package 'winner)
(require 'winner)
(winner-mode 1)
(defun core/window-delete-other-windows-or-restore-previous ()
  "删除其它面板，如果没有其它面板就恢复前一个面板布局."
  (interactive)
  (if (and winner-mode
	   (equal (selected-window) (next-window)))
      (winner-undo)
    (delete-other-windows)))
(global-set-key "\C-x1" 'core/window-delete-other-windows-or-restore-previous)

(defun core/window-split-window-func-with-other-buffer (split-function)
  "分屏并且把焦点放在新面板上, SPLIT-FUNCTION 为分屏函数."
  (lexical-let ((s-f split-function))
    (lambda (&optional arg)
      (interactive "P")
      (funcall s-f)
      (let ((target-window (next-window)))
	(set-window-buffer target-window (other-buffer))
	(unless arg
	  (select-window target-window))))))
(global-set-key "\C-x2" (core/window-split-window-func-with-other-buffer 'split-window-vertically))
(global-set-key "\C-x3" (core/window-split-window-func-with-other-buffer 'split-window-horizontally))

;; 设置分屏, C-x |和C-x _分别表示竖分和横分。使用这个操作的时候只会一直只有两个window
(defun core/window-split-window-horizontally-instead ()
  "横向分割面板."
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (core/window-split-window-func-with-other-buffer 'split-window-horizontally))))
(global-set-key "\C-x|" 'core/window-split-window-horizontally-instead)

(defun core/window-split-window-vertically-instead ()
  "纵向分割面板."
  (interactive)
  (save-excursion
    (delete-other-windows)
    (funcall (core/window-split-window-func-with-other-buffer 'split-window-vertically))))
(global-set-key "\C-x_" 'core/window-split-window-vertically-instead)

;; 默认主模式为 text-mode
(setq major-mode 'text-mode)

;; 使用 C-x C-c C-v 进行复制粘贴
(if window-system
    (cua-mode t))

;; 优化翻页速度
(setq jit-lock-defer-time 0.05)

;; 关闭出错蜂鸣声
(setq visible-bell t)
(setq ring-bell-function 'ignore)

;; 不断监听当前 buffer 的变化，如果其它编辑器同时修改该文件，修改会同步过来
(global-auto-revert-mode)
(setq global-auto-revert-non-file-buffers t
      auto-revert-verbose nil)
(diminish 'auto-revert-mode)

;; 光标闪动频率
(setq blink-cursor-interval 0.8)

;; 取消不管多少个空行只显示一行
(setq truncate-lines nil)
(setq truncate-partial-width-windows nil)

;; 默认不显示空格信息
(setq show-trailing-whitespace t)

;; 使用空格代替 TAB 键
(setq indent-tabs-mode nil)
(setq tab-width 4)

;; mode-line 上显示列数
(setq column-number-mode t)

;; 可以像普通编辑器一样用delete删除
(setq delete-selection-mode t)

;; 同时删除末尾换行符
(setq kill-whole-line t)

;; 自动将其它程序加入系统剪切板的内容加入 kill-ring
(setq save-interprogram-paste-before-kill nil)

;; primary section中内容不放入系统剪切版
(setq select-enable-primary nil)
;; 不把当前选中的选区中的内容放入primary section
(setq select-active-regions nil)

;; 剪切复制使用系统剪切板
(setq select-enable-clipboard t)

;; 打标记时，每次 C-SPC 算不同的标记记录
(setq set-mark-command-repeat-pop t)

;; 关闭 narrowing 功能，使用 narrowing 功能，可以在 buffer 中只显示选中的区域的内容，其它部分隐藏，比较容易造成困惑
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

(fetch-package 'undo-tree)
(require 'undo-tree)
(with-eval-after-load 'undo-tree
  (global-undo-tree-mode t)
  (diminish 'undo-tree-mode)
  )

(fetch-package 'redo+)
(require 'redo+)
(setq undo-no-redo t)
(global-set-key (kbd "C-?") 'redo)

;; 成对插入符号
(if (fboundp 'electric-pair-mode)
    (electric-pair-mode))

;; 高亮匹配的括号
(show-paren-mode 1)

;; 不同层括号颜色不同
(fetch-package 'rainbow-delimiters)
(require 'rainbow-delimiters)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)

;; 配置行号显示样式
(require 'linum)
(setq linum-format "%4d ")

;; 选中 region 高亮
(transient-mark-mode t)

;; 高亮转义字符
(fetch-package 'highlight-escape-sequences)
(require 'highlight-escape-sequences)
(hes-mode t)

;; 指示文件尾空行的横杠,t 表示打开，nil 表示关闭，可以通过 M-x toggle-indicate-empty-lines 关闭或者打开
;; 同 indicate-unused-lines
(setq-default indicate-empty-lines nil)
;; 左侧添加文件指示的标示，在文件中间时间箭头，在头部和尾部显示一个 L 型标识
(setq-default indicate-buffer-boundaries '((up . left) (down . left)))

;; 左侧显示提示修改内容
(fetch-package 'diff-hl)
(require 'diff-hl)
(add-hook 'prog-mode-hook 'turn-on-diff-hl-mode)
(add-hook 'vc-dir-mode-hook 'turn-on-diff-hl-mode)

;; 调整光标覆盖单词面积
(fetch-package 'expand-region)
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; 跳到你想要的位置
(fetch-package 'avy)
(require 'avy)
(global-set-key (kbd "C-;") 'avy-goto-word-or-subword-1)

(defun core/editor-backward-up-sexp (arg)
  "跳到包围当前表达式、代码块或者字符串的前 ARG 层括号处.
解决 backwark-up-list 函数不能识别包围字符串的引号的问题.
参数 ARG 表示执行到的层数,负数表示往右括号跳."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))
;; 使用快捷键 C-M-u
(global-set-key [remap backward-up-list] 'core/editor-backward-up-sexp)

;; 创建新行使用和前面文本同样的缩进
(global-set-key (kbd "RET") 'newline-and-indent)

(defun core/editor-newline-at-end-of-line ()
  "下方创建一个新行，光标移到行首."
  (interactive)
  (move-end-of-line 1)
  (newline-and-indent))
(global-set-key (kbd "S-<return>") 'core/editor-newline-at-end-of-line)

(defun core/editor-newline-at-beginnging-of-line ()
  "上方创建一个新行，光标移到行首."
  (interactive)
  (previous-line)
  (editor/newline-at-end-of-line))
(global-set-key (kbd "S-M-<return>") 'core/editor-newline-at-beginnging-of-line)

(defun core/editor-kill-back-to-indentation ()
  "从当前位置删除到行首缩进位置."
  (interactive)
  (let ((prev-pos (point)))
    (back-to-indentation)
    (kill-region (point) prev-pos)))
(global-set-key (kbd "C-M-<backspace>") 'core/editor-kill-back-to-indentation)

(provide 'init-core)
;;;  init-core.el ends here