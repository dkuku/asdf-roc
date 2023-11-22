<div align="center">

# asdf-roc [![Build](https://github.com/dkuku/asdf-roc/actions/workflows/build.yml/badge.svg)](https://github.com/dkuku/asdf-roc/actions/workflows/build.yml) [![Lint](https://github.com/dkuku/asdf-roc/actions/workflows/lint.yml/badge.svg)](https://github.com/dkuku/asdf-roc/actions/workflows/lint.yml)

[roc](https://www.roc-lang.org) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add roc
# or
asdf plugin add roc https://github.com/dkuku/asdf-roc.git
```

roc:

```shell
# Show all installable versions
asdf list-all roc

# Install specific version
asdf install roc latest

# Set a version globally (on your ~/.tool-versions file)
asdf global roc latest

# Now roc commands are available
roc -V
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/dkuku/asdf-roc/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Daniel Kukula](https://github.com/dkuku/)
