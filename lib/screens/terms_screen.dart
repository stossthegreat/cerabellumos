import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'TERMS OF SERVICE',
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last Updated: November 22, 2024',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(
              '1. Acceptance of Terms',
              'By downloading, installing, or using CerebellumOS (the "App"), you agree to be bound by these Terms of Service. If you do not agree to these terms, do not use the App.',
            ),
            
            _buildSection(
              '2. Use of the App',
              'CerebellumOS is designed to help you organize and track your study progress. You agree to use the App only for lawful purposes and in accordance with these Terms.',
            ),
            
            _buildSection(
              '3. User Accounts',
              'You are responsible for maintaining the confidentiality of your account and for all activities that occur under your account. You agree to notify us immediately of any unauthorized use of your account.',
            ),
            
            _buildSection(
              '4. User Content',
              'You retain ownership of any content you create using the App, including study targets, notes, and projects. By using the App, you grant us a license to store and process this content to provide you with the App\'s services.',
            ),
            
            _buildSection(
              '5. Intellectual Property',
              'The App and its original content, features, and functionality are owned by CerebellumOS and are protected by international copyright, trademark, patent, trade secret, and other intellectual property laws.',
            ),
            
            _buildSection(
              '6. Prohibited Uses',
              'You may not:\n• Use the App for any illegal purpose\n• Attempt to gain unauthorized access to any part of the App\n• Interfere with or disrupt the App\'s servers or networks\n• Reverse engineer or decompile the App',
            ),
            
            _buildSection(
              '7. Disclaimer of Warranties',
              'The App is provided "as is" without warranties of any kind, whether express or implied. We do not guarantee that the App will be error-free or uninterrupted.',
            ),
            
            _buildSection(
              '8. Limitation of Liability',
              'In no event shall CerebellumOS be liable for any indirect, incidental, special, consequential, or punitive damages resulting from your use or inability to use the App.',
            ),
            
            _buildSection(
              '9. Changes to Terms',
              'We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms in the App. Your continued use of the App after such modifications constitutes your acceptance of the new Terms.',
            ),
            
            _buildSection(
              '10. Termination',
              'We may terminate or suspend your access to the App immediately, without prior notice, for any reason, including if you breach these Terms.',
            ),
            
            _buildSection(
              '11. Governing Law',
              'These Terms shall be governed by and construed in accordance with the laws of your jurisdiction, without regard to its conflict of law provisions.',
            ),
            
            _buildSection(
              '12. Contact Us',
              'If you have any questions about these Terms, please contact us through the App\'s feedback feature.',
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                ),
                color: const Color(0xFF8B5CF6).withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.info,
                        color: Color(0xFF8B5CF6),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Need Help?',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'If you have questions about these terms, please contact us through the app settings.',
                    style: TextStyle(
                      color: Colors.grey.shade300,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade300,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

