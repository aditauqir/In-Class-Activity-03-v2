import 'package:flutter/material.dart';

// ============================================================================
// 1. MAIN ENTRY POINT
// ============================================================================
// Starts the Weather Command Center with the app-wide theme controller.
void main() {
  runApp(const TactileDeckApp());
}

// ============================================================================
// 2. ROOT APPLICATION WIDGET (Manages Global Theme State)
// ============================================================================
// Owns the light/dark theme state and passes the toggle action to the dashboard.
class TactileDeckApp extends StatefulWidget {
  const TactileDeckApp({super.key});

  @override
  State<TactileDeckApp> createState() => _TactileDeckAppState();
}

class _TactileDeckAppState extends State<TactileDeckApp> {
  // Current app-wide theme; the AppBar button flips this value.
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber-Tactile Control Studio',
      debugShowCheckedModeBanner: false,
      // MaterialApp selects the Material 3 theme from the current mode.
      theme: isDarkMode
          ? ThemeData.dark(useMaterial3: true)
          : ThemeData.light(useMaterial3: true),
      home: ControlDeckScreen(
        isDark: isDarkMode,
        // Rebuilds the app and dashboard after the theme changes.
        onToggleTheme: () => setState(() => isDarkMode = !isDarkMode),
      ),
    );
  }
}

// ============================================================================
// 3. MAIN DASHBOARD SCREEN (Stateful Controller)
// ============================================================================
// Owns dashboard-level weather telemetry and renders the control-deck screen.
class ControlDeckScreen extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  const ControlDeckScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  State<ControlDeckScreen> createState() => _ControlDeckScreenState();
}

class _ControlDeckScreenState extends State<ControlDeckScreen> {
  // Dashboard values shared by the weather metrics, status banner, and slider.
  int totalTaps = 0; // Number of completed weather-command taps.
  double powerLevel = 65.0; // Current calibration value shown by the slider.
  String systemStatus = "READY"; // Latest weather command reported to the user.

  // Records the selected weather command and refreshes the dashboard status.
  void _triggerAction(String actionName) {
    setState(() {
      totalTaps++;
      systemStatus = "$actionName ACTIVATED";
    });
  }

  @override
  Widget build(BuildContext context) {
    // Power above 80% switches the dashboard into severe-weather mode.
    final bool isOverload = powerLevel > 80;

    // Background colors reflect both the selected theme and overload state.
    final screenBg = isOverload
        ? (widget.isDark ? const Color(0xFF3A1712) : const Color(0xFFFBE6DF))
        : (widget.isDark ? const Color(0xFF1E1F29) : const Color(0xFFE0E5EC));
    final cardBg = widget.isDark
        ? (isOverload ? const Color(0xFF451E19) : const Color(0xFF282A36))
        : Colors.white;
    final primaryAccent = isOverload ? Colors.redAccent : Colors.blueAccent;

    return Scaffold(
      backgroundColor: screenBg,
      appBar: AppBar(
        title: Text(
          isOverload ? "⚠️ SEVERE WEATHER OVERLOAD" : "WEATHER COMMAND CENTER",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
            color: isOverload ? Colors.redAccent : null,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Switches between the dark cyber theme and light theme.
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: screenBg,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Shows the total command count and current energy level.
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  border: isOverload
                      ? Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.6),
                          width: 1.5,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: isOverload
                          ? Colors.red.withValues(
                              alpha: widget.isDark ? 0.4 : 0.2,
                            )
                          : Colors.black.withValues(
                              alpha: widget.isDark ? 0.3 : 0.08,
                            ),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Total completed weather-command taps.
                    Column(
                      children: [
                        const Text(
                          "TOTAL TAPS",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "$totalTaps",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    // Separates the tap count from the energy metric.
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey.withValues(alpha: 0.3),
                    ),
                    // Displays the slider value and overload accent color.
                    Column(
                      children: [
                        Text(
                          isOverload ? "CRITICAL POWER" : "ENERGY LEVEL",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isOverload ? Colors.redAccent : Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${powerLevel.toInt()}%",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: primaryAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Reports the latest command or the 80% overload warning.
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isOverload
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  border: isOverload
                      ? Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.4),
                        )
                      : null,
                ),
                child: Text(
                  isOverload
                      ? "⚠️ WARNING: POWER EXCEEDS 80% THRESHOLD"
                      : "STATUS: $systemStatus",
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: isOverload
                        ? Colors.redAccent
                        : (widget.isDark
                              ? Colors.tealAccent
                              : Colors.teal.shade700),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Four weather commands share the reusable TactileButton widget.
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  TactileButton(
                    icon: Icons.wb_sunny,
                    label: "SUN",
                    accentColor: Colors.amber,
                    isDark: widget.isDark,
                    onPressed: () => _triggerAction("SUNNY CONDITIONS"),
                  ),
                  TactileButton(
                    icon: Icons.water_drop,
                    label: "RAIN",
                    accentColor: Colors.blue,
                    isDark: widget.isDark,
                    onPressed: () => _triggerAction("PRECIPITATION SEQUENCE"),
                  ),
                  TactileButton(
                    icon: Icons.air,
                    label: "WIND",
                    accentColor: Colors.teal,
                    isDark: widget.isDark,
                    onPressed: () => _triggerAction("WIND CURRENTS"),
                  ),
                  TactileButton(
                    icon: Icons.thunderstorm,
                    label: "STORM",
                    accentColor: Colors.indigo,
                    isDark: widget.isDark,
                    onPressed: () => _triggerAction("THUNDERSTORM WARNING"),
                  ),
                ],
              ),
              const SizedBox(height: 36),

              // Changes powerLevel continuously while the slider is dragged.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Power Calibration: ${powerLevel.toInt()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isOverload ? Colors.redAccent : null,
                    ),
                  ),
                  if (isOverload) ...[
                    const SizedBox(width: 8),
                    const Text(
                      "(OVERLOAD)",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.redAccent,
                      ),
                    ),
                  ],
                ],
              ),
              Slider(
                value: powerLevel,
                min: 0,
                max: 100,
                activeColor: primaryAccent,
                inactiveColor: Colors.grey.withValues(alpha: 0.3),
                // Rebuilds the overload styling as soon as the value crosses 80%.
                onChanged: (newVal) => setState(() => powerLevel = newVal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// 4. REUSABLE TACTILE 3D BUTTON WIDGET
// ============================================================================
// Reusable weather command button with isolated press feedback and soft depth.
class TactileButton extends StatefulWidget {
  final IconData icon; // Weather symbol shown above the command label.
  final String label; // Short command name shown below the icon.
  final Color accentColor; // Color used while this command is pressed.
  final bool isDark; // Selects dark or light button surface colors.
  final VoidCallback onPressed; // Reports a completed command to the dashboard.

  const TactileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.isDark,
    required this.onPressed,
  });

  @override
  State<TactileButton> createState() => _TactileButtonState();
}

class _TactileButtonState extends State<TactileButton> {
  // Press feedback belongs to this button, not to the parent dashboard.
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    // Derive the button surface and shadow palette from the active theme.
    final baseColor = widget.isDark
        ? const Color(0xFF222430)
        : const Color(0xFFE0E5EC);
    final darkShadow = widget.isDark ? Colors.black87 : const Color(0xFFA3B1C6);
    final lightShadow = widget.isDark ? const Color(0xFF2F3244) : Colors.white;

    return GestureDetector(
      // Contact starts: animate only this button into its pressed state.
      onTapDown: (_) {
        setState(() => isPressed = true);
      },
      // Release: restore this button, then report the completed command.
      onTapUp: (_) {
        setState(() => isPressed = false);
        widget.onPressed();
      },
      // Drag or competing gesture: release visually without firing the command.
      onTapCancel: () {
        setState(() => isPressed = false);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 100,
        ), // Quick 100 ms transition for press and release feedback.
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          // Opposing shadows simulate a raised surface and a pressed surface.
          boxShadow: isPressed
              ? [
                  // Smaller offsets make the button look pushed into the deck.
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.5),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.5),
                    offset: const Offset(-2, -2),
                    blurRadius: 4,
                  ),
                ]
              : [
                  // Wider offsets make the button look raised from the deck.
                  BoxShadow(
                    color: darkShadow.withValues(alpha: 0.7),
                    offset: const Offset(8, 8),
                    blurRadius: 16,
                  ),
                  BoxShadow(
                    color: lightShadow.withValues(alpha: 0.9),
                    offset: const Offset(-8, -8),
                    blurRadius: 16,
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // The weather icon shrinks and adopts its accent color on press.
            Icon(
              widget.icon,
              size: isPressed ? 40 : 46,
              color: isPressed
                  ? widget.accentColor
                  : (widget.isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 8),
            // The command label uses the same pressed-state accent color.
            Text(
              widget.label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 1.1,
                color: isPressed
                    ? widget.accentColor
                    : (widget.isDark ? Colors.white54 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
