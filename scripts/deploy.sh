#!/bin/bash
# tree .
echo -e " ... running twine to deploy ... "
pip install --upgrade twine
if [ -n "$IS_OSX" ]; then
  echo -e "upgrading pyOpenSSL ..."
  pip install --upgrade pyOpenSSL
fi
twine upload --skip-existing --username "${PYPI_USERNAME}" --password "${PYPI_PASSWORD}" ${TRAVIS_BUILD_DIR}/wheelhouse/*.whl
exit 0;