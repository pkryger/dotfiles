;;; .gnus.el --- GNUS configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;  Based on https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/master/gnus-guide-en.org

;;; Code:

(eval-when-compile
  (require 'gnus))

(declare-function gnus-group-list-all-groups "gnus-group")
(declare-function gnus-topic-mode "gnus-topic")
(declare-function gnus-topic-set-parameters "gnus-topic")

;; Please note mail folders in `gnus-select-method' have NO prefix like "nnimap+hotmail:" or "nnimap+gmail:"
(setopt gnus-select-method '(nntp "news.gwene.org")) ;; Read feeds/atom through gwene

;; @see https://gnus.org/manual/gnus_397.html
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "gmail"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      ; @see https://www.gnu.org/software/emacs/manual/html_node/gnus/Expiring-Mail.html
                      ;; press 'E' to expire email
                      (nnimap-expunge 'immediate)
                      (nnmail-expiry-target "nnimap+gmail:[Gmail]/Bin")
                      (nnmail-expiry-wait 'immediate)))


;; list all the subscribed groups even they contain zero un-read messages
(defun pk/gnus-group-list-subscribed-groups ()
  "List all subscribed groups with or without un-read messages."
  (interactive)
  (gnus-group-list-all-groups 5))

(bind-key "o" #'pk/gnus-group-list-subscribed-groups gnus-group-mode-map)

(setopt gnus-thread-sort-functions
        '(gnus-thread-sort-by-most-recent-date
          (not gnus-thread-sort-by-number)))

;; NO 'passive
(setopt gnus-use-cache t)

;; Tree view for groups.
(add-hook 'gnus-group-mode-hook #'gnus-topic-mode)

;; Threads!  I hate reading un-threaded email -- especially mailing
;; lists.  This helps a ton!
(setopt gnus-summary-thread-gathering-function 'gnus-gather-threads-by-subject)

;; Also, I prefer to see only the top level message.  If a message has
;; several replies or is part of a thread, only show the first message.
;; `gnus-thread-ignore-subject' will ignore the subject and
;; look at 'In-Reply-To:' and 'References:' headers.
(setopt gnus-thread-hide-subtree t)
(setopt gnus-thread-ignore-subject t)
(setopt gnus-not-empty-thread-mark ?\uffee) ; ￮ half width white circle


(defvar gnus-tmp-lines)
(defun gnus-user-format-function-human-lines (_)
  "Convert LINES for a human consumption.
The result is always up to 4 characters long and is an approximation for
a number over a 1000."
  (pcase gnus-tmp-lines
    ((rx (any "1-9") (>= 9 (any digit)))
     "1B+")
    ((and (rx (group (any "1-9") (** 0 2 (any digit))) (= 6 (any digit))) l)
     (format "%sM" (match-string 1 l)))
    ((and (rx (group (any "1-9") (** 0 2 (any digit))) (= 3 (any digit))) l)
     (format "%sk" (match-string 1 l)))
    (_ gnus-tmp-lines)))

(setopt gnus-summary-line-format
        (if-let* ((format (bound-and-true-p gnus-summary-line-format))
                  ((< 0 (length format)))
                  ((not (string-match (rx "%e") format))))
            (thread-last
              format
              (replace-regexp-in-string (rx "%" (zero-or-more digit) "L")
                                        "%4u&human-lines;")
              (concat "%e"))
          "%e%U%R%z%I%(%[%4u&human-lines;: %-23,23f%]%) %s\n"))

;; https://www.gnu.org/software/emacs/manual/html_node/gnus/_005b9_002e2_005d.html
(setopt gnus-use-correct-string-widths nil)

;; Sample on how to organize mail folders.
;; It's dependent on `gnus-topic-mode'.
(eval-after-load 'gnus-topic
  '(progn
     (setopt gnus-message-archive-group '((format-time-string "sent.%Y")))
     (setopt gnus-server-alist '(("archive" nnfolder "archive" (nnfolder-directory "~/Mail/archive")
                                  (nnfolder-active-file "~/Mail/archive/active")
                                  (nnfolder-get-new-mail nil)
                                  (nnfolder-inhibit-expiry t))))

     ;; "Gnus" is the root folder, and there is a "gmail" account
     (setopt gnus-topic-topology '(("Gnus" visible)
                                   (("gmail" visible nil nil))))

     ;; each topic corresponds to a public imap folder
     (setopt gnus-topic-alist '(
                                ("gmail" ; the key of topic
                                 "nnimap+gmail:Important"
                                 "nnimap+gmail:INBOX"
                                 "nnimap+gmail:promotions"
                                 "nnimap+gmail:emacs-devel"
                                 "nnimap+gmail:gnucash"
                                 "nnimap+gmail:[Gmail]/Drafts"
                                 "nnimap+gmail:[Gmail]/Sent Mail"
                                 "nnimap+gmail:[Gmail]/All Mail"
                                 "nnimap+gmail:[Gmail]/Spam"
                                 "nnimap+gmail:[Gmail]/Bin")
                                ("Gnus")))

     ;; see latest 200 mails in topic hen press Enter on any group
     (gnus-topic-set-parameters "gmail" '((display . 200)))))


(defun pk/helm-completing-read-hack-gnus-default (args)
  ;; checkdoc-params: (args)
  "Update default pattern for `helm-completing-read-default-handler'."
  (when-let* (((listp args))
              (name (nth 8 args))
              (def (nth 4 args))
              ((and (stringp name) (stringp def)))
              ((string-prefix-p "gnus-" name)))
    (setf (nth 4 args) ;; `when-let*' doesn't bind places
          (replace-regexp-in-string "+" "\\\\+" def)))
  args)

(when (fboundp 'helm-completing-read-default-handler)
  (advice-add #'helm-completing-read-default-handler
              :filter-args #'pk/helm-completing-read-hack-gnus-default))

(provide '.gnus)

;;; .gnus.el ends here
