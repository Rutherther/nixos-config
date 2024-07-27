(require 'server)

(server-eval-at "server" '(let
                              ((frame (make-frame-command))
                               (buffer (generate-new-buffer "*emacs-anywhere*")))

  (defun my-emacs-anywhere-capture ()
    "Open a buffer called *emacs-anywhere*, wait for user input, and return the buffer content when C-c C-c is pressed."
    (interactive)
    (let ((buffer-name "*emacs-anywhere*"))
      (with-current-buffer (get-buffer-create buffer-name)
        (erase-buffer)
        (local-set-key (kbd "C-c C-c") 'my-emacs-anywhere-finish-capture)
        (local-set-key (kbd "C-c C-k") 'my-emacs-anywhere-abort-capture)
        (message "Type your input. Press C-c C-c to finish.")
        (switch-to-buffer buffer-name))))


  (defvar my-emacs-anywhere-content nil
    "Variable to store the content captured from *emacs-anywhere* buffer.")

  (defun my-emacs-anywhere-finish-capture ()
    "Finish capturing input and return the content of the *emacs-anywhere* buffer."
    (interactive)
    (let ((content (buffer-string)))
      (setq my-emacs-anywhere-content content)
      (kill-buffer buffer)
      (delete-frame frame)))

  (defun my-emacs-anywhere-abort-capture ()
    "Finish capturing input and return the content of the *emacs-anywhere* buffer."
    (interactive)
    (setq my-emacs-anywhere-content t)
    (kill-buffer buffer)
    (delete-frame frame))

  (select-frame frame)
  (switch-to-buffer buffer)
  (erase-buffer)
  (my-emacs-anywhere-capture)
  (setq my-emacs-anywhere-content nil)
  t))

(while (let ((my-emacs-anywhere-content (server-eval-at "server" 'my-emacs-anywhere-content)))
         (or (not my-emacs-anywhere-content)
             (and
                  (with-temp-buffer
                    (insert my-emacs-anywhere-content)
                    (write-region (point-min) (point-max) "/dev/stdout"))
                   f)))
  (sit-for 0.1))
