# Homebrew formula for [mimium](https://mimium.org)

```bash
brew tap mimium-org/mimium
brew install mimium
```

Bottle(binary package) is available on macOS 10.15, 11.0 and Linuxbrew.

## Update formula when the new release available

If there are no changes in depedencies, just execute

```sh
brew bump-formula-pr --version=0.2.0  mimium
```

Or, if you need to modidy formula, fork this repository and

```sh
cd $(brew --repository)/Library/Taps/mimium-org/homebrew-mimium
open mimium.rb # edit 
brew audit --strict --verbose mimium
git add . && git commit -m "commit msg"
git push # to your forked repo.
```
and make pull request to master branch of this repository.
