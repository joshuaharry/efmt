# efmt

Emacs autoformatting in less than 100 lines of code.

# Usage
Formatting is controlled via the special variable `*efmt-format-alist*` that maps file extensions (not major modes!) to formatters. Here's an example of how one might configure the list:

```elisp
(setq *efmt-format-alist*
  '(("el" #'my-custom-elisp-formatter)
	("js" ("prettier" "-w" "<TARGET>"))
	("go" ("gofmt" "-w" "<TARGET>"))))
```

More formally, you'll need to create a list of lists, where:
- The first element is a string that is the file extension.
- The second element is either:
  - A function to run.
  - A list of shell command arguments to execute on the file <TARGET>.

With that set up, you can format a buffer using `M-x efmt` from inside Emacs. Note that the point might move somewhere unexpected. You can also hook `efmt` up to an autosave hook, if you like.

# Testing

Install [eldev](https://github.com/doublep/eldev) and run:

```sh
eldev test
```

From inside this directory.
