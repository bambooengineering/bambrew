# bambrew
Bambrew - Bamboo Engineering's development environment setup tooling

# First time setup

1. On another machine (maybe) set up a GitHub [personal access token][1].
1. Copy it to your new machine here: `~/.config/hub` in this file format:
   ```yaml
   github.com:
   - user: <username>
     oauth_token: <token>
     protocol: https
   ```
1. Ask an existing `bambooengineering/umbrella` administrator to grant you repo access
1. Run the following at a command prompt:

```
sh -c "$(curl -fsSL https://github.com/bambooengineering/bambrew/raw/master/run_bamstrap)"
```

[1]: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
