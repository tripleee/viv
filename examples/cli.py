#!/usr/bin/env python3
"""
It can be convenient to quickly generate a cli for a short script.
Or to add simple visualization of data using the wonderful rich library.
"""

__import__("viv").activate("typer", "rich-click")  # noqa

import typer

app = typer.Typer()


@app.command()
def hello(name: str):
    print(f"Hello {name}")


@app.command()
def goodbye(name: str, formal: bool = False):
    if formal:
        print(f"Goodbye Ms. {name}. Have a good day.")
    else:
        print(f"Bye {name}!")


if __name__ == "__main__":
    app()
