# GlassifAI Android Port Status

Branch: `android-port`

## Current state

- Fork verified: `DiogoTM/GlassifAI`
- Upstream iOS application preserved.
- Architecture/authentication/Codex bridge reviewed.
- Android port judged feasible enough to proceed.

## Findings

### Portable as-is or with small packaging changes
- Device-code OAuth protocol and token refresh logic.
- ChatGPT account/model discovery request shape.
- Rust realtime call creation.
- Authenticated realtime WebSocket sideband.
- Visual delegation event queue and completion path.
- Pinned Codex protocol implementation.

### Platform-specific replacements required
- iOS Keychain -> Android Keystore-backed encrypted storage.
- AVAudioSession/LiveKit iOS integration -> Android WebRTC/audio routing.
- AVFoundation camera -> CameraX for phone mode.
- Meta DAT iOS integration -> Meta DAT Android SDK.
- XCFramework packaging -> Android `.so` / JNI packaging.

### Risk areas
- ChatGPT subscription-backed realtime is private and unsupported; upstream changes may break it.
- Android TLS behavior must be proven on-device despite the vendored WebPKI root fallback.
- Bluetooth HFP behavior varies across Android devices and will need physical-device testing.
- Meta DAT voice invocation remains a later/optional capability.

## Next actions

1. Add Android native build path for the Rust bridge.
2. Create minimal Android app shell.
3. Port ChatGPT device-code login.
4. Prove Rust bridge loads on Android.
5. Prove phone-only realtime voice before adding Meta DAT.

## Hardware timing

The glasses are not required for gates 1-4, so development can proceed before they arrive.
