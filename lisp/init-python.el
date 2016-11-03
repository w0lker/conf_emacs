;;; Package -- Python开发环境配置
;;; Commentary:
;;; Code:

;; 关联文件
(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
                ("SConscript\\'" . python-mode))
              auto-mode-alist))

(setq
 ;; 设置python-mode的交互模式使用ipython
 python-shell-interpreter "ipython"
 python-shell-completion-native-enable nil
 python-shell-prompt-regexp "In \\[[0-9]+\\]: "
 python-shell-prompt-output-regexp "Out\\[[0-9]+\\]: ")
;; 解决“ansi-color-filter-apply: Args out of range”这个问题
(setenv "IPY_TEST_SIMPLE_PROMPT" "1")

;; 提供代码补全
(when (maybe-require-package 'anaconda-mode)
  (with-eval-after-load 'python
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

  (with-eval-after-load 'company
    (when (maybe-require-package 'company-anaconda)
      (add-hook 'python-mode-hook
                (lambda () (my/company/local-push-company-backend 'company-anaconda))))))

;; 保存时自动按照PEP8规范格式化代码
(when (require-package 'py-yapf) (require 'py-yapf))
(add-hook 'python-mode-hook 'py-yapf-enable-on-save)

;; 虚拟环境
(require-package 'pyenv-mode)
(require-package 'pyenv-mode-auto)
(require 'pyenv-mode-auto)

;; 配置环境变量，添加环境变量“PYENV_ROOT”和“PATH”
(defun my/python/set-environment-variables ()
  "Setting python buffer local environment variables."
  (make-local-variable 'process-environment)
  (with-temp-buffer
    (call-process "bash" nil t nil "-c"
                  "source ~/.bash_profile; env|egrep 'PYENV_ROOT|PATH'")
    (goto-char (point-min))
    (while (not (eobp))
      (setq process-environment
            (cons (buffer-substring (point) (line-end-position))
                  process-environment))
      (forward-line 1))))
(add-hook 'python-mode-hook 'my/python/set-environment-variables)

;; 提供PyPI补全
(require-package 'pip-requirements)

(provide 'init-python)
;;;  init-python.el ends here
