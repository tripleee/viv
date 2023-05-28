# viv

<div align="center">
  <a href="https://github.com/daylinmorgan/viv">
    <img src="https://raw.githubusercontent.com/daylinmorgan/viv/main/assets/logo.svg" alt="Logo" width=500 >
  </a>
  <p align="center">
  viv isn't venv
  </p>
</div>
<br />

---

Python is a great choice to quickly prototype or accomplish small tasks in scripts.
However, leveraging it's vast ecosystem can be tedious for one-off or rarely used scripts.
This is were `viv` comes in handy.

`Viv` is a standalone dependency-free `venv` creator.
It is meant to be invoked in any script that has third-party dependencies,
prior to loading of any of the external modules.

These `venvs` can be identified by name or by their specification.
In any case they will be re-used across scripts (and generated on-demand, if needed).

**Importantly**, `viv` will also remove your user site directory.
(view with: `python -m 'import site;print(site.USER_SITE)'`).

## Setup

Run the below command to install `viv`.

```sh
python3 <(curl -fsSL gh.dayl.in/viv/viv.py) manage install
```

To access `viv` from within scripts you should add it's location to your `PYTHONPATH`.
By default `viv` will be installed to `$XDG_DATA_HOME/viv` or `~/.local/share/viv` you can customize this with `--src`.

```sh
export PYTHONPATH="$PYTHONPATH:$HOME/.local/share/viv"
```

Advanced users may recognize that principally,
the module just needs to be recognized at run time
and the single script [`viv.py`](https://github.com/daylinmorgan/viv/blob/main/src/viv/viv.py) can be invoked directly for the CLI.
How you accomplish these options is ultimately up to you but the above instructions can get you started.

### Pypi (Not Recommended)

```sh
pip install viv
```

Why is this *not recommended*? Mainly, because `viv` is all about hacking your `sys.path`.
Placing it in it's own virtual environment or installing in a user site directory may complicate this endeavor.

## Usage

In any python script with external dependencies you can add this line,
to automate `vivenv` creation and installation of dependencies.

```python
__import__("viv").use("click")
```

To remove all `vivenvs` you can use the below command:

```sh
viv remove $(viv list -q)
```

# Standalone Viv

Supposing you want to increase the portability of your script while still employing the principles of `viv`.

The below function can be freely pasted at the top of your scripts and requires
no modification of your PYTHONPATH or import of additional modules (including downloading/installing `viv`).

It can be auto-generated with for example: `viv freeze <spec> --standalone`.

The only part necessary to modify if copied verbatim from below is the call to `_viv_use`.

Output of `viv freeze rich --standalone`:

```python
# <<<<< auto-generated by daylinmorgan/viv (v22.12a3-35-g0d0c66d-dev)
# fmt: off
def _viv_use(*pkgs: str, track_exe: bool = False, name: str = "") -> None:                                    # noqa
    i,s,m,e,spec=__import__,str,map,lambda x: True if x else False,[*pkgs]                                    # noqa
    if not {*m(type,pkgs)}=={s}: raise ValueError(f"spec: {pkgs} is invalid")                                 # noqa
    ge,sys,P,ew=i("os").getenv,i("sys"),i("pathlib").Path,i("sys").stderr.write                               # noqa
    (cache:=(P(ge("XDG_CACHE_HOME",P.home()/".cache"))/"viv"/"venvs")).mkdir(parents=True,exist_ok=True)      # noqa
    ((sha256:=i("hashlib").sha256()).update((s(spec)+                                                         # noqa
     (((exe:=("N/A",s(P(i("sys").executable).resolve()))[e(track_exe)])))).encode()))                         # noqa
    if (env:=cache/(name if name else (_id:=sha256.hexdigest()))) not in cache.glob("*/") or ge("VIV_FORCE"): # noqa
        v=e(ge("VIV_VERBOSE"));ew(f"generating new vivenv -> {env.name}\n")                                   # noqa
        i("venv").EnvBuilder(with_pip=True,clear=True).create(env)                                            # noqa
        with (env/"pip.conf").open("w") as f:f.write("[global]\ndisable-pip-version-check=true")              # noqa
        if (p:=i("subprocess").run([env/"bin"/"pip","install","--force-reinstall",*spec],text=True,           # noqa
            stdout=(-1,None)[v],stderr=(-2,None)[v])).returncode!=0:                                          # noqa
            if env.is_dir():i("shutil").rmtree(env)                                                           # noqa
            ew(f"pip had non zero exit ({p.returncode})\n{p.stdout}\n");sys.exit(p.returncode)                # noqa
        with (env/"viv-info.json").open("w") as f:                                                            # noqa
            i("json").dump({"created":s(i("datetime").datetime.today()),"id":_id,"spec":spec,"exe":exe},f)    # noqa
    sys.path = [p for p in (*sys.path,s(*(env/"lib").glob("py*/si*"))) if p!=i("site").USER_SITE]             # noqa
_viv_use("markdown-it-py==2.2.0", "mdurl==0.1.2", "Pygments==2.14.0", "rich==13.3.2")                         # noqa
# fmt: on
# >>>>> code golfed with <3
```

## Alternatives

### [pip-run](https://github.com/jaraco/pip-run)

```sh
pip-run (10.0.5)
├── autocommand (2.2.2)
├── jaraco-context (4.3.0)
├── jaraco-functools (3.6.0)
│   └── more-itertools (9.1.0)
├── jaraco-text (3.11.1)
│   ├── autocommand (2.2.2)
│   ├── inflect (6.0.2)
│   │   └── pydantic>=1.9.1 (1.10.5)
│   │       └── typing-extensions>=4.2.0 (4.5.0)
│   ├── jaraco-context>=4.1 (4.3.0)
│   ├── jaraco-functools (3.6.0)
│   │   └── more-itertools (9.1.0)
│   └── more-itertools (9.1.0)
├── more-itertools>=8.3 (9.1.0)
├── packaging (23.0)
├── path>=15.1 (16.6.0)
├── pip>=19.3 (23.0.1)
└── platformdirs (3.1.0)
```

### [pipx](https://github.com/pypa/pipx/)

```sh
pipx (1.1.0)
├── argcomplete>=1.9.4 (2.1.1)
├── packaging>=20.0 (23.0)
└── userpath>=1.6.0 (1.8.0)
    └── click (8.1.3)
```
