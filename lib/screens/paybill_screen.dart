import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class PayBillScreen extends StatefulWidget {
  const PayBillScreen({super.key});

  @override
  State<PayBillScreen> createState() => _PayBillScreenState();
}

class _PayBillScreenState extends State<PayBillScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.lightbulb_outline, 'label': 'Electricity', 'color': Color(0xFFFFF3CD)},
    {'icon': Icons.local_fire_department_outlined, 'label': 'Gas', 'color': Color(0xFFFFE5E5)},
    {'icon': Icons.water_drop_outlined, 'label': 'Water', 'color': Color(0xFFE5F0FF)},
    {'icon': Icons.wifi, 'label': 'Internet', 'color': Color(0xFFE5F8F0)},
    {'icon': Icons.phone, 'label': 'Telephone', 'color': Color(0xFFF0E5FF)},
    {'icon': Icons.credit_card, 'label': 'Credit Card', 'color': Color(0xFFFFEBE5)},
    {'icon': Icons.account_balance, 'label': 'Govt. Fees', 'color': Color(0xFFE5F3FF)},
    {'icon': Icons.tv, 'label': 'Cable Network', 'color': Color(0xFFFFF0E5)},
    {'icon': Icons.school, 'label': 'Education', 'color': Color(0xFFE5FFF0)},
    {'icon': Icons.local_hospital, 'label': 'Hospital', 'color': Color(0xFFFFE5E5)},
    {'icon': Icons.directions_bus, 'label': 'Transport', 'color': Color(0xFFEEE5FF)},
    {'icon': Icons.home, 'label': 'House Rent', 'color': Color(0xFFF5F0E5)},
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_searchQuery.isEmpty) return _categories;
    return _categories
        .where((c) => (c['label'] as String)
            .toLowerCase()
            .contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Pay Bill'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Search
            TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search bill category',
                hintStyle:
                    GoogleFonts.poppins(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search,
                    color: AppColors.textSecondary),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.9,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _filtered.length,
                itemBuilder: (context, i) {
                  final cat = _filtered[i];
                  return _BillCategoryCard(
                    icon: cat['icon'] as IconData,
                    label: cat['label'] as String,
                    bgColor: cat['color'] as Color,
                    onTap: () => Navigator.pushNamed(
                      context,
                      '/bill-payment',
                      arguments: {'category': cat['label']},
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillCategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final VoidCallback onTap;

  const _BillCategoryCard({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.primary, size: 34),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bill Payment Detail Screen ───────────────────────────────────────────────
class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isFetched = false;

  @override
  void dispose() {
    _accountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final category = args?['category'] ?? 'Electricity';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(category),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProviderSelector(category),
            const SizedBox(height: 20),
            Text(
              'Account / Meter Number',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _accountController,
                    keyboardType: TextInputType.number,
                    style:
                        GoogleFonts.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter account number',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.inputBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _isFetched = true),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.search,
                        color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            if (_isFetched) ...[
              const SizedBox(height: 20),
              _buildBillDetails(),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isFetched ? () => _showSuccess(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.confirmDisabled,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32),
                  ),
                ),
                child: Text(
                  'Pay Bill',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderSelector(String category) {
    final providers = {
      'Electricity': ['DESCO', 'DPDC', 'BPDB', 'REB'],
      'Gas': ['Titas Gas', 'Bakhrabad', 'Jalalabad'],
      'Water': ['DWASA', 'CDA'],
      'Internet': ['Grameenphone', 'Robi', 'Banglalink', 'Teletalk'],
    };

    final list = providers[category] ?? [category];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Provider',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: list.map((p) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(p,
                      style: GoogleFonts.poppins(fontSize: 13)),
                  selected: false,
                  onSelected: (_) {},
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBillDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _DetailRow(label: 'Customer Name', value: 'Rahul Ahmed'),
          const Divider(height: 20),
          _DetailRow(label: 'Account Number', value: _accountController.text.isEmpty ? '1234567890' : _accountController.text),
          const Divider(height: 20),
          _DetailRow(label: 'Bill Month', value: 'March 2026'),
          const Divider(height: 20),
          _DetailRow(
            label: 'Bill Amount',
            value: '৳ 1,450',
            valueColor: AppColors.primary,
            bold: true,
          ),
        ],
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 3),
                ),
                child: const Icon(Icons.check_rounded,
                    color: AppColors.accent, size: 48),
              ),
              const SizedBox(height: 20),
              Text(
                'Bill Paid Successfully!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have successfully paid ৳ 1,450',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28)),
                  ),
                  child: Text('Back To Home',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool bold;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 13, color: AppColors.textSecondary)),
        Text(value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? AppColors.textPrimary,
            )),
      ],
    );
  }
}
