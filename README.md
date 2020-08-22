# Homebrew formula for [mimium](https:/github.com/mimium-org/mimium)

```bash
brew tap mimium-org/mimium
brew install mimium
```

## On Linux

Default gcc for Linuxbrew, which is version 5.5 may cause conflict with gcc@9 when link with standard library. If you failed to install, try

```bash
brew unlink gcc@5.5
brew link gcc@9
brew install mimium
brew link gcc@5.5 --overwrite
```

