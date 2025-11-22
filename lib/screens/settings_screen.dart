import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/glassmorphic_card.dart';
import 'terms_screen.dart';
import 'privacy_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final userData = appState.userData;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF111827),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              GlassmorphicCard(
                padding: const EdgeInsets.all(24),
                gradientColors: [
                  const Color(0xFF8B5CF6).withOpacity(0.2),
                  const Color(0xFF8B5CF6).withOpacity(0.1),
                ],
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF8B5CF6),
                            Color(0xFFA855F7),
                            Color(0xFFEC4899),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF8B5CF6).withOpacity(0.6),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userData['avatar'] as String,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['name'] as String,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Level ${userData['level']} • ${userData['xp']} XP',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        LucideIcons.edit,
                        color: Color(0xFF8B5CF6),
                      ),
                      onPressed: () {
                        // TODO: Edit profile
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Preferences
              const _SectionHeader(title: 'PREFERENCES'),
              const SizedBox(height: 16),
              _SettingsItem(
                icon: LucideIcons.bell,
                title: 'Notifications',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Toggle notifications
                  },
                  activeColor: const Color(0xFF8B5CF6),
                ),
              ),
              _SettingsItem(
                icon: LucideIcons.volume2,
                title: 'Sound Effects',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Toggle sound
                  },
                  activeColor: const Color(0xFF8B5CF6),
                ),
              ),
              _SettingsItem(
                icon: LucideIcons.moon,
                title: 'Dark Mode',
                subtitle: 'Always on',
                trailing: const Icon(
                  LucideIcons.check,
                  color: Color(0xFF8B5CF6),
                ),
              ),
              const SizedBox(height: 32),
              
              // Study Settings
              const _SectionHeader(title: 'STUDY SETTINGS'),
              const SizedBox(height: 16),
              _SettingsItem(
                icon: LucideIcons.target,
                title: 'Default Target Duration',
                subtitle: '30 days',
                onTap: () {
                  // TODO: Change default duration
                },
              ),
              _SettingsItem(
                icon: LucideIcons.clock,
                title: 'Study Reminders',
                subtitle: 'Daily at 9:00 AM',
                onTap: () {
                  // TODO: Set reminders
                },
              ),
              _SettingsItem(
                icon: LucideIcons.trophy,
                title: 'Weekly Goal',
                subtitle: '${userData['weeklyGoal']} hours',
                onTap: () {
                  // TODO: Set weekly goal
                },
              ),
              const SizedBox(height: 32),
              
              // Data & Privacy
              const _SectionHeader(title: 'DATA & PRIVACY'),
              const SizedBox(height: 16),
              _SettingsItem(
                icon: LucideIcons.shield,
                title: 'Privacy Policy',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                  );
                },
              ),
              _SettingsItem(
                icon: LucideIcons.fileText,
                title: 'Terms of Service',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TermsScreen()),
                  );
                },
              ),
              _SettingsItem(
                icon: LucideIcons.download,
                title: 'Export Data',
                onTap: () {
                  // TODO: Export data
                },
              ),
              _SettingsItem(
                icon: LucideIcons.trash2,
                title: 'Clear All Data',
                titleColor: const Color(0xFFDC2626),
                onTap: () {
                  _showClearDataDialog(context);
                },
              ),
              const SizedBox(height: 32),
              
              // About
              const _SectionHeader(title: 'ABOUT'),
              const SizedBox(height: 16),
              _SettingsItem(
                icon: LucideIcons.info,
                title: 'App Version',
                subtitle: '1.0.0',
              ),
              _SettingsItem(
                icon: LucideIcons.star,
                title: 'Rate App',
                onTap: () {
                  // TODO: Open store rating
                },
              ),
              _SettingsItem(
                icon: LucideIcons.share2,
                title: 'Share with Friends',
                onTap: () {
                  // TODO: Share app
                },
              ),
              _SettingsItem(
                icon: LucideIcons.messageSquare,
                title: 'Send Feedback',
                onTap: () {
                  // TODO: Feedback form
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF111827),
        title: const Text(
          'Clear All Data?',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        content: const Text(
          'This will permanently delete all your study targets, projects, and progress. This action cannot be undone.',
          style: TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'CANCEL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Clear all data
              Navigator.of(context).pop();
            },
            child: const Text(
              'DELETE',
              style: TextStyle(
                color: Color(0xFFDC2626),
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: Colors.grey.shade400,
        letterSpacing: 2,
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsItem({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(20),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF8B5CF6),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: titleColor ?? Colors.white,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Icon(
              LucideIcons.chevronRight,
              color: Colors.grey.shade600,
              size: 20,
            ),
        ],
      ),
    );
  }
}

