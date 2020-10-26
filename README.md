# Sound for Videogames

## 📚 Clone the Project!

You can do so via CLI (Command Line Interface) using the [Git SCM](https://git-scm.com), or you can use a tool of your
preference!

```bash
# Clone this project:
git clone https://github.com/kyranet/son
# SSH: git clone git@github.com:kyranet/son.git

# Initialize submodules, required so dependencies
# are pulled:
git submodule init

# Update submodules to keep them up-to-date with the
# commit from this repository:
git submodule update
```

## 🚀 Set it Up!

First of all, you might need to change [PowerShell]'s policy settings to run our script, it is because we provide an
unofficial script, to allow it, you will need to use the [Set-ExecutionPolicy] command, you can safely do the following:

```ps1
Set-ExecutionPolicy Unrestricted -Scope Process
```

### If you have **PowerShell v6 or newer**, run the following command:

```bash
pwsh ./scripts/build.ps1
```

> **Note**: You can update it [here](https://github.com/PowerShell/PowerShell)!

### With PowerShell **v5 or older**:

```bash
powershell ./scripts/build.ps1
```

## 🌠 Start it Up!

If the command above succeeded, then you're all set! Open `open-al-intro.sln` with [Visual Studio], or open this project
with [Visual Studio Code] using the [C/C++] extension!

[PowerShell]: https://wikipedia.org/wiki/PowerShell
[Set-ExecutionPolicy]: https://docs.microsoft.com/powershell/module/microsoft.powershell.security/set-executionpolicy
[Visual Studio]: https://en.wikipedia.org/wiki/Microsoft_Visual_Studio
[Visual Studio Code]: https://en.wikipedia.org/wiki/Visual_Studio_Code
[C/C++]: https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools
