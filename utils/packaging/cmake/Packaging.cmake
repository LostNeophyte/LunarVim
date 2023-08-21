# WIX needs an extension for the LICENSE file
configure_file(${CMAKE_SOURCE_DIR}/LICENSE ${CMAKE_BINARY_DIR}/LICENSE.txt)

set(CPACK_VERBATIM_VARIABLES TRUE)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_BINARY_DIR}/LICENSE.txt)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "An IDE layer for Neovim with sane defaults. Completely free and community driven.")

set(CPACK_PACKAGE_VERSION_MAJOR ${LVIM_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${LVIM_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${LVIM_VERSION_PATCH})

if(PACKAGE_FOR_WINDOWS OR WIN32)
  set(CPACK_PACKAGE_FILE_NAME "lvim-win64")
  set(CPACK_GENERATOR ZIP NSIS64)

  set(CPACK_NSIS_MODIFY_PATH ON)
  set(CPACK_NSIS_MUI_ICON ${CMAKE_SOURCE_DIR}/utils/desktop/lvim.ico)
  set(CPACK_NSIS_MUI_UNIICON ${CMAKE_SOURCE_DIR}/utils/desktop/lvim.ico)
elseif(APPLE)
  set(CPACK_PACKAGE_FILE_NAME "lvim-macos")
  set(CPACK_GENERATOR TGZ)
  set(CPACK_PACKAGE_ICON ${CMAKE_SOURCE_DIR}/utils/desktop/lvim.icns)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(CPACK_PACKAGE_FILE_NAME "lvim-linux64")
  set(CPACK_GENERATOR TGZ DEB)
  set(CPACK_DEBIAN_PACKAGE_NAME "Lunarvim") # required
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "lunarvim.org") # required
else()
  set(CPACK_GENERATOR TGZ)
endif()

include(CPack)
