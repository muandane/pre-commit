# pre-commit hooks

This repo defines Git pre-commit hooks intended for use with [pre-commit](https://pre-commit.com/). 
Currently there's only a hook for [kube-scape](https://github.com/kubescape/kubescape), will add more depending on the my workflow needs.

- **kubescape**: Automatically run a kubescape scan on all your defined kubernetes resources (*.yml and *.yamlfiles).

## General Usage

In each of your repos, add a file called .pre-commit-config.yaml with the following contents:

```yaml
repos:
  - repo: https://github.com/muandane/pre-commit
    rev: <VERSION> # Get the latest from: https://github.com/muandane/pre-commit/releases
    hooks:
      - id: kubescape
```

Next, you need:

1. Install `pre-commit`. E.g. `brew install pre-commit`.
1. Run `pre-commit install` in the repo.

That’s it! Now every time you commit a code change (.yaml/.yml file), the hooks in the `hooks:` config will execute.

## Kubescape arguments

TBD