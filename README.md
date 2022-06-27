# efmt

Emacs autoformatting in less than 100 lines of code.

# Usage

Formatting is controlled via the special variable `*efmt-format-alist*` that maps file extensions or major modes to formatters. Here's an example of how one might configure the list:

```elisp
(setq *efmt-format-alist*
'(("el" #'my-custom-elisp-formatter)
  ("js" ("prettier" "-w" "<TARGET>"))
  (ruby-mode ("rufo" "<TARGET>"))
  ("go" ("gofmt" "-w" "<TARGET>"))))
```

More formally, you'll need to create a list of lists with the following structure:

- The first element is a string that is the file extension or a symbol that is the major mode.
- The second element is either:
  - A function to run.
  - A list of shell command arguments to execute on the file `<TARGET>`.

If you have two different formatters in the list that could apply to a file based on both its major mode and its extension, the one associated with the file extension will win.

With that set up, you can format a buffer using `M-x efmt` from inside Emacs. Note that the point might move somewhere unexpected. You can also hook `efmt` up to an autosave hook, if you like.

# Testing

Install [eldev](https://github.com/doublep/eldev) and run:

```sh
eldev test
```

From inside this directory.
