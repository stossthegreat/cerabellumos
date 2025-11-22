import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../tabs/home_tab.dart';
import '../tabs/study_tab.dart';
import '../tabs/canvas_tab.dart';
import '../tabs/teacher_tab.dart';

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
            Colors.black,
            const Color(0xFF1F2937).withOpacity(0.9),
            const Color(0xFF111827).withOpacity(0.95),
          ],
        ),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1)),
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
          borderRadius: BorderRadius.circular(12),
          gradient: isActive
              ? const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                )
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                gradient: isActive
                    ? LinearGradient(
                        colors: [
                          const Color(0xFFDC2626).withOpacity(0.5),
                          const Color(0xFFEC4899).withOpacity(0.5),
                        ],
                      )
                    : null,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isActive ? const Color(0xFFFCA5A5) : const Color(0xFF9CA3AF),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                color: isActive ? const Color(0xFFFCA5A5) : const Color(0xFF6B7280),
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFDC2626), Color(0xFFEC4899)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFDC2626).withOpacity(0.8),
                      blurRadius: 8,
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

