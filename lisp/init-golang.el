;;; package -- Go语言配置
;;; Commentary:
;;; Code:

(config-after-fetch-require 'go-mode

  (config-add-hook 'go-mode-hook
    ;; 基本配置.
    (add-hook 'before-save-hook 'gofmt-before-save)
    (local-set-key (kbd "M-.") 'godef-jump)
    (local-set-key (kbd "M-*") 'pop-tag-mark)
    (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)

    (with-eval-after-load 'company
      (config-after-fetch-require 'company-go
	(company/push-local-backend 'company-go)
	)
      )

    (config-after-fetch-require 'go-eldoc
      (go-eldoc-setup)
      (with-eval-after-load 'diminish
	(diminish 'eldoc-mode)
	)
      )
    )
  )

(provide 'init-golang)
;;;  init-golang.el ends here
