;; 配置存放位置
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(require 'init-startup)
(require 'init-themes)
(require 'init-windows)
(require 'init-ido)
(require 'init-buffer)
(require 'init-dired)
(require 'init-editing)
(require 'init-cpp)
(require 'init-markdown)
(require 'init-dash)
(require 'init-projectile)
(require 'init-evil)
(require 'init-sessions)

