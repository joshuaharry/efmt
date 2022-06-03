;;; efmt.el --- Format code in Emacs your way.  -*- lexical-binding: t -*-

;; Copyright (C) 2022 Joshua Hoeflich

;; Author:     Joshua Hoeflich <joshuaharry411@icloud.com>
;; Maintainer: Joshua Hoeflich <joshuaharry411@icloud.com>
;; Version:    0.1.0
;; Keywords:   emacs, home
;; Homepage:   https://github.com/joshuaharry/efmt.el
;; Package-Requires: ((emacs "28.1"))

;;; Commentary:
;;; Configure `efmt-format-alist' the way you want. Then, run:
;;; - M-x efmt
;;; In the buffer you want to format.

(defvar *efmt-format-alist*
  nil
  "An associative list of file extensions to formatters to run.")

(defun efmt--validate (buf-file-name)
  "Validate that we can format the current buffer."
  (unless buf-file-name
    (error "There is no file associated with the current buffer; cannot format."))
  (let ((ext (file-name-extension buf-file-name)))
    (unless ext
      (error "There is no extension associated with the current file; cannot format."))
    (or (cadr (assoc ext *efmt-format-alist*))
	(error "Dont know how to format a %s file" ext))))

(defun efmt ()
  "Format the buffer, using the configuration `*efmt-format-alist' specifies."
  (interactive)
  
  (let ((ext (file-name-extension buffer-file-name)))
    (unless ext
      (error "Cannot determine extension for the current buffer."))))

(provide 'efmt)
;;; efmt.el ends here
