from distutils.core import setup
from distutils.extension import Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext
 
extensions = [
    Extension("recherche", ["recherche.pyx"]),
    Extension("main", ["main.pyx"]),
    Extension("case", ["case.pyx"]),
    Extension("joueur", ["joueur.pyx"]),
    Extension("trie", ["trie.pyx"]),
    Extension("plateau", ["plateau.pyx"]),
    Extension("partie", ["partie.pyx"]),
    Extension("mot", ["mot.pyx"]),
    Extension("lettre", ["lettre.pyx"])  # à renommer selon les besoins
]
 
setup(
    cmdclass = {'build_ext':build_ext},
    ext_modules = cythonize(extensions,compiler_directives={'language_level': 3}),
)
