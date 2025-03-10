from setuptools import setup, find_packages
from Cython.Build import cythonize

setup(
    name="csortedintencode",
    version="0.1.0",
    description="Efficient encoding and decoding of sorted lists of integers.",
    long_description=open("README.md").read(),
    long_description_content_type="text/markdown",
    author="David Lorenzana",
    author_email="davlorenzana@gmail.com",
    url="https://github.com/davidlorenzana/csortedintencode",
    packages=find_packages(),
    install_requires=[
    ],
    python_requires=">=3.7",
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Topic :: Software Development :: Libraries :: Python Modules",
        "Topic :: System :: Archiving :: Compression",
        "Intended Audience :: Developers",
        "Operating System :: OS Independent",
    ],
    license="MIT",
    ext_modules = cythonize("csortedintencode/delta_varint_sortedint.pyx")
)
