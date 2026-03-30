import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class MobileRechargeScreen extends StatefulWidget {
  const MobileRechargeScreen({super.key});

  @override
  State<MobileRechargeScreen> createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  final _phoneController = TextEditingController();
  int _selectedOperator = 0;
  int _selectedType = 0; // 0 = Prepaid, 1 = Postpaid
  double _selectedAmount = 0;

  final List<Map<String, dynamic>> _operators = [
    {'name': 'Grameenphone', 'short': 'GP', 'color': Color(0xFF0095D9)},
    {'name': 'Robi', 'short': 'R', 'color': Color(0xFFE4002B)},
    {'name': 'Banglalink', 'short': 'BL', 'color': Color(0xFFF7941D)},
    {'name': 'Teletalk', 'short': 'TT', 'color': Color(0xFF009A44)},
    {'name': 'Airtel', 'short': 'AT', 'color': Color(0xFFE4003A)},
  ];

  final List<double> _quickAmounts = [10, 20, 30, 50, 100, 200, 500, 1000];

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Mobile Recharge'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOperatorSelector(),
            const SizedBox(height: 24),
            _buildTypeSelector(),
            const SizedBox(height: 24),
            Text(
              'Phone Number',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    style:
                        GoogleFonts.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter mobile number',
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
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.contacts,
                      color: Colors.white, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Select Amount',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _quickAmounts.map((amt) {
                final selected = _selectedAmount == amt;
                return GestureDetector(
                  onTap: () => setState(() => _selectedAmount = amt),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Text(
                      '৳$amt',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (v) =>
                  setState(() => _selectedAmount = double.tryParse(v) ?? 0),
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Or enter custom amount',
                hintStyle:
                    GoogleFonts.poppins(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.inputBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixText: '৳ ',
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Recharge Now',
              isEnabled: _selectedAmount > 0,
              onPressed: _selectedAmount > 0
                  ? () => _showSuccess(context)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Operator',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(_operators.length, (i) {
              final op = _operators[i];
              final selected = _selectedOperator == i;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedOperator = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: selected
                          ? (op['color'] as Color).withOpacity(0.15)
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: selected
                            ? op['color'] as Color
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        op['short'] as String,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: op['color'] as Color,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _operators[_selectedOperator]['name'] as String,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Row(
      children: [
        _TypeButton(
          label: 'Prepaid',
          isSelected: _selectedType == 0,
          onTap: () => setState(() => _selectedType = 0),
        ),
        const SizedBox(width: 12),
        _TypeButton(
          label: 'Postpaid',
          isSelected: _selectedType == 1,
          onTap: () => setState(() => _selectedType = 1),
        ),
      ],
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
                'Recharge Successful!',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You have successfully recharged ৳$_selectedAmount',
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

class _TypeButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
