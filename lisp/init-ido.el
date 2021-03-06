;;; package -- IDO配置
;;; Commentary:
;;; Code:

;; 阻止字节编译时的警告信息
(defvar ido-cur-item               nil)
(defvar ido-default-item           nil)
(defvar predicate                  nil)
(defvar inherit-input-method       nil)
(defvar ido-cur-list               nil)
(defvar ido-context-switch-command nil)

(config-after-fetch-require 'ido
  (setq-default ido-save-directory-list-file (concat user-temp-dir "ido.last")) ;; 保存目录
  (setq ido-enable-flex-matching t ;; 非常开放的匹配方式 aa 可以匹配 alpha
	ido-case-fold t ;; 忽略大小写
	ido-enable-regexp t ;; 支持正则表达式
	ido-use-filename-at-point nil
	ido-auto-merge-work-directories-length -1
	ido-use-virtual-buffers t
	ido-default-buffer-method 'selected-window ;; 当前面板打开buffer
	ido-default-file-method 'selected-window ;; 当前面板打开buffer
	)

  (ido-mode 1)
  (ido-everywhere 1)
  
  (config-after-fetch-require 'smex
    (setq-default smex-save-file (concat user-temp-dir "smex-items"))
    (global-set-key [remap execute-extended-command] 'smex)
    )

  (config-after-fetch-require 'ido-completing-read+
    (ido-ubiquitous-mode 1)
    )

  (config-after-fetch-require 'ido-yes-or-no
    (ido-yes-or-no-mode 1)
    )

  (config-after-fetch-require 'crm-custom
    (crm-custom-mode 1)
    )

  (config-after-fetch-require 'ido-select-window
    (global-set-key (kbd "C-x o") 'ido-select-window)
    )
  )

(provide 'init-ido)
;;;  init-ido.el ends here
