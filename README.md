# utils
some utils script 


## Remote machine install

### 1. Full

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/remote_dev_machine.sh | bash
```

### 2. Dev

apt packages, git lg, starship + fzf in bash only:

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/remote_dev_simple.sh | bash
```

### 3. Dev + Agent

same as Dev, plus Claude Code + Codex (bundles Node.js 20):

```
curl -sS https://raw.githubusercontent.com/samsja/utils/main/remote_dev_agent.sh | bash
```
