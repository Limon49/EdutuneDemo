import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/transaction_controller.dart';
import '../models/models.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class CashOutScreen extends StatefulWidget {
  const CashOutScreen({super.key});

  @override
  State<CashOutScreen> createState() => _CashOutScreenState();
}

class _CashOutScreenState extends State<CashOutScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _agentController = TextEditingController();
  int _selectedTab = 0; // 0 = Agent, 1 = ATM

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
    _agentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Cash Out'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildTabSelector(),
          Expanded(
            child: _selectedTab == 0
                ? _buildAgentTab()
                : _buildAtmTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _TabCard(
              icon: Icons.people,
              label: 'Agent',
              isSelected: _selectedTab == 0,
              onTap: () {
                _tabController.animateTo(0);
                setState(() => _selectedTab = 0);
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TabCard(
              icon: Icons.atm,
              label: 'ATM',
              isSelected: _selectedTab == 1,
              onTap: () {
                _tabController.animateTo(1);
                setState(() => _selectedTab = 1);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgentTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _agentController,
                  keyboardType: TextInputType.phone,
                  style: GoogleFonts.poppins(color: AppColors.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Input Agent Number',
                    hintStyle:
                        GoogleFonts.poppins(color: AppColors.textSecondary),
                    border: InputBorder.none,
                    suffixIcon: const Icon(Icons.chevron_right),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.contacts, color: Colors.white, size: 20),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),
          // QR code button
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.qr_code_scanner, color: AppColors.primary),
            label: Text(
              'Tap To Scan QR Code',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildContactSection(
              'Recent Contacts', AppData.recentContacts, isAgent: true),
          const SizedBox(height: 16),
          _buildContactSection(
              'All Contacts', AppData.allContacts, isAgent: true),
        ],
      ),
    );
  }

  Widget _buildAtmTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 15),
              children: [
                TextSpan(
                  text: 'Available Balance: ',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: '13999 TK',
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for Partner Bank',
              hintStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.inputBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: AppData.banks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final bank = AppData.banks[i];
                return _BankCard(bank: bank);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(String title, List<ContactModel> contacts,
      {bool isAgent = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        ...contacts.map(
          (c) => ContactListTile(
            name: c.name,
            number: c.number,
            type: c.type,
            onTap: () {
              Navigator.pushNamed(
                context,
                '/confirm-cashout',
                arguments: {'agent': c.number.replaceAll(' ', '')},
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TabCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppColors.primary,
              size: 36,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.primary,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final BankModel bank;
  const _BankCard({required this.bank});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Branch Name: ${bank.branch}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 65,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.account_balance,
                color: AppColors.primary, size: 36),
          ),
        ],
      ),
    );
  }
}
