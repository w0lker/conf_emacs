;;; package -- 苹果配置
;;; Commentary:
;;; Code:

(defconst *is-a-mac* (eq system-type 'darwin))

(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'none)
  (setq-default default-input-method "MacOSX")
  ;; 减慢鼠标的滚动速度
  (setq mouse-wheel-scroll-amount '(1
                                    ((shift) . 5)
                                    ((control))))
  (dolist (multiple '("" "double-" "triple-"))
    (dolist (direction '("right" "left"))
      (global-set-key (read-kbd-macro (concat "<" multiple "wheel-" direction ">")) 'ignore)))
  (global-set-key (kbd "M-`") 'ns-next-frame) ;; 显示下一个frame
  (global-set-key (kbd "M-h") 'ns-do-hide-emacs) ;; 隐藏emacs
  )

;; 与系统剪贴板
(when *is-a-mac*
  ;; 取消首字母大写快捷键M-c，设置为复制选中的内容到粘贴板
  (global-unset-key (kbd "M-c"))
  (global-set-key (kbd "M-c") 'clipboard-kill-ring-save)
  ;; 取消滚动到文档最下面的快捷键M-v，设置为粘贴系统粘贴板中的内容
  (global-unset-key (kbd "M-v"))
  (global-set-key (kbd "M-v") 'clipboard-yank)
  )

;; 使用C-M-f触发全屏模式
(when (and *is-a-mac* (fboundp 'toggle-frame-fullscreen))
  (global-set-key (kbd "C-M-f") 'toggle-frame-fullscreen))

;; 设置默认查找命令
(when *is-a-mac*
  (setq-default locate-command "mdfind"))

(provide 'init-osx)
;;;  init-osx.el ends here
