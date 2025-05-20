# bambrew

Bambrew - Bamboo Engineering's development environment setup tooling

# Mac First time setup

1. Ask an existing `bambooengineering/umbrella` administrator to grant you repo access
1. Setup a GitHub [personal access token][1]
1. Run the following at a command prompt:

```
sh -c "$(curl -fsSL https://github.com/bambooengineering/bambrew/raw/master/run_bamstrap)"
```

# Linux first time setup

Linux setup is largely done with Nix home-manager (not full NixOS). The steps below amount to
setting up home-manager, git and getting a checkout of the main repo. After that it is all a script
in that repo.

1. Start by installing Nix home-manager. At time of writing, the following command should work. It
   first installs the Nix package manager and daemon, and then installs home-manager.
    ```bash
    sh <(curl -L https://nixos.org/nix/install) --daemon
    ```
   Then open a new shell and run the following command to install home-manager:
    ```bash
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    nix-shell '<home-manager>' -A install
    ```
2. We need to get git and zsh on the machine. Run:
    `nix-shell -p zsh git gh`
3. Step three is optional you can either:
   1. Copy your ssh key into `/home/<username>/.ssh`. Typically, this is your `~/.ssh/id_ed25519` file.
      You may need a USB key for this.
      You can also run this to add your passphrase to the `ssh-agent`:
      ```bash
        ssh-add ~/.ssh/id_ed25519
      ```
    2. Use `gh` as installed above and run: `gh auth login`
       This will then prompt you to authenticate with github, which you can do via the browser.

4. Run the following command to clone the latest version of the umbrella git repo:
    ```bash
    # You can customise this with your favourite place to put git repos
    SILVERCAT_GIT_CHECKOUTS_DIR=~/code/gh/bambooengineering
    mkdir -p $SILVERCAT_GIT_CHECKOUTS_DIR
    gh repo clone bambooengineering/umbrella $SILVERCAT_GIT_CHECKOUTS_DIR/umbrella
    # Then link it to a known location
    ln -s $SILVERCAT_GIT_CHECKOUTS_DIR/umbrella ~/.umbrella
    ```
5. Add this to the top of your `~/.config/home-manager/home.nix` file:
    ```nix
    imports = [
        /home/<username>/.umbrella/bambrew/assets/nix/silvercat.nix
    ];
    ```
6. Run the following command to install the silvercat `home-manager` packages and system utilities.
   Note, this is idempotent and should be quick once completed a first time. You should run it
   regularly.
   ```bash
    ~/.umbrella/bambrew/scripts/setup.sh
   ```

That's it. Read the bambrew docs on starting up the development environment.
   ```

[1]: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
