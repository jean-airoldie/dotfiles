# Dotfiles
> An agglomeration of the various config files I use

## Import
```bash
# This will copy all the config files from the dotfiles directory/
# and copy them to the same location under ~. Please note that this
# will overwrite any config files already present at those locations.
$ ./export_to_user_space
# This will install the nvim plugins used in my config
$ nvim +PlugInstall +UpdateRemotePlugins +qa
