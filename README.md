# Homebrew Tap

Custom Homebrew formulas by [@beshkenadze](https://github.com/beshkenadze).

## Installation

```bash
brew tap beshkenadze/tap
```

Newer Homebrew gates third-party taps behind explicit trust. If you see
`Refusing to load formula ... from untrusted tap`, trust it once:

```bash
brew trust beshkenadze/tap
```

## Formulas

### Kaban

Terminal Kanban for AI Code Agents.

```bash
brew install kaban
```

Or directly:

```bash
brew install beshkenadze/tap/kaban
```

### AgentVault

Agent-agnostic secret broker that lets AI coding agents run commands with
credentials they never see in plaintext.

```bash
brew install agentvault
```

Or directly:

```bash
brew install beshkenadze/tap/agentvault
```

macOS-only (Touch ID / Secure Enclave). Builds from source, so it needs the Xcode
Command Line Tools (`xcode-select --install`) and pulls a Go toolchain at build
time. Latest `main`: `brew install --HEAD beshkenadze/tap/agentvault`.

## More Info

- [Kaban GitHub](https://github.com/beshkenadze/kaban)
- [Kaban Website](https://beshkenadze.github.io/kaban)
- [AgentVault GitHub](https://github.com/beshkenadze/agentvault)
