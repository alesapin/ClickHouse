include_guard(GLOBAL)

set (CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set (CMAKE_SYSTEM_NAME "Android")
set (CMAKE_SYSTEM_VERSION 28)
set (CMAKE_SYSTEM_PROCESSOR "aarch64")
set (CMAKE_ANDROID_ARCH_ABI "arm64-v8a")

set (CMAKE_ANDROID_NDK "/home/alesapin/code/cpp/safeClickHouse/android/android-ndk-r26d")

set (CMAKE_C_COMPILER_TARGET "aarch64-none-linux-android28")
set (CMAKE_CXX_COMPILER_TARGET "aarch64-none-linux-android28")
set (CMAKE_ASM_COMPILER_TARGET "aarch64-none-linux-android28")

set (NDK_SYSROOT "${CMAKE_CURRENT_LIST_DIR}/android-ndk-r26d/toolchains/llvm/prebuilt/linux-x86_64/sysroot")
set (CMAKE_SYSROOT "${NDK_SYSROOT}")

set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIC")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")
set (CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -fPIC")
