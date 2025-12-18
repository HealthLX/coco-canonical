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

### Coding Conventions

#### XML Schema files should follow these conventions:

- name (most important - identifies what you're defining)
- type (what it is)
- minOccurs (cardinality constraints)
- maxOccurs (cardinality constraints)
- Other attributes (default, fixed, etc.)

```
<xs:complexType name="someName">
  <xs:sequence name="someName" type="someType minOccurs="0" maxOccurs="1" otherAttr="someValue">
</xs:complexType>
```

## 2. Submitting changes

1. Fork this repository.
2. Create a feature branch (`git checkout -b feature/my-change`).
3. Commit your changes with a clear message.
4. Open a Pull Request.

## 3. Verified Commits Requirement
To maintain the integrity of our healthcare data standards, coco-canonical requires all commits to be cryptographically signed. Signed commits receive a Verified badge, proving the code came from you and has not been altered.

Option 1: Use SSH (Simplest)
If you already use an SSH key to push code, you can use it to sign commits as well.

1. Add your key to GitHub:
- Go to your GitHub SSH Settings.
- Paste your public key (usually in ~/.ssh/id_ed25519.pub).
- Important: Set the "Key type" to Signing Key.
2. Configure Git locally: Run these three commands in your terminal:

`git config --global gpg.format ssh`

`git config --global user.signingkey ~/.ssh/id_ed25519.pub`

`git config --global commit.gpgsign true`

Option 2: Use GPG (Traditional)
If you prefer GPG or already have a GPG key, follow these steps:

1. Generate a key: Run gpg --full-generate-key (select RSA 4096-bit).
2. Add to GitHub: Export your public key and add it as a New GPG Key in your GitHub Settings.
3. Configure Git:

`git config --global user.signingkey YOUR_GPG_KEY_ID`

`git config --global commit.gpgsign true`

### Tips for Success
- Email Match: Your local Git email (git config user.email) must match the email on your GitHub profile and your signing key.
- GitHub Desktop: Once the local Git commands above are run, GitHub Desktop will automatically sign your commits.
- Official Docs: For detailed troubleshooting, see the [GitHub Signature Verification Guide](https://docs.github.com/en/authentication/managing-commit-signature-verification).

## 4. Code of conduct

Be respectful, collaborative, and constructive.

