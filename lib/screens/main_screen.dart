import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../tabs/home_tab.dart';
import '../tabs/study_tab.dart';
import '../tabs/canvas_tab.dart';
import '../tabs/teacher_tab.dart';
import '../core/design_tokens.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: Colors.black,
          extendBody: true,
          body: IndexedStack(
            index: appState.activeTab,
            children: const [
              HomeTab(),
              StudyTab(),
              CanvasTab(),
              TeacherTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(context, appState),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, AppState appState) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            DesignTokens.backgroundPrimary,
            DesignTokens.backgroundSecondary.withOpacity(0.95),
            DesignTokens.backgroundTertiary.withOpacity(0.98),
          ],
        ),
        border: Border(
          top: BorderSide(color: DesignTokens.borderAccent.withOpacity(0.3)),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context,
                index: 0,
                icon: Icons.home_rounded,
                label: 'COMMAND',
                isActive: appState.activeTab == 0,
              ),
              _buildNavItem(
                context,
                index: 1,
                icon: Icons.flash_on_rounded,
                label: 'POWER',
                isActive: appState.activeTab == 1,
              ),
              _buildNavItem(
                context,
                index: 2,
                icon: Icons.psychology_rounded,
                label: 'NEURAL',
                isActive: appState.activeTab == 2,
              ),
              _buildNavItem(
                context,
                index: 3,
                icon: Icons.visibility_rounded,
                label: 'INTEL',
                isActive: appState.activeTab == 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required int index,
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () => context.read<AppState>().setActiveTab(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isActive
              ? LinearGradient(
                  colors: [DesignTokens.energyOrange, DesignTokens.powerBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          DesignTokens.energyOrange.withOpacity(0.3),
                          DesignTokens.powerBlue.withOpacity(0.3),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 22,
                color: isActive ? Colors.white : DesignTokens.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: isActive ? Colors.white : DesignTokens.textTertiary,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 40,
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    colors: [DesignTokens.energyOrange, DesignTokens.powerBlue],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: DesignTokens.energyOrange.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

