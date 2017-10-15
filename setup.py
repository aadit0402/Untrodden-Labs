from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

setup(
	name = 'TASKFILE',
	ext_modules = [
	Extension('taskFile', ['taskFile.pyx'])
	],
	cmdclass = {'build_ext':build_ext}
)
