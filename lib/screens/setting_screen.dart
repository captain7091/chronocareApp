import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chronocare_app/screens/auth/login_screen.dart';
import 'package:chronocare_app/app.dart';
import 'package:provider/provider.dart';
import 'package:chronocare_app/providers/auth_provider.dart' as my_auth;

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime timestamp;
  bool read;
  NotificationItem({required this.title, required this.message, required this.timestamp, this.read = false});
}

class _SettingScreenState extends State<SettingScreen> {
  int selectedIndex = 0;

  // Notification state
  List<NotificationItem> notifications = [
    NotificationItem(title: 'Welcome!', message: 'Thank you for registering.', timestamp: DateTime.now().subtract(const Duration(minutes: 10)), read: false),
    NotificationItem(title: 'Sign In', message: 'You signed in successfully.', timestamp: DateTime.now().subtract(const Duration(minutes: 5)), read: false),
  ];

  String _currentLanguage = 'English';

  int get unreadCount => notifications.where((n) => !n.read).length;

  final List<_SettingItem> items = [
    _SettingItem(icon: Icons.person_outline, title: 'Profile'),
    _SettingItem(icon: Icons.settings_outlined, title: 'Account Setting'),
    _SettingItem(icon: Icons.storage_outlined, title: 'Data Management'),
    _SettingItem(icon: Icons.notifications_none, title: 'Notification'),
    _SettingItem(icon: Icons.color_lens_outlined, title: 'App Theme'),
    // Removed Language Preference
    _SettingItem(icon: Icons.help_outline, title: 'Help and Support'),
    _SettingItem(icon: Icons.info_outline, title: 'App Version Info'),
  ];

  void _onTileTap(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ProfileDetailScreen()),
      );
    } else if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AccountSettingScreen(currentLanguage: _currentLanguage)),
      );
    } else if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DataManagementScreen()),
      );
    } else if (index == 3) {
      setState(() {
        for (var n in notifications) {
          n.read = true;
        }
      });
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => NotificationScreen(notifications: List<NotificationItem>.from(notifications))),
      ).then((_) => setState(() {}));
    } else if (index == 4) {
      ChronoCareApp.of(context)?.toggleTheme();
      _addNotification('Theme Changed', 'You changed the app theme.');
    } else if (index == 5) {
      // Help and Support
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
      );
    } else if (index == 6) {
      // App Version Info
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const AppVersionInfoScreen()),
      );
    }
  }

  void _addNotification(String title, String message) {
    setState(() {
      notifications.insert(0, NotificationItem(title: title, message: message, timestamp: DateTime.now(), read: false));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notification: $title')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<my_auth.AuthProvider>(context);
    final name = authProvider.displayName;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Setting',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, bottom: 8),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF21C17A),
                  child: Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                    style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _SettingTile(
                  icon: item.icon,
                  title: item.title,
                  highlight: selectedIndex == index,
                  onTap: () => _onTileTap(index),
                  badgeCount: index == 3 && unreadCount > 0 ? unreadCount : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Logout', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Logout', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    await FirebaseAuth.instance.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final IconData icon;
  final String title;
  const _SettingItem({required this.icon, required this.title});
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool highlight;
  final int? badgeCount;
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.highlight = false,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: highlight ? const Color(0xFF21C17A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Icon(icon, color: highlight ? Colors.white : Colors.black, size: 24),
                    if (badgeCount != null && badgeCount! > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                          child: Text(
                            badgeCount.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: highlight ? Colors.white : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: highlight ? Colors.white : Colors.grey, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileDetailScreen extends StatelessWidget {
  const ProfileDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<my_auth.AuthProvider>(context);
    final name = authProvider.displayName;
    final email = authProvider.email;
    final uid = authProvider.uid;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: const Color(0xFF21C17A),
                child: name.isNotEmpty
                    ? Text(
                        name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
                      )
                    : const Icon(Icons.person, size: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            _ProfileField(label: 'Name', value: name),
            const SizedBox(height: 16),
            _ProfileField(label: 'Email', value: email.isNotEmpty ? email : 'N/A'),
            const SizedBox(height: 16),
            _ProfileField(label: 'User ID', value: uid),
          ],
        ),
      ),
    );
  }

  // No need for _getCurrentUser now
}

class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  const _ProfileField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ],
    );
  }
}

class AccountSettingScreen extends StatefulWidget {
  final String currentLanguage;
  const AccountSettingScreen({Key? key, required this.currentLanguage}) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  bool _isLoading = false;
  bool _isActive = true;

  Future<void> _logout(BuildContext context) async {
    setState(() { _isLoading = true; });
    await FirebaseAuth.instance.signOut();
    setState(() { _isLoading = false; });
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() { _isLoading = true; });
    try {
      await FirebaseAuth.instance.currentUser?.delete();
      setState(() { _isLoading = false; });
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/signup', (route) => false);
      }
    } catch (e) {
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: \n${e.toString()}')),
      );
    }
  }

  void _openSupport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ContactSupportScreen()),
    );
  }
  void _openPrivacy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()),
    );
  }
  void _openLanguage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AppLanguageScreen(currentLanguage: widget.currentLanguage)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Setting'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.verified_user, color: Color(0xFF21C17A)),
                const SizedBox(width: 12),
                Text(
                  'Account Status: ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: _isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Delete Account'),
              onTap: _isLoading ? null : () => _deleteAccount(context),
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: const Text('App Language'),
              onTap: () => _openLanguage(context),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: const Text('Privacy Policy'),
              onTap: () => _openPrivacy(context),
            ),
            ListTile(
              leading: const Icon(Icons.support_agent),
              title: const Text('Contact Support'),
              onTap: () => _openSupport(context),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: _isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Logout', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _isLoading ? null : () => _logout(context),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Support Team', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 16),
            Text('Email: support@chronocare.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: +1 234 567 890', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Available: 9:00 AM - 6:00 PM (Mon-Fri)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('For urgent queries, please email or call us. We usually respond within 24 hours.', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 16),
              Text('We value your privacy. Your data is securely stored and never shared with third parties without your consent. We use your information only to provide and improve our services. For more details, contact our support team.', style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              Text('1. Data Collection: Only necessary health and account data is collected.\n2. Data Usage: Used for app features and analytics.\n3. Data Security: Protected with industry-standard encryption.\n4. User Rights: You can request data deletion anytime.', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}

class AppLanguageScreen extends StatelessWidget {
  final String currentLanguage;
  const AppLanguageScreen({Key? key, required this.currentLanguage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Language'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Language', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(height: 16),
            Text('Current Language: $currentLanguage', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const Text('Tap the Language Preference option again to toggle language.', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class DataManagementScreen extends StatelessWidget {
  const DataManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Management'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              title: const Text('Export My Data'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Your data has been exported to your email.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: const Text('Clear Local Data'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All local data cleared.')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Download My Data'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Download started.')),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text('Data Usage Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            const Text(
              'Your health and activity data is securely stored and only used to provide app features. You can export or delete your data anytime. For more details, see our Privacy Policy.',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications;
  const NotificationScreen({Key? key, required this.notifications}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: notifications.isEmpty
          ? const Center(child: Text('No notifications yet.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final n = notifications[index];
                return Container(
                  decoration: BoxDecoration(
                    color: n.read ? Colors.white : const Color(0xFFE3F6EF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(n.message, style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(_formatTime(n.timestamp), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help and Support'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Contact Us', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 16),
            Text('Email: support@chronocare.com', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Phone: +1 234 567 890', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Live Chat: Available in-app 9:00 AM - 6:00 PM (Mon-Fri)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('FAQs', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text('Q: How do I reset my password?\nA: Go to login screen and tap "Forgot Password".', style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            Text('Q: How do I export my data?\nA: Go to Data Management and tap "Export My Data".', style: TextStyle(fontSize: 15)),
            SizedBox(height: 8),
            Text('Q: How do I contact support?\nA: Use the email, phone, or live chat above.', style: TextStyle(fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class AppVersionInfoScreen extends StatelessWidget {
  const AppVersionInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Version Info'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('ChronoCare App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 16),
            Text('Version: 1.2.3 (Build 45)', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Release Date: 2024-05-01', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Last Update: 2024-05-10', style: TextStyle(fontSize: 16)),
            SizedBox(height: 24),
            Text('What\'s New', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            SizedBox(height: 8),
            Text('- New tracker charts\n- Improved medication reminders\n- Bug fixes and performance improvements', style: TextStyle(fontSize: 15)),
            SizedBox(height: 24),
            Text('Developed by ChronoCare Team', style: TextStyle(fontSize: 15, color: Colors.black54)),
          ],
        ),
      ),
    );
  }
} 