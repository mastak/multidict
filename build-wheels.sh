#!/bin/bash
PYTHON_VERSIONS="cp34-cp34m cp35-cp35m"

echo "Compile wheels"
for PYTHON in ${PYTHON_VERSIONS}; do
    /opt/python/${PYTHON}/bin/pip install -r /io/requirements-wheel.txt
    /opt/python/${PYTHON}/bin/pip wheel /io/ -w /io/dist/
done

echo "Bundle external shared libraries into the wheels"
for whl in /io/dist/*.whl; do
    auditwheel repair $whl -w /io/dist/
done

echo "Install packages and test"
for PYTHON in ${PYTHON_VERSIONS}; do
    /opt/python/${PYTHON}/bin/pip install multidict --no-index -f file:///io/dist
    rm -rf /io/tests/__pycache__
    /opt/python/${PYTHON}/bin/py.test /io/tests
    rm -rf /io/tests/__pycache__
done
