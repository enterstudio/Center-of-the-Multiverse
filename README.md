# Center Of the Multiverse

## Setup

### Installing python

get python36+ from your package manager or https://www.python.org/downloads/

### Installing voodoo

clone (or pull) voodoo from github

```
git clone git@github.com:NikkyAI/voodoo-pack.git
cd voodoo-pack
git pull
```

install voodoo

```
make install

# if you have no make installed run these commands
# replace pip with pip3 on systems where python2 is the default

pip uninstall -y voodoo
pip install --user .
```

windows users might have to make sure that the scripts directory in the python install (most likely in `%appdata%`) is added to the `%PATH%`

### Optional

install graphviz and make sure it is also added to the PATH


```
# verfify that graphviz can be called
dot -V
fdp -V
```

## Building CotM

```
# git clone git@github.com:elytra/Center-of-the-Multiverse.git
# cd Center-of-the-Multiverse
# git pull

voodoo cotm.yaml
```