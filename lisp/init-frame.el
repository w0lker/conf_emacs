;;; package -- 窗口设置
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

;; 不显示工具栏
(if (functionp 'tool-bar-mode)
    (tool-bar-mode -1))
;; 不显示菜单
(if (and (functionp 'menu-bar-mode) (unless window-system))
    (menu-bar-mode -1))
;; 不显示滚动条
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode -1))

;; 无边框
(let ((no-border '(internal-border-width . 0)))
  (add-to-list 'default-frame-alist no-border)
  (add-to-list 'initial-frame-alist no-border))

(use-package frame
  :init
  (set-default-font "Menlo 11")
  ;; 设置窗口标题格式
  (setq frame-title-format '((:eval (if (buffer-file-name) (abbreviate-file-name (buffer-file-name)) "%b"))))
  :config
  (defun frame/maybe-adjust-visual-fill-column ()
    "自动适配列数."
    (if visual-fill-column-mode
	(add-hook 'after-setting-font-hook 'visual-fill-column--adjust-window nil t)
      (remove-hook 'after-setting-font-hook 'visual-fill-column--adjust-window t)))
  (add-hook 'visual-fill-column-mode-hook 'frame/maybe-adjust-visual-fill-column)

  ;; 字体大小调整
  (use-package default-text-scale
    :ensure t
    :commands (defaut-text-scale-increase default-text-scale-decrease)
    :if window-system
    :bind (("C-M-=" . default-text-scale-increase)
	   ("C-M--" . default-text-scale-decrease))
    )
  
  ;; 隐藏选中的窗口的菜单栏
  (add-hook 'after-make-frame-functions
	    (lambda (frame)
	      (with-selected-frame frame
		(unless window-system
		  (set-frame-parameter nil 'menu-bar-lines 0)))))

  ;; 鼠标滚动平滑
  (use-package smooth-scrolling
    :ensure t
    :config
    (smooth-scrolling-mode t))
  )

(defun frame/console-fix-up-control-arrows ()
  "控制台下C-<方向键>修复."
  (let ((map (if (boundp 'input-decode-map) input-decode-map function-key-map)))
    (define-key map "\e[1;5A" [C-up])
    (define-key map "\e[1;5B" [C-down])
    (define-key map "\e[1;5C" [C-right])
    (define-key map "\e[1;5D" [C-left])
    (define-key map "\e[5A"   [C-up])
    (define-key map "\e[5B"   [C-down])
    (define-key map "\e[5C"   [C-right])
    (define-key map "\e[5D"   [C-left])))
(add-hook 'after-make-console-frame-hooks 'frame/console-fix-up-control-arrows)

(defun frame/console-mouse-support ()
  "控制台下鼠标支持."
  (xterm-mouse-mode 1)
  (when (fboundp 'mwheel-install)
    (mwheel-install)))
(add-hook 'after-make-console-frame-hooks 'frame/console-mouse-support)

(defun frame/console-suspend-frame ()
  "控制台下使用`C-z`暂停程序."
  (interactive)
  (unless window-system (suspend-frame)))
(global-set-key (kbd "C-z") 'frame/console-suspend-frame)

(provide 'init-frame)
;;;  init-frame.el ends here
