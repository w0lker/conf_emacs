;;; package -- auto-complete配置
;;; Commentary:
;;; Code:

(when (maybe-require-package 'auto-complete)
  (require 'auto-complete)
  (require 'auto-complete-config)
  (ac-config-default)
  ;; 如果不包含大写则忽略大小写
  (setq ac-ignore-case 'smart)

  ;; 配置补全显示颜色
  (set-face-background 'ac-candidate-face "white")
  (set-face-background 'ac-selection-face "brightblack")
  (set-face-background 'popup-summary-face "white")
  (set-face-background 'popup-tip-face "brightblack")

  ;; 头文件补全配置
  (when (require-package 'auto-complete-c-headers)
    (defun my/ac-c-headers-init ()
      (require 'auto-complete-c-headers)
      (setq ac-disable-faces nil) ;; 解决include ""之间不自动提示问题
      (add-to-list 'ac-sources 'ac-source-c-headers)
      (add-to-list 'achead:include-directories '"/usr/local/include/c++/5.3.0")
      )
    (add-hook 'c-mode-common-hook 'my/ac-c-headers-init)
    )

  ;; 配置cedet
  (when (require-package 'cedet)
    (semantic-mode 1)
    (defun my/add-semantic-to-ac ()
      ;; 将语法分析的结果加入autocomplete的源当中
      (add-to-list 'ac-sources 'ac-source-semantic)

      ;; 当头文件找不到的时候会被高亮
      (global-semantic-decoration-mode 1)
      (custom-set-faces
       '(semantic-decoration-on-unknown-includes ((t (:background "brightmagenta")))))

      ;; 空闲5秒后就开始分析
      (global-semantic-idle-scheduler-mode 5)
      ;; 大于1M的数据就不分析
      (setq semantic-idle-scheduler-max-buffer-size 1000000)
      ;; 配置ede
      (global-ede-mode t)
      ;; 添加ede头信息到auto-complete-c-headers
      (add-hook 'ede-minor-mode-hook (lambda ()
                                       (setq achead:get-include-directories-function 'ede-object-system-include-path)))
      ;; 设置定位到代码的定义位置的快捷键
      (local-set-key (kbd "C-c r") 'semantic-ia-fast-jump))
    (add-hook 'c-mode-common-hook 'my/add-semantic-to-ac))
  )
(when (require-package 'auto-complete)
  (require 'auto-complete)
  (require 'auto-complete-config)
  (ac-config-default)
  ;; 如果不包含大写则忽略大小写
  (setq ac-ignore-case 'smart)

  ;; 配置补全显示颜色
  (set-face-background 'ac-candidate-face "white")
  (set-face-background 'ac-selection-face "brightblack")
  (set-face-background 'popup-summary-face "white")
  (set-face-background 'popup-tip-face "brightblack")

  ;; 头文件补全配置
  (when (require-package 'auto-complete-c-headers)
    (defun my/ac-c-headers-init ()
      (require 'auto-complete-c-headers)
      (setq ac-disable-faces nil) ;; 解决include ""之间不自动提示问题
      (add-to-list 'ac-sources 'ac-source-c-headers)
      (add-to-list 'achead:include-directories '"/usr/local/include/c++/5.3.0")
      )
    (add-hook 'c-mode-common-hook 'my/ac-c-headers-init)
    )

  ;; 配置cedet
  (when (require-package 'cedet)
    (semantic-mode 1)
    (defun my/add-semantic-to-ac ()
      ;; 将语法分析的结果加入autocomplete的源当中
      (add-to-list 'ac-sources 'ac-source-semantic)

      ;; 当头文件找不到的时候会被高亮
      (global-semantic-decoration-mode 1)
      (custom-set-faces
       '(semantic-decoration-on-unknown-includes ((t (:background "brightmagenta")))))

      ;; 空闲5秒后就开始分析
      (global-semantic-idle-scheduler-mode 5)
      ;; 大于1M的数据就不分析
      (setq semantic-idle-scheduler-max-buffer-size 1000000)
      ;; 配置ede
      (global-ede-mode t)
      ;; 添加ede头信息到auto-complete-c-headers
      (add-hook 'ede-minor-mode-hook (lambda ()
                                       (setq achead:get-include-directories-function 'ede-object-system-include-path)))
      ;; 设置定位到代码的定义位置的快捷键
      (local-set-key (kbd "C-c r") 'semantic-ia-fast-jump))
    (add-hook 'c-mode-common-hook 'my/add-semantic-to-ac))
  )

(provide 'init-auto-complete)
;;;  init-auto-complete.el ends here
