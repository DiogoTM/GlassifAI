# GlassifAI Android Port Plan

Goal: port GlassifAI's subscription-backed ChatGPT voice/vision architecture to Android, then integrate Meta Wearables DAT for Ray-Ban Meta glasses without requiring an OpenAI API key or a GlassifAI-hosted backend.

## Gates

1. **Android native bridge build**
   - Build the existing pinned Codex Rust bridge for `arm64-v8a`.
   - Keep the iOS XCFramework path untouched.
   - Confirm TLS/client dependencies compile for Android.

2. **ChatGPT device authentication**
   - Port the existing device-code OAuth flow to Kotlin.
   - Store refresh/access credentials using Android Keystore-backed encrypted storage.
   - Verify token refresh and account/model discovery.

3. **Phone-only realtime voice**
   - Create WebRTC offer/answer flow on Android.
   - Use the Rust bridge for subscription-backed call creation and sideband.
   - Route microphone/speaker through the phone first.
   - Verify interruption and teardown.

4. **Visual handoff on phone camera**
   - Preserve GlassifAI's on-demand vision design rather than continuous image upload.
   - Keep frames memory-only and bounded.
   - Complete realtime client delegations with a fresh camera frame.

5. **Meta Wearables DAT Android**
   - Register/connect the glasses.
   - Stream/capture glasses camera frames.
   - Add glasses as a selectable vision source.

6. **Glasses audio and controls**
   - Prefer Bluetooth HFP microphone/speaker for active calls.
   - Add safe fallback to phone audio.
   - Map available DAT state/input events to mute/end controls.
   - Treat cold-start voice invocation as optional until Meta approval/support is confirmed.

7. **Tool/context expansion**
   - Keep realtime transport behind an interface so the private Codex transport can later be replaced.
   - Investigate MCP/plugin/tool delegation separately from the core glasses runtime.

## Constraints

- No OpenAI API key required for the primary path.
- No GlassifAI-owned backend required for normal operation.
- Keep credentials and camera data out of logs.
- Do not persist camera frames, transcripts, audio, SDP, or call IDs by default.
- Preserve upstream iOS functionality while Android work is experimental.
- Treat ChatGPT subscription-backed realtime as private/unsupported and isolate it behind a transport boundary.

## First milestone

An Android phone can:
1. sign in with ChatGPT using device authorization;
2. create a subscription-backed realtime voice call through the Rust/Codex bridge;
3. speak and hear responses using phone audio;
4. terminate cleanly.

Meta glasses are deliberately not required for this milestone.
