(require 'efmt)
(require 'buttercup)


(describe "efmt validations"
  (it "Should error when there is no file name"
    (should-error (efmt--validate nil)))
  (it "Should error when there is no extension"
    (should-error (efmt--validate "no-extension")))
  (it "Should error when the extension isn't part of the list"
    (let ((*efmt-format-alist* `(("el" ,(lambda () nil)))))
      (should-error (efmt--validate "js"))))
  (it "Should pass when the extension is part of the list"
    (let ((*efmt-format-alist* `(("el" ,(lambda () nil)))))
      (expect (functionp (efmt--validate "foo.el")) :to-be t))))

(describe "Finding and replacing <TARGET>"
  (it "Should work with a simple example"
    (expect (efmt--find-replace "hello" '("let's" "say" "<TARGET>" "world"))
	    :to-equal
	    '("let's" "say" "hello" "world"))))
