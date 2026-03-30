import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../utils/app_theme.dart';

// ─── Settings Screen ──────────────────────────────────────────────────────────
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometric = true;
  bool _notifications = true;
  bool _smsAlerts = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          _buildSection('Security', [
            _SettingsTile(
              icon: Icons.fingerprint,
              label: 'Biometric Login',
              subtitle: 'Use fingerprint or face ID',
              trailing: Switch(
                value: _biometric,
                onChanged: (v) => setState(() => _biometric = v),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.lock_outline,
              label: 'Change PIN',
              subtitle: 'Update your security PIN',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.security,
              label: 'Two-Factor Authentication',
              subtitle: 'Extra layer of security',
              onTap: () {},
            ),
          ]),
          _buildSection('Notifications', [
            _SettingsTile(
              icon: Icons.notifications_outlined,
              label: 'Push Notifications',
              subtitle: 'Receive app notifications',
              trailing: Switch(
                value: _notifications,
                onChanged: (v) => setState(() => _notifications = v),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.sms_outlined,
              label: 'SMS Alerts',
              subtitle: 'Receive SMS for transactions',
              trailing: Switch(
                value: _smsAlerts,
                onChanged: (v) => setState(() => _smsAlerts = v),
                activeColor: AppColors.primary,
              ),
            ),
          ]),
          _buildSection('Appearance', [
            _SettingsTile(
              icon: Icons.dark_mode_outlined,
              label: 'Dark Mode',
              subtitle: 'Switch to dark theme',
              trailing: Switch(
                value: _darkMode,
                onChanged: (v) => setState(() => _darkMode = v),
                activeColor: AppColors.primary,
              ),
            ),
            _SettingsTile(
              icon: Icons.language,
              label: 'Language',
              subtitle: 'English',
              onTap: () {},
            ),
          ]),
          _buildSection('Account', [
            _SettingsTile(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy Policy',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.description_outlined,
              label: 'Terms & Conditions',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.info_outline,
              label: 'About ePay',
              subtitle: 'Version 1.0.0',
              onTap: () {},
            ),
            _SettingsTile(
              icon: Icons.logout,
              label: 'Logout',
              iconColor: AppColors.error,
              labelColor: AppColors.error,
              onTap: () {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
          ]),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.8,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              return Column(
                children: [
                  e.value,
                  if (!isLast)
                    const Divider(
                        height: 1,
                        indent: 56,
                        color: AppColors.divider),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? labelColor;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: labelColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: GoogleFonts.poppins(
                  fontSize: 12, color: AppColors.textSecondary),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.chevron_right,
                  color: AppColors.textSecondary, size: 18)
              : null),
    );
  }
}

// ─── Points Screen ────────────────────────────────────────────────────────────
class PointsScreen extends StatelessWidget {
  const PointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Points'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPointsHeader(),
            const SizedBox(height: 24),
            _buildRewardsGrid(),
            const SizedBox(height: 24),
            _buildPointsHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildPointsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5A623), Color(0xFFE8901A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, color: Colors.white, size: 48),
          const SizedBox(height: 12),
          Text(
            '1,972',
            style: GoogleFonts.poppins(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Total Points',
            style: GoogleFonts.poppins(
                fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PointStat(label: 'Earned', value: '2,540'),
              Container(width: 1, height: 40, color: Colors.white30),
              _PointStat(label: 'Redeemed', value: '568'),
              Container(width: 1, height: 40, color: Colors.white30),
              _PointStat(label: 'Expiring', value: '120'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsGrid() {
    final rewards = [
      {'icon': Icons.phone_android, 'label': 'Free Recharge', 'points': '500'},
      {'icon': Icons.discount, 'label': 'Cashback 5%', 'points': '300'},
      {'icon': Icons.card_giftcard, 'label': 'Gift Card', 'points': '1000'},
      {'icon': Icons.local_offer, 'label': 'Bill Discount', 'points': '200'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Redeem Points',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: rewards.length,
            itemBuilder: (_, i) {
              final r = rewards[i];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(r['icon'] as IconData,
                          color: AppColors.primary, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(r['label'] as String,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          Text('${r['points']} pts',
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPointsHistory() {
    final history = [
      {'label': 'Cash Out Transaction', 'pts': '+50', 'date': 'Today'},
      {'label': 'Send Money', 'pts': '+20', 'date': 'Yesterday'},
      {'label': 'Bill Payment', 'pts': '+30', 'date': 'Mar 27'},
      {'label': 'Redeemed: Recharge', 'pts': '-500', 'date': 'Mar 25'},
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Points History',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...history.map((h) {
            final isPositive = (h['pts'] as String).startsWith('+');
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isPositive
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPositive ? Icons.add : Icons.remove,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ),
              title: Text(h['label'] as String,
                  style: GoogleFonts.poppins(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: Text(h['date'] as String,
                  style: GoogleFonts.poppins(
                      fontSize: 11, color: AppColors.textSecondary)),
              trailing: Text(
                '${h['pts']} pts',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isPositive ? AppColors.success : AppColors.error,
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _PointStat extends StatelessWidget {
  final String label;
  final String value;
  const _PointStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white)),
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 11, color: Colors.white70)),
      ],
    );
  }
}

// ─── Limits Screen ────────────────────────────────────────────────────────────
class LimitsScreen extends StatelessWidget {
  const LimitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final limits = [
      {
        'label': 'Daily Cash Out',
        'used': 5000.0,
        'max': 25000.0,
        'color': AppColors.error,
      },
      {
        'label': 'Daily Send Money',
        'used': 1000.0,
        'max': 50000.0,
        'color': AppColors.primary,
      },
      {
        'label': 'Daily Add Money',
        'used': 0.0,
        'max': 100000.0,
        'color': AppColors.success,
      },
      {
        'label': 'Monthly Transaction',
        'used': 25000.0,
        'max': 300000.0,
        'color': AppColors.accent,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Transaction Limits'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Limits reset every day at midnight. Monthly limits reset on the 1st.',
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: limits.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, i) =>
                    _LimitCard(data: limits[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _LimitCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final used = data['used'] as double;
    final max = data['max'] as double;
    final progress = used / max;
    final color = data['color'] as Color;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data['label'] as String,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '৳${used.toStringAsFixed(0)} / ৳${max.toStringAsFixed(0)}',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.12),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Remaining: ৳${(max - used).toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.success,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ─── Coupons Screen ───────────────────────────────────────────────────────────
class CouponsScreen extends StatelessWidget {
  const CouponsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coupons = [
      {
        'code': 'EPAY50',
        'title': '50% Off on Bill Payment',
        'desc': 'Get 50% cashback on your next electricity bill payment',
        'expiry': 'Expires Apr 15, 2026',
        'color': Color(0xFFE5F0FF),
        'accent': AppColors.primary,
        'used': false,
      },
      {
        'code': 'SEND10',
        'title': '৳10 Cashback on Send Money',
        'desc': 'Send money and get ৳10 back in your wallet',
        'expiry': 'Expires Apr 30, 2026',
        'color': Color(0xFFE5FFF0),
        'accent': AppColors.success,
        'used': false,
      },
      {
        'code': 'RECHARGE5',
        'title': '5% Off on Recharge',
        'desc': 'Recharge any amount and save 5%',
        'expiry': 'Expires Mar 31, 2026',
        'color': Color(0xFFFFF9E5),
        'accent': AppColors.accent,
        'used': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Coupons'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: coupons.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, i) => _CouponCard(data: coupons[i]),
        ),
      ),
    );
  }
}

class _CouponCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _CouponCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final isUsed = data['used'] as bool;
    final accent = data['accent'] as Color;

    return Opacity(
      opacity: isUsed ? 0.5 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: data['color'] as Color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.25)),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            data['code'] as String,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['title'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data['desc'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined,
                                size: 13,
                                color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              data['expiry'] as String,
                              style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isUsed)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        elevation: 0,
                      ),
                      child: Text(
                        'Use',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (isUsed)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'USED',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
