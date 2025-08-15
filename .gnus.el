;;; .gnus.el --- GNUS configuration -*- lexical-binding: t; -*-

;;; Commentary:
;;    This file contains configuration specific to reading usenet news and
;;    mail.  It is based on
;;    https://github.com/redguardtoo/mastering-emacs-in-one-year-guide/blob/b1cbf90/gnus-guide-en.org.
;;    However, to ensure common setup for `debbugs' most of the configuration
;;    has been moved to
;;    https://github.com/pkryger/exordium-commontap/blob/fe23261/after-init.el#L2250-L2321

;;; Code:

(eval-when-compile
  (require 'gnus))

(declare-function gnus-group-list-all-groups "gnus-group")
(declare-function gnus-topic-set-parameters "gnus-topic")

;; Please note mail folders in `gnus-select-method' have NO prefix like
;; "nnimap+hotmail:" or "nnimap+gmail:"
(setopt gnus-select-method '(nntp "news.gwene.org")) ;; Read feeds/atom through gwene

;; @see https://gnus.org/manual/gnus_397.html
(add-to-list 'gnus-secondary-select-methods
             '(nnimap "gmail"
                      (nnimap-address "imap.gmail.com")
                      (nnimap-server-port 993)
                      (nnimap-stream ssl)
                      (nnir-search-engine imap)
                      ; See info node (gnus) Expiring Mail
                      ;; press 'E' to expire email and move it to Bin
                      (nnimap-expunge 'immediate)
                      (nnmail-expiry-target "nnimap+gmail:[Gmail]/Bin")
                      (nnmail-expiry-wait 'immediate)))

;; Sample on how to organise mail folders.
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
     (setopt gnus-topic-alist '(("gmail" ; the key of topic
                                 "nnimap+gmail:Important"
                                 "nnimap+gmail:[Gmail]/Important"
                                 "nnimap+gmail:INBOX"
                                 "nnimap+gmail:promotions"
                                 "nnimap+gmail:emacs-devel"
                                 "nnimap+gmail:gnucash"
                                 "nnimap+gmail:[Gmail]/Drafts"
                                 "nnimap+gmail:[Gmail]/Sent Mail"
                                 "nnimap+gmail:[Gmail]/All Mail"
                                 "nnimap+gmail:[Gmail]/Notes"
                                 "nnimap+gmail:[Gmail]/Spam"
                                 "nnimap+gmail:[Gmail]/Bin")
                                ("Gnus")))

     ;; see latest 200 mails in topic hen press Enter on any group
     (gnus-topic-set-parameters "gmail" '((display . 200)))))

(provide '.gnus)

;;; .gnus.el ends here
