# REmatch-py
Python porting of REmatch


---
## Como funciona el CI/CD

Actualmente los build de las distintas versiones de python están siendo compilados en `Github Actions` tanto para Windows (32-bit y 64-bit), MacOS y Linux. 

El proceso es mediado fundamentalmente por el proyecto [cibuildwheel](https://github.com/joerick/cibuildwheel) ([Documentación](https://cibuildwheel.readthedocs.io/en/stable/)).

Para compilar en cada sistema operativo, existen 2 archivos de comandos que se ejecutarán en las maquinas virtuales: `preset_<so>` y `prebuild_<so>`.

- `Preset`
    - Aqui se declarán las dependencias que debe de tener la VM con la respectiva instalación para el sistema operativo.

- `Prebuild`
    - Este archivo se ejecuta antes de cada compilación de una versión de python y se declaran los `paths` de `Boost`, `Python` y/o cualquier programa necesario. Crea las carpetas donde se compilará la librería y ejecuta su compilación.

El workflow que lee `Github Actions` están declaradas en `.github/workflows/pypi-wheels.yml`, ahí se le indica:
 - Sistemas operativos donde compilar.
 - Correr los archivos `preset` y `prebuild`.
 - Definir las versiones de python donde se compilará la librería dependiendo del sistema operativo y arquitectura de este en el caso de windows. (ej.: `cp39-macosx_x86_64` indica python  3.9 en MacOS. Mas info [aquí](https://cibuildwheel.readthedocs.io/en/latest/options/))
 - Testea que la compilación haya sido exitosa a través de un test que prueba todas las funciones de la librería.
 - **Sube la nueva versión a PYPI en caso de incluir un `tag` que comience por `v` (e.g. `v0.1.2`).**

## TODOs
- Dejar todo lo relacionado a Python del proyecto en este repo (estos son archivos como `setup.py` y directorios como `python/packages`)
