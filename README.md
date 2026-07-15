# utils
some utils script 


## Remote machine install

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/remote_dev_machine.sh | bash
```

Minimal variant (apt packages, git lg, starship + fzf in bash only):

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/remote_dev_simple.sh | bash
```

## AI CLI install (Claude Code + Codex)

Minimal install of [Claude Code](https://docs.anthropic.com/en/docs/claude-code) and [OpenAI Codex](https://github.com/openai/codex) (bundles Node.js 20 if needed):

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/install_ai_cli.sh | bash
```
