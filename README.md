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
setting up home-manager, git and getting a checkout of the main repo. After that, it is all a script
in that repo.

The script in this repo will achieve that. The steps are:

1. Run this to get `home-manager` and the main repo ready:
   ```bash
   SILVERCAT_GIT_CHECKOUTS_DIR= ~/code/gh/bambooengineering sudo sh -c "$(curl -fsSL https://github.com/bambooengineering/bambrew/raw/master/run_bamstrap_linux)"
   ```
2. Add this to the top of your `~/.config/home-manager/home.nix` file:
    ```nix
    imports = [
        /home/<username>/.umbrella/bambrew/assets/nix/silvercat.nix
    ];
    ```
3. Run the following command to install the silvercat `home-manager` packages and system utilities.
   Note, this is idempotent and should be quick once completed the first time. You should run it
   regularly.
   ```bash
   ~/.umbrella/bambrew/scripts/setup.sh
   ```

That's it. Read the bambrew docs on starting up the development environment.

[1]: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
