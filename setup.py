from setuptools import setup, find_packages

setup(
    name="tigeralgorithmexample",
    version="0.0.1",
    author="Mart van Rijthoven",
    author_email="mart.vanrijthoven@gmail.com",
    packages=find_packages(),
    license="LICENSE.txt",
    install_requires=[
        "numpy>=1.23.5,<2.0",
        "tqdm>=4.62.3,<5.0"
    ],
)
