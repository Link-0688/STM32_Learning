set(CMAKE_SYSTEM_NAME               Generic)
set(CMAKE_SYSTEM_PROCESSOR          arm)

set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)

# Find ARM GCC toolchain binaries
set(TOOLCHAIN_PREFIX                arm-none-eabi-)

find_program(ARM_GCC_EXECUTABLE
    NAMES ${TOOLCHAIN_PREFIX}gcc ${TOOLCHAIN_PREFIX}gcc.exe
    DOC "ARM GNU GCC compiler"
)
if(NOT ARM_GCC_EXECUTABLE)
    message(FATAL_ERROR "Cannot find ${TOOLCHAIN_PREFIX}gcc. Check PATH or toolchain installation.")
endif()

get_filename_component(ARM_TOOLCHAIN_DIR "${ARM_GCC_EXECUTABLE}" DIRECTORY)
get_filename_component(ARM_GCC_NAME "${ARM_GCC_EXECUTABLE}" NAME_WE)
string(REGEX REPLACE "gcc$" "" ARM_PREFIX "${ARM_GCC_NAME}")

message(STATUS "ARM toolchain found: ${ARM_TOOLCHAIN_DIR} (prefix: ${ARM_PREFIX})")

set(CMAKE_C_COMPILER    "${ARM_GCC_EXECUTABLE}")
set(CMAKE_CXX_COMPILER  "${ARM_TOOLCHAIN_DIR}/${ARM_PREFIX}g++${CMAKE_EXECUTABLE_SUFFIX}")
set(CMAKE_ASM_COMPILER  "${ARM_GCC_EXECUTABLE}")

# Verify CXX compiler exists
if(NOT EXISTS "${CMAKE_CXX_COMPILER}" AND EXISTS "${ARM_TOOLCHAIN_DIR}/${ARM_PREFIX}g++.exe")
    set(CMAKE_CXX_COMPILER "${ARM_TOOLCHAIN_DIR}/${ARM_PREFIX}g++.exe")
endif()

set(CMAKE_LINKER        "${CMAKE_CXX_COMPILER}")
set(CMAKE_OBJCOPY       "${ARM_TOOLCHAIN_DIR}/${ARM_PREFIX}objcopy${CMAKE_EXECUTABLE_SUFFIX}")
set(CMAKE_SIZE          "${ARM_TOOLCHAIN_DIR}/${ARM_PREFIX}size${CMAKE_EXECUTABLE_SUFFIX}")

set(CMAKE_EXECUTABLE_SUFFIX_ASM     ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_C       ".elf")
set(CMAKE_EXECUTABLE_SUFFIX_CXX     ".elf")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# MCU specific flags
set(TARGET_FLAGS "-mcpu=cortex-m4 -mfpu=fpv4-sp-d16 -mfloat-abi=hard ")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${TARGET_FLAGS}")
set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp -MMD -MP")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -fdata-sections -ffunction-sections")

set(CMAKE_C_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_C_FLAGS_RELEASE "-Os -g0")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g3")
set(CMAKE_CXX_FLAGS_RELEASE "-Os -g0")

set(CMAKE_CXX_FLAGS "${CMAKE_C_FLAGS} -fno-rtti -fno-exceptions -fno-threadsafe-statics")

set(CMAKE_EXE_LINKER_FLAGS "${TARGET_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T \"${CMAKE_SOURCE_DIR}/STM32F407XX_FLASH.ld\"")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${CMAKE_PROJECT_NAME}.map -Wl,--gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage")
set(TOOLCHAIN_LINK_LIBRARIES "m")
