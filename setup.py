
# Always prefer setuptools over distutils
from setuptools import setup, find_packages, Distribution
from setuptools.command.build_py import build_py
from setuptools.command.install import install
from distutils.file_util import copy_file
import re
import codecs
import os.path
import os
from sysconfig import get_platform

try:
    from setuptools.command.build_ext import build_ext
    from setuptools import setup, Extension, Command, find_packages
except:
    from distutils.command.build_ext import build_ext
    from distutils import setup, Extension, Command, find_packages

root_dir = os.path.abspath(os.path.dirname(__file__))
libraries = []

if(get_platform().startswith('win')):
    libraries.append('ws2_32')

srcs = []

# Add all .cpp files to the sources
for dirpath, dirnames, filenames in os.walk(os.path.join(root_dir, 'REmatch/src')):
    srcs.extend([os.path.join(dirpath, f) for f in filenames if f.endswith('.cpp') ])

# Remove unwanted sources
filter_rgx = re.compile(r".*(main|benchmark)[/\\][\w\-]*\.cpp|.*rematch_wrap.cpp")
srcs = [p for p in srcs if not filter_rgx.fullmatch(p)]

print(*srcs, sep='\n')

# Adds the swig interface file
srcs.append(os.path.join(root_dir, "src/rematch.i"))

# Set include dirs
include_dirs = [os.path.join(root_dir, 'REmatch/src'),
                os.path.join(root_dir, 'REmatch/thirdparty')]

# Check is BOOST_ROOT env variable is set, and include the headers
boost = os.environ.get("BOOST_ROOT")
if boost is not None:
    print("Read BOOST_ROOT env:", boost)
    include_dirs.append(boost)

if(get_platform().startswith('win')):
    compile_std_arg = "/std:c++17"
    compile_opt_arg = "/O2"
else:
    compile_std_arg = "-std=c++17"
    compile_opt_arg = "-O3"

extra_compile_args = [compile_std_arg, compile_opt_arg]

print(extra_compile_args)

rematch_module = Extension('_rematch',
                           sources=srcs,
                           include_dirs=include_dirs,
                           libraries=libraries,
                           extra_compile_args=extra_compile_args,
                           swig_opts=["-c++"]
                           )

# Get the long description from the README file
long_description = codecs.open(os.path.join(root_dir,
                                            'python/packages/pyrematch/README.md'), encoding='utf8').read()


class BinaryDistribution(Distribution):
    def has_ext_modules(self):
        return True
    def is_pure(self):
        return False


class CustomBuildPy(build_py):
    def run(self):
        self.run_command("build_ext")
        # copy_file(os.path.join(root_dir, 'src/interfaces/rematch.py'),
        #           os.path.join(root_dir, 'python/packages/pyrematch'))
        return super().run()

# Bug on setuptools that sets pure python package despite the BinaryDistribution
# overload of has_ext_modules() and is_pure()
# check https://github.com/google/or-tools/issues/616#issuecomment-371480314
class InstallPlatlib(install):
    def finalize_options(self):
        install.finalize_options(self)
        if self.distribution.has_ext_modules():
            self.install_lib = self.install_platlib

setup(
    name='pyrematch',
    version='0.1.4.1',
    description='An information extraction focused regex library that uses '
                'constant-delay algorithms.',
    long_description=long_description,
    long_description_content_type='text/markdown',
    url='https://github.com/REmatchChile/REmatch',
    author='Oscar Cárcamo <oscar.carcamoz@uc.cl>,'
           'Nicolás Van Sint Jan <nicovsj@uc.cl>',
    # ext_modules=[rematch_module],
    classifiers=[
        'Development Status :: 3 - Alpha',
        'License :: OSI Approved :: MIT License',
        'Programming Language :: Python :: 3'
    ],
    keywords='regex, rematch',
    license='MIT',
    packages=find_packages(where='python/packages'),
    package_dir={'': 'python/packages',
                 'pyrematch': 'python/packages/pyrematch'},
    package_data={'pyrematch': ['_rematchpy.*']},
    cmdclass={'build_py': CustomBuildPy, 'install': InstallPlatlib},
    python_requires='>=3.6, <4',
    distclass=BinaryDistribution,
)
