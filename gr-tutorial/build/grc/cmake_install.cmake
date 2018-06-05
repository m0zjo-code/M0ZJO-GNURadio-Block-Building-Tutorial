# Install script for directory: /media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/grc

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Release")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gnuradio/grc/blocks" TYPE FILE FILES
    "/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/grc/tutorial_amp_py_cc.xml"
    "/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/grc/tutorial_amp_vector_cc.xml"
    "/media/jonathan/ea2eea90-b89c-4e24-b854-05970b317ba4/M0ZJO-GNURadio-Block-Building-Tutorial/gr-tutorial/grc/tutorial_fft_calc.xml"
    )
endif()

