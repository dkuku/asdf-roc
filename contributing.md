# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

# TODO: adapt this
asdf plugin test roc https://github.com/dkuku/asdf-roc.git "roc -V"
```

Tests are automatically run in GitHub Actions on push and PR.
