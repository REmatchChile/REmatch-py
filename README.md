# REmatch-py
![PyPI](https://img.shields.io/pypi/v/pyrematch?color=blue) ![GitHub Workflow Status](https://img.shields.io/github/workflow/status/REmatchChile/REmatch-py/pypi-wheels?logo=github)

REmatch's Python 3 porting.

## Local wheel creation

When first cloning the repo, `cd` into it and initialize the [REmatch](https://github.com/REmatchChile/REmatch) submodule:
```
git submodule update --init --recursive
```
To build the wheel:
```
cmake -B build
cmake --build build --config Release
python setup.py bdist_wheel
```
The wheel will be at `dist/pyrematch-*.whl`. You can then use a virtual
environment with python's [`venv`](https://docs.python.org/3/library/venv.html)
to install the wheel using `pip`.
```
python -m venv env-test
source env-test/bin/activate
pip install dist/*.whl

# After testing out
deactivate
```


## Como funciona el CI/CD

Actualmente los build de las distintas versiones de python están siendo compilados con (GitHub Actions)[https://docs.github.com/en/actions] en cada nuevo `push` tanto para Windows (32-bit y 64-bit), MacOS y Linux.

El proceso es mediado fundamentalmente por el proyecto [cibuildwheel](https://github.com/joerick/cibuildwheel) ([Documentación](https://cibuildwheel.readthedocs.io/en/stable/)).

Para compilar en cada sistema operativo, existen 2 archivos de comandos que se ejecutarán en las maquinas virtuales: `preset_<so>` y `prebuild_<so>`.

- `Preset`
    - Aqui se declarán las dependencias que debe de tener la VM con la respectiva instalación para el sistema operativo.

- `Prebuild`
    - Este archivo se ejecuta antes de cada compilación de una versión de python y se declaran los `paths` de `Boost`, `Python` y/o cualquier programa necesario. Crea las carpetas donde se compilará la librería y ejecuta su compilación.

El workflow que lee Github Actions está declarado en `.github/workflows/pypi-wheels.yml`, ahí se le indica:
 - Sistemas operativos donde compilar.
 - Correr los archivos `preset` y `prebuild`.
 - Definir las versiones de python donde se compilará la librería dependiendo del sistema operativo y arquitectura de este en el caso de windows. (ej.: `cp39-macosx_x86_64` indica python  3.9 en MacOS. Mas info [aquí](https://cibuildwheel.readthedocs.io/en/latest/options/))
 - Testea que la compilación haya sido exitosa a través de un test que prueba todas las funciones de la librería.
 - **Sube la nueva versión a PYPI en caso de incluir un `tag` que comience por `v` (e.g. `v0.1.2`).**

## TODOs
- Solucionar el repair de la versión de windows. Probablemente usar [`delvewheel`](https://github.com/adang1345/delvewheel).

## Maintainers
- Nicolás Van Sint Jan [@nicovsj](https://github.com/nicovsj)
- Oscar Cárcamo [@oscars810](https://github.com/oscars810)