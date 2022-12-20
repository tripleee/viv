# Viv isn't venv

## Setup

Start by cloning the repo and symlinking the script for access to the CLI.
By default it will symlink `./src/viv.py` to `~/bin/viv`.
You can set `PREFIX` to symlink to a different location.

```sh
git clone git@github.com:daylinmorgan/viv.git ~/.viv
make install # or PREFIX=~/.local/bin make install
```

Place this directory on the python path in your rc file.

```sh
export PYTHONPATH="$PYTHONPATH:$HOME/.viv/src"
```

Then in any python script with external dependencies you can add this line.

```python
__import__("viv").activate("click")
```

## Usage

To temove all viv venvs:
```sh
viv remove $(viv list -q)
```


## TODO
- [ ] add doc strings to `src/viv.py`
- [ ] use config file (probably ini or json / could also allow toml for python>=3.11)
- [ ] enable a garbage collection based on time or file existence (configurable)
- [ ] unit tests

## Alternatives

- `pipx`
- `pip-run`
