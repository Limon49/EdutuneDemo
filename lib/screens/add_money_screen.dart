import 'package:epay_edutune/utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class AddMoneyScreen extends StatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  State<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends State<AddMoneyScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTab = 0;
  int _selectedSource = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Money'),
        centerTitle: true,
        elevation: 2,
        scrolledUnderElevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _TabCardAdd(
                    assetPath: AppAssets.mdiBankTransferOut,
                    label: 'Bank to Ekpay',
                    isSelected: _selectedTab == 0,
                    onTap: () {
                      _tabController.animateTo(0);
                      setState(() => _selectedTab = 0);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TabCardAdd(
                    assetPath: AppAssets.group41869,
                    label: 'Card to Ekpay',
                    isSelected: _selectedTab == 1,
                    onTap: () {
                      _tabController.animateTo(1);
                      setState(() => _selectedTab = 1);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Select Your Add Money Source',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.primary,
              ),
            ),
            const Divider(height: 24),
            _SourceOption(
              assetPath: AppAssets.group41866,
              label: 'Bank Account',
              isSelected: _selectedSource == 0,
              onTap: () => setState(() => _selectedSource = 0),
            ),
            const SizedBox(height: 12),
            _SourceOption(
              assetPath: AppAssets.group41867,
              label: 'Internet Banking',
              isSelected: _selectedSource == 1,
              onTap: () => setState(() => _selectedSource = 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabCardAdd extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabCardAdd({
    this.icon,
    this.assetPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            if (assetPath != null)
              Image.asset(
                assetPath!,
                width: 32,
                height: 32,
                color: isSelected ? Colors.white : AppColors.primary,
              )
            else if (icon != null)
              Icon(icon!,
                  color: isSelected ? Colors.white : AppColors.primary, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SourceOption({
    this.icon,
    this.assetPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            if (assetPath != null)
              Image.asset(
                assetPath!,
                width: 24,
                height: 24,
                color: AppColors.primary,
              )
            else if (icon != null)
              Icon(icon!, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
