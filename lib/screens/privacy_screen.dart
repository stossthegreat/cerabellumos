import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

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
          'PRIVACY POLICY',
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
              'Introduction',
              'CerebellumOS ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),
            
            _buildSection(
              '1. Information We Collect',
              'We collect information that you provide directly to us when using the App:\n\n• Study targets and goals you create\n• Notes and project content\n• Progress tracking data\n• App preferences and settings\n\nAll this data is stored locally on your device by default.',
            ),
            
            _buildSection(
              '2. How We Use Your Information',
              'We use the information we collect to:\n\n• Provide, maintain, and improve the App\n• Track your study progress and goals\n• Send you notifications about your study schedule\n• Personalize your experience\n• Analyze app usage to improve features',
            ),
            
            _buildSection(
              '3. Data Storage',
              'Your data is primarily stored locally on your device. We do not automatically upload your data to external servers. Any cloud backup features are optional and clearly indicated in the App.',
            ),
            
            _buildSection(
              '4. Data Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties. Your study data remains private and is not shared with anyone unless you explicitly choose to share it.',
            ),
            
            _buildSection(
              '5. Data Security',
              'We implement appropriate technical and organizational security measures to protect your information. However, no method of transmission over the internet or electronic storage is 100% secure.',
            ),
            
            _buildSection(
              '6. Analytics',
              'We may collect anonymous usage statistics to help us understand how the App is used and improve it. This data is aggregated and does not identify individual users.',
            ),
            
            _buildSection(
              '7. Children\'s Privacy',
              'The App is intended for students of all ages. If you are under 13, please use the App only with parental consent. We do not knowingly collect personal information from children under 13 without parental consent.',
            ),
            
            _buildSection(
              '8. Your Rights',
              'You have the right to:\n\n• Access your data stored in the App\n• Delete your data at any time\n• Export your data\n• Opt-out of notifications\n\nYou can exercise these rights through the App\'s settings.',
            ),
            
            _buildSection(
              '9. Third-Party Services',
              'The App may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties.',
            ),
            
            _buildSection(
              '10. Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the App and updating the "Last Updated" date.',
            ),
            
            _buildSection(
              '11. Contact Us',
              'If you have questions about this Privacy Policy, please contact us through the App\'s feedback feature in Settings.',
            ),
            
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
                color: const Color(0xFF10B981).withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        LucideIcons.shield,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Your Privacy Matters',
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
                    'We take your privacy seriously. Your study data stays on your device and is never shared without your explicit permission.',
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

