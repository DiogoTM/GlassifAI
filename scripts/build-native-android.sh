#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BRIDGE="$ROOT/native/GlassifAICodexBridge"
OUT="$ROOT/android/native-libs"

if ! command -v cargo >/dev/null 2>&1; then
  echo "cargo is required" >&2
  exit 1
fi

if ! command -v cargo-ndk >/dev/null 2>&1; then
  echo "cargo-ndk is required. Install with: cargo install cargo-ndk" >&2
  exit 1
fi

if [[ -z "${ANDROID_NDK_HOME:-}" && -z "${ANDROID_NDK_ROOT:-}" ]]; then
  echo "ANDROID_NDK_HOME or ANDROID_NDK_ROOT must point to an Android NDK" >&2
  exit 1
fi

rustup target add aarch64-linux-android
mkdir -p "$OUT"

cargo ndk   --target arm64-v8a   --output-dir "$OUT"   build   --manifest-path "$BRIDGE/Cargo.toml"   --release

echo "Android native output: $OUT"
echo "Note: the bridge crate still needs Android shared-library/JNI packaging before the .so is app-loadable."
