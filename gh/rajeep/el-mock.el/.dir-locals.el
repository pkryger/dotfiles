((nil . ((ispell-local-dictionary . "american")
         (sentence-end-double-space . t)
         (fill-column . 80)))
 (emacs-lisp-mode . ((indent-tabs-mode . nil)
                     (flycheck-emacs-lisp-load-path . inherit)
                     (eval . (progn
                               (make-local-variable 'package-lint--allowed-prefix-mappings)
                               (add-to-list 'package-lint--allowed-prefix-mappings '("el-mock" . ("mock-" "mock/" "stub/" "not-called/")))
                               (setq-local package-lint--sane-prefixes
                                           (rx (or (regexp package-lint--sane-prefixes)
                                                   (seq string-start (or "with-"))
                                                   (seq string-start
                                                        (or "mock" "stub" "not-called")
                                                        (or string-end "/" (seq "let" string-end)))
                                                   (seq string-start "mocklet-function" string-end)))))))))
