# Dotfiles

Personal shell configuration shared between Ubuntu and WSL machines.

## Repository layout

- `install.sh` installs dependencies and links `~/.zshrc` to `zsh/.zshrc`.
- `doctor.sh` coordinates diagnostics and prints their summary. Zsh checks live in `zsh/doctor.sh`. Keep `./install.sh doctor` as an entry point.
- `zsh/.zshrc` configures Oh My Zsh, loads `shortcuts.zsh`, then loads `~/.zshrc.local` if present.
- `zsh/shortcuts.zsh` defines shared aliases, functions, the shortcuts guide, and key bindings.

## Conventions

- Write code, comments, and terminal messages in English.
- Use Bash for installation and diagnostics, and Zsh for interactive configuration.
- Resolve paths relative to the script or configuration file. Support checkout paths containing spaces.
- Keep machine-specific settings such as `fixAudio` and Windows application paths in `~/.zshrc.local`.
- Preserve the SSH host configured for each Git remote so personal and work accounts can coexist.

## Installer and diagnostics

- Check each dependency and plugin independently.
- Back up an existing `.zshrc` before replacing it and print the backup path.
- If the correct symlink already exists, leave it in place.
- Keep doctor checks read-only and return a nonzero exit status if a check fails.

## Interactive behavior

- Reuse aliases provided by the Oh My Zsh git plugin.
- Keep the `shortcuts` guide focused on frequently used commands.
- Print the expanded alias once, then let Zsh execute the command.
- Keep `cd` quiet and preserve the `Ctrl+L` binding that clears the screen and scrollback.

## Validation

Run `bash -n` on each changed Bash script and `zsh -n` on each changed Zsh file.
For startup changes, open a fresh Zsh session and verify `shortcuts` and `gst -sb`.
Test installer changes in a disposable environment, including a second installation.

## Organize files by tool

- Give each tool its own top-level directory, such as `zsh/`, `git/`, or `vscode/`.
- Keep each tool's configuration, aliases, functions, scripts, and templates together in its directory. For example, Zsh files live under `zsh/`, including `.zshrc` and `shortcuts.zsh`.
- When adding a file, place it under the tool that uses it. For example, Git aliases written for Zsh belong in `zsh/`, while aliases defined in `.gitconfig` belong in `git/`.
- Keep repository-wide entry points such as `install.sh`, `doctor.sh`, and `AGENTS.md` at the root. If a tool needs its own installer or checks, put them in that tool's directory and call them from the root entry point.
- Create a tool directory when it has files to manage.
- 
## Shell scripting practices

- Write scripts for someone who knows the terminal but may be learning shell scripting. Use descriptive names such as `backup_dir`, `plugin_dir`, and `config_file`.
- Use the shebang to identify the shell. Write installers and diagnostics for Bash, and interactive shortcuts and key bindings for Zsh.
- Quote path variables and arguments, for example `"$config_file"` and `"$@"`, so paths containing spaces work correctly.
- Prefer a readable `if` block when a condition triggers several actions. Keep common commands short when their meaning is already clear.
- Comment on decisions that are easy to miss. For example, explain why `.zshrc` needs a backup or why a path must follow a symlink. Skip comments that just repeat the command.
- When introducing an unfamiliar flag or shell expansion, explain its effect in plain language. For example, `-L` checks whether a path is a symlink, while `-ef` checks whether two paths refer to the same file.
- Before changing a user file, check its current state. If the installer creates a backup or replaces a link, print the affected paths so the user can inspect the result.
- Handle expected failures explicitly. For example, `grep` returns status 1 when it finds no match. Use it in a condition when that outcome is expected.
- When explaining a change, say what command to run, what it changes, and how to verify it. Include a short example when it makes the behavior easier to understand.
EOF


## Reliability and portability

- Make shell configuration safe to reload. Sourcing `shortcuts.zsh` twice should register each hook once. Running `gst` should still print the expanded command once.
- Keep shell startup fast and quiet. Put downloads, package installation, and diagnostics in explicit commands such as `./install.sh` and `./install.sh doctor`. Opening a terminal or changing directories should not trigger them.
- Preserve command output for pipes and scripts. Send informational messages to stderr. For example, `branch | wc -l` should count only the branch name, even when alias tracing is enabled.
- Use the permissions each file needs. Make directly invoked scripts such as `install.sh` executable. Sourced files such as `.zshrc` and `shortcuts.zsh` only need to be readable. Avoid blanket permissions such as `chmod 777`.
- Preserve existing user configuration when installation fails. Verify that the replacement file exists before backing up an active config, and stop if the backup fails.
- Run ShellCheck on changed Bash scripts when available. Use `zsh -n` for Zsh syntax and test interactive behavior in a fresh shell.
