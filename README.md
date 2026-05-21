# myopencode

This project provides a Docker container that runs the open source AI coding agent [opencode](https://opencode.ai/) in a clean, isolated environment.
The container includes `opencode` and other essential development tools (Java/Maven, Python, common utilities).
It maps your local directories into the container, giving you a safe and consistent development experience regardless of your host system.

Why use a container for opencode?

- **Isolation**: A fresh environment each time, free from host system clutter or conflicting configurations
- **Reproducibility**: The same tools and versions every time, ensuring consistent behavior across different machines
- **Clean state**: No need to manually clean up temporary files, caches, or configurations between sessions
- **Portability**: Works the same on macOS, Linux, or Windows (with WSL2)

The container is designed to be lightweight while providing all the tools opencode needs to work effectively.

### Quick Start

**Clone the repository**

```bash
git clone <repo-url> myopencode
cd myopencode
```

**Build the container**

```bash
docker build -t myopencode .
```

**Add the `myopencode` script to your PATH**

```bash
cp myopencode ~/.local/bin/
# or
PATH=/path/to/checkout:$PATH
```

**Run opencode**

```bash
myopencode /path/to/your/project
```

Replace `/path/to/your/project` with the directory you want to work in.
This folder will be mounted into the container.
A `.myopencode` folder will be created here, which contains local information to persist between sessions.


### How It Works

The `myopencode` script launches a Docker container with three directory mounts:

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `~/.config/opencode/` | `/root/.config/opencode` | Your opencode configuration |
| `~/.m2/` | `/root/.m2/` | Maven repository cache |
| Your project directory | `/workdir` | Your workspace |

The container uses `/root` as the home directory to ensure consistent behavior across different host systems.

### Benefits

What You Get

- **Opencode ready to use**: No need to install opencode manually or worry about compatibility
- **Development tools included**: Java, Maven, Python, and common utilities are pre-installed
- **Clean workspace**: Each container starts fresh; no leftover files from previous sessions
- **Consistent environment**: The same setup works the same way on every machine

What Happens Inside the Container

1. **Clean slate**: A minimal base image with essential packages
2. **Opencode installed**: Available globally via npm
3. **Your config preserved**: opencode settings, git config, etc. are mounted from your host
4. **Maven cache shared**: Avoids re-downloading dependencies on every session
5. **Workspace accessible**: Your project files are available at `/workdir`

### Session Persistence

The `.myopencode/` directory stores opencode data that persists between container runs. It is mounted into the container at `/root/.local/share/opencode` and `/root/.local/state/opencode` via symlinks.

| Path | Contents |
|------|----------|
| `.myopencode/share/` | Database, session diffs, logs |
| `.myopencode/state/` | Current model, prompt history |

This means your conversations, configured model, and settings carry over from one session to the next. The directory is git-ignored by default so it does not clutter your repository.



