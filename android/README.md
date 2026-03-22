# Building ClickHouse for Android (aarch64)

## Prerequisites

1. **System Clang 21+** — ClickHouse requires Clang >= 21.
2. **Android NDK r26d** — download and extract into the `android/` directory:

```bash
cd android
wget https://dl.google.com/android/repository/android-ndk-r26d-linux.zip
unzip android-ndk-r26d-linux.zip
```

3. **Ninja** and **CMake** (4.0+) installed on the host.

## Configure and Build

### Minimal build (no optional libraries)

```bash
cmake -S . -B android/build \
  -DCMAKE_TOOLCHAIN_FILE=$(pwd)/android/toolchain-android-aarch64.cmake \
  -DCMAKE_C_COMPILER=$(which clang) \
  -DCMAKE_CXX_COMPILER=$(which clang++) \
  -DLINKER_NAME=ld.lld \
  -DENABLE_LIBRARIES=0

ninja -C android/build clickhouse
```

### Build with Parquet, S3, and Avro

```bash
cmake -S . -B android/build \
  -DCMAKE_TOOLCHAIN_FILE=$(pwd)/android/toolchain-android-aarch64.cmake \
  -DCMAKE_C_COMPILER=$(which clang) \
  -DCMAKE_CXX_COMPILER=$(which clang++) \
  -DLINKER_NAME=ld.lld \
  -DENABLE_LIBRARIES=0 \
  -DENABLE_PARQUET=1 \
  -DENABLE_AWS_S3=1 \
  -DENABLE_AVRO=1 \
  -DENABLE_PROTOBUF=1 \
  -DENABLE_BROTLI=1 \
  -DENABLE_THRIFT=1 \
  -DENABLE_BZIP2=1 \
  -DENABLE_RAPIDJSON=1 \
  -DENABLE_CURL=1

ninja -C android/build clickhouse
```

### Strip the binary

The unstripped binary is ~3.4 GB (with debug info). Strip it for deployment:

```bash
llvm-strip -s android/build/programs/clickhouse -o android/build/programs/clickhouse-stripped
```

## Running on Android (Termux)

Copy the binary to the device and run it in [Termux](https://termux.dev/).

### SSL certificates

ClickHouse auto-detects CA certificates at:
- `/data/data/com.termux/files/usr/etc/tls/cert.pem` (Termux)
- `/system/etc/security/cacerts` (Android system)

If SSL verification fails, configure it explicitly in the ClickHouse config:

```xml
<openSSL>
    <client>
        <caConfig>/data/data/com.termux/files/usr/etc/tls/cert.pem</caConfig>
    </client>
</openSSL>
```

### DNS resolution

Android's `getaddrinfo` may not work for native binaries in Termux because
the `netd` daemon is not accessible. ClickHouse includes a c-ares based
fallback that resolves DNS directly via UDP queries to `8.8.8.8`.

## Notes

- The build targets **Android API 28** (Android 9.0) on **arm64-v8a**.
- The toolchain uses the host system's Clang compiler with the NDK sysroot
  (the NDK's bundled Clang is too old for ClickHouse).
- Most optional libraries are disabled with `ENABLE_LIBRARIES=0`. Enable
  individual features as shown above.
- The `android/toolchain-android-aarch64.cmake` file contains a hardcoded
  path to the NDK. Update it if you place the NDK elsewhere.
