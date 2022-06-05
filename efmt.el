;;; efmt.el --- Format code in Emacs your way.  -*- lexical-binding: t -*-

;; Copyright (C) 2022 Joshua Hoeflich

;; Author:     Joshua Hoeflich <joshuaharry411@icloud.com>
;; Maintainer: Joshua Hoeflich <joshuaharry411@icloud.com>
;; Version:    0.1.0
;; Keywords:   emacs, home
;; Homepage:   https://github.com/joshuaharry/efmt.el
;; Package-Requires: ((emacs "28.1"))

;;; Commentary:
;;; Configure `efmt-format-alist' with the formatters you would like. Here's an example:
;;;
;;; (setq *efmt-format-alist*
;;;   '(("el" #'my-custom-elisp-formatter)
;;;	("js" '("prettier" "-w" "<TARGET>"))
;;;	("go" '("gofmt" "-w" "<TARGET>"))))
;;;
;;; The shell commands are expected to operate on the file <TARGET> in the list. Functions
;;; in the alist are called.
;;;
;;; After all of that is then set up, run:
;;; - M-x efmt
;;;
;;; In the buffer you want to format. You can configure the 'after-save-hook to run efmt if
;;; you would like as well.

;;; Code:
(defvar *efmt-format-alist*
  nil
  "An associative list of file extensions to formatters to run.
Elements in the map can be:
- A shell command as provided via a list of arguments: (e.g., '(\"gofmt\" \"-w\" \"<TARGET\"))
- A function that can be called with no arguments (e.g., #'my-function)
In the shell commands, <TARGET> refers to the file you want to have formatted.")

(defun efmt--validate (buf-file-name)
  "Validate that we can format the current buffer."
  (unless buf-file-name
    (error "There is no file associated with the current buffer; cannot format."))
  (let ((ext (file-name-extension buf-file-name)))
    (unless ext
      (error "There is no extension associated with the current file; cannot format."))
    (or (cadr (assoc ext *efmt-format-alist*))
	(error "Dont know how to format a %s file" ext))))

(defun efmt--find-replace (file-name l)
  "Find and replace all instances of <TARGET> in L with the provided FILE-NAME."
  (mapcar (lambda (el) (if (string= el "<TARGET>") file-name el)) l))

(defun efmt--shell-formatter (l)
  "Format the buffer using the shell command L specifies."
  (let* ((buffer-text (buffer-string))
	 (extension (concat "." (file-name-extension buffer-file-name)))
	 (buffer-file (make-temp-file "efmt" nil extension buffer-text))
	 (temp-buf-name (concat " *" (number-to-string (random)) "*")))
    (set-process-sentinel
     (apply (apply-partially #'start-process "efmt" temp-buf-name)
	    (efmt--find-replace buffer-file l))
     (lambda (process _)
       (if (= 0 (process-exit-status process))
	   (let ((cur-point (point)))
	     (erase-buffer)
	     (insert-file-contents buffer-file)
	     (goto-char cur-point) ;; Not correct, but good enough
	     (kill-buffer temp-buf-name)
	     (message "Buffer formatted successfully."))
	 (display-buffer temp-buf-name)
	 (message "Failed to format the buffer"))))))

(defun efmt ()
  "Format the buffer, using the configuration `*efmt-format-alist' specifies."
  (interactive)
  (let ((formatter (efmt--validate buffer-file-name)))
    (cond
     ((listp formatter)
      (efmt--shell-formatter formatter))
     ((functionp formatter)
      (funcall formatter))
     (:otherwise
      (print formatter)
      (error "Invalid formatter in efmt-format-alist; check *Messages* to see the value which triggered this error")))))

(provide 'efmt)
;;; efmt.el ends here
