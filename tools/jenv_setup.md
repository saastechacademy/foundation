# jenv Setup Guide (Ubuntu & macOS)

### 1. Install jenv

- **macOS (Homebrew):**

  ``` bash
  brew install jenv
  ```
- **Ubuntu (Git):** 
  ``` bash
  git clone https://github.com/jenv/jenv.git ~/.jenv
  ```

### 2. Configure Your Shell

  ``` bash
  Add jenv to `PATH`:  
  echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bashrc  
  echo 'eval "$(jenv init -)"' >> ~/.bashrc  
  ``` 
  **For Zsh**, replace `~/.bashrc` with `~/.zshrc`.
  
  ### 3. Verify Installation
  
  ``` bash
  jenv --version
  ```

### 4. Add Java Versions

  **Find Installed Java Paths**
  
  - **macOS:**
    ``` bash
    /usr/libexec/java_home -V
    ```
  - **Ubuntu:**
    ``` bash  
    update-java-alternatives --list
    ```
  
  **Add Java to jenv**
  
  ``` bash
  jenv add /path/to/java-17  
  jenv add /path/to/java-11  
  jenv add /path/to/java-8
  ```

### 5. Set Java Version

- **Globally (System-Wide):**
  ``` bash  
  jenv global 17
  ``` 
- **Locally (Per-Project):**
  ``` bash 
  cd /your/project  
  jenv local 11
  ```

### 6. Troubleshooting

**Command 'jenv' Not Found**

1. Ensure `PATH` is set correctly:
   ``` bash 
   echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc  
   echo 'eval "$(jenv init -)"' >> ~/.zshrc
   ```
   **For Bash**, replace `~/.zshrc` with `~/.bashrc`.
3. Confirm jenv is installed:
   ``` bash
   rm -rf ~/.jenv  
   If missing, reinstall:  
   rm -rf ~/.jenv && git clone https://github.com/jenv/jenv.git ~/.jenv
   ``` 
5. Check if jenv is recognized:
   ``` bash
   which jenv
   ```
   
  **Refresh jenv Plugins (if needed)**
  
  ``` bash
  jenv rehash  
  jenv doctor
  ```

  **Restart Terminal**

  ``` bash
  source ~/.bashrc  # or ~/.zshrc
  ```
  
### 7. Check Active Java Version

``` bash
java -version  
jenv versions
```