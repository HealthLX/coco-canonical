# Rules for contributors to CoCo
Thanks for your interest in contributing!



## 1. Development guidelines

- Use **2 spaces for indentation** in all `.xml` and `.xsd` files (no tabs).  
- Line endings should be **LF** (`\n`).  
- Run `grep -n $'\t' *.xml *.xsd 2>/dev/null && echo 'Tabs found!' || echo 'OK'` before committing to confirm there are no tabs.  

### XML/XSD Formatting

To keep diffs clean and consistent across editors, all XML, XSD, and XSL files must use **2 spaces for indentation** (no tabs).

This project enforces formatting via `.editorconfig`, which most editors support automatically:

- **VS Code**: built-in EditorConfig support. Ensure `"editor.detectIndentation": false` in settings.
- **Sublime Text**: install the EditorConfig plugin.
- **IntelliJ / Android Studio**: enable EditorConfig support in Preferences.
- **Vim/Neovim**: install `editorconfig-vim`.

## 2. Submitting changes

1. Fork this repository.
2. Create a feature branch (`git checkout -b feature/my-change`).
3. Commit your changes with a clear message.
4. Open a Pull Request.

## 3. Code of conduct

Be respectful, collaborative, and constructive. See `CODE_OF_CONDUCT.md` for details.