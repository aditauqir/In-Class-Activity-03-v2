# In-Class-Activity-03-v2
# 🎛️ Cyber-Tactile Control Studio (Flutter)

A sleek, interactive 3D Neomorphic control deck built with Flutter & Dart, demonstrating advanced micro-interactions, responsive touch haptics, and state management.

---

## 🌦️ Persona: Weather Command Center

This control studio is personalized as a high-tech **Weather Command Center**, orchestrating atmospheric conditions and meteorological telemetry:

- **☀️ SUN**: Amber Accent (`Colors.amber`) — `Icons.wb_sunny` initiates solar heat radiation and sunny atmospheric conditions.
- **💧 RAIN**: Blue Accent (`Colors.blue`) — `Icons.water_drop` activates cloud seeding and precipitation sequences.
- **💨 WIND**: Teal Accent (`Colors.teal`) — `Icons.air` generates atmospheric circulation and gust currents.
- **⚡ STORM**: Indigo Accent (`Colors.indigo`) — `Icons.thunderstorm` triggers severe thunderstorm and lightning warnings.

---

## ✨ Features

- **3D Mechanical Tactile Buttons**: Built using dual opposing `BoxShadow` physics and `GestureDetector` micro-interactions (`onTapDown`, `onTapUp`, `onTapCancel`).
- **Live State Management**: Real-time tap counts, energy calibration sliders, and status monitors.
- **Milestone 2: Interactive Overload Feedback (>80% Power Threshold)**:
  - Dynamically triggers when the Power Calibration slider crosses 80%.
  - Shifts the entire deck background smoothly over 300ms using `AnimatedContainer` to emergency overload tones (`#3A1712` in Dark Mode, `#FBE6DF` in Light Mode).
  - Displays dynamic warning banners (`⚠️ WARNING: POWER EXCEEDS 80% THRESHOLD`), an overloaded title (`⚠️ SEVERE WEATHER OVERLOAD`), and crimson alert glow.
- **Adaptive Theme System**: Seamless switching between Dark Cyber Mode and Light Neomorphic Mode with calculated opposing specular highlights and drop shadows.
- **Modular Component Design**: Reusable `TactileButton` custom widget architecture with isolated internal touch state.

---

## 🛠️ Tech Stack

- **Framework**: Flutter (Material 3)
- **Language**: Dart
- **Key Widgets**: `StatefulWidget`, `GestureDetector`, `AnimatedContainer`, `Slider`, `Wrap`, `Scaffold`, `BoxShadow`

---

## 🔬 Neomorphic 3D Depth Physics

Neomorphism (Soft UI) creates the illusion of physical extrusion and tactile depression using two opposing light sources:

1. **Unpressed State (Elevated)**:
   - **Dark Drop Shadow (Bottom-Right)**: `Offset(8, 8)` with blur radius `16` — simulates casting a soft shadow on the surface.
   - **Light Highlight (Top-Left)**: `Offset(-8, -8)` with blur radius `16` — simulates specular light hitting the raised edge.
2. **Pressed State (Sunken/Depressed)**:
   - When the user presses the screen (`onTapDown`), shadow offsets collapse to `Offset(2, 2)` and `Offset(-2, -2)` with blur radius `4`.
   - The icon size contracts from `46` to `40`, and the accent color glows, producing the optical illusion of physical mechanical compression.
   - Releasing the finger (`onTapUp` or `onTapCancel`) restores the elevated shadow coordinates within a snappy 100ms spring curve.

---

## 🧠 Critical Thinking & Conceptual Reflections

### 1. `StatelessWidget` vs. `StatefulWidget`
* **Difference**: A `StatelessWidget` is immutable once built; its visual appearance depends entirely on configuration passed down from its parent and cannot change dynamically over time. A `StatefulWidget` pairs with a mutable `State` instance that persists across frames, allowing the widget to store internal data (e.g., `totalTaps`, `powerLevel`, `isPressed`) and trigger UI redraws.
* **Modifying State Outside `setState()`**: If `totalTaps++` is executed outside `setState()`, the variable increments in Dart memory, but the Flutter engine never marks the widget as dirty. Consequently, `build()` is never rescheduled, and the on-screen counter remains unchanged until an external rebuild occurs.

### 2. `GestureDetector` Micro-Interactions vs. Standard `ElevatedButton`
* Standard buttons like `ElevatedButton` only fire an `onPressed` event upon touch release.
* `GestureDetector` captures the complete touch lifecycle:
  - `onTapDown`: The exact moment a finger contacts the screen → instantly triggers `setState(() => isPressed = true)` to animate the physical button depression.
  - `onTapUp`: The moment contact is broken → triggers `setState(() => isPressed = false)` to elevate the button and execute the action callback.
  - `onTapCancel`: Crucial edge-case handler for gesture cancellation. If a user touches down and drags away, `onTapCancel` safely releases the button back to its unpressed state without firing the action.

### 3. State Scope & Rebuild Optimization
* `isPressed` is scoped locally within `_TactileButtonState`, while `totalTaps` and `powerLevel` reside in `_ControlDeckScreenState`.
* **Rationale**: Button depression is a local micro-interaction. If `isPressed` were managed at the screen level, pressing any button would trigger a full-screen rebuild of the entire tree. Isolating `isPressed` inside `TactileButton` ensures that only the touched button redraws, ensuring buttery 60fps animations.

### 4. Overload Threshold System & Dynamic Feedback
* The condition `final bool isOverload = powerLevel > 80;` evaluates directly in `build()`, providing reactive derived state without redundant listeners.
* Pairing this threshold with `AnimatedContainer` smoothly transitions colors over 300ms, giving an immediate, polished warning signal to the user.

---

## 🚀 How to Run

```bash
# 1. Get dependencies
flutter pub get

# 2. Run static analysis (0 errors, 0 warnings)
flutter analyze

# 3. Run widget tests
flutter test

# 4. Run application
flutter run
```
