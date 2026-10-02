# Android port notes

The Android port keeps the same architectural split as the iOS app:

```text
Android/Kotlin: UI + auth persistence + WebRTC/media + camera + Meta DAT
Rust/Codex:     authenticated ChatGPT realtime control plane + sideband
```

The first milestone intentionally excludes Meta glasses. This lets the project validate the subscription-backed ChatGPT path on Android before introducing Bluetooth and DAT variables.

## Native bridge

The existing bridge in `native/GlassifAICodexBridge` is already mostly platform-neutral. It exposes a C ABI and does not process camera bytes or own platform audio.

Android packaging will produce an `arm64-v8a` shared library and add a thin JNI boundary. The existing iOS static-library/XCFramework build remains unchanged.

## Authentication

Port the behavior in `ios/GlassifAI/Runtime/ChatGPTAuthSession.swift` rather than inventing a new login protocol:

- device-code request
- browser verification
- polling
- authorization-code exchange
- refresh
- account claim extraction
- model discovery

Tokens must use Android Keystore-backed encrypted storage. No token values should be logged.

## TLS

The pinned Codex HTTP client includes a native-root load with a `webpki_roots` fallback for Rustls WebSocket configuration. This removes the exact empty-native-root failure that affected iOS, but Android still needs an on-device handshake test before the gate is considered passed.

## Media

Android owns WebRTC and audio routing. Start with phone microphone/speaker. Bluetooth HFP and Meta DAT are later gates.

## Vision

Preserve the current on-demand delegation model:

```text
visual question -> sideband handoff -> recent JPEG -> account-backed Responses
                -> short text context -> handoff completion -> spoken answer
```

Do not continuously upload the camera stream.

## Compatibility

The subscription-backed realtime transport remains private/unsupported. Android code should depend on a `ChatGPTTransport`-style abstraction so the current pinned Codex implementation can be swapped for a supported external-app transport if one becomes available.
