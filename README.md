# openscad-docker-vscode
A configuration for developing OpenSCAD with Docker and VS Code

## Prerequisites

* Docker
* Docker Compose
* VS Code
* A Linux host OS which supports X forwarding

## Usage

If you clone this repository, you should delete the `.git` directory to avoid nested Git repos. Or you can just choose to [download a ZIP](https://github.com/jbinvnt/openscad-docker-vscode/archive/refs/heads/master.zip) instead.

Create a `.env` file in the repository root with the contents:

```
BUILD_TYPE=Debug
DEBUG=+
```

Then create the directory `openscad/build`.

Then place the contents of your fork of [OpenSCAD](https://github.com/openscad/openscad) into the `openscad` directory. You can open the parent-level `openscad-docker-vscode` directory in VS Code and use the "Run and Debug" menu to start building. Any breakpoints you set will be hit once OpenSCAD is built and started up.
