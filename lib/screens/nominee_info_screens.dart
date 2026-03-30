import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

// ─── Nominee Update Screen ────────────────────────────────────────────────────
class NomineeUpdateScreen extends StatefulWidget {
  const NomineeUpdateScreen({super.key});

  @override
  State<NomineeUpdateScreen> createState() => _NomineeUpdateScreenState();
}

class _NomineeUpdateScreenState extends State<NomineeUpdateScreen> {
  final _nameController = TextEditingController();
  final _nidController = TextEditingController();
  final _phoneController = TextEditingController();
  final _relationController = TextEditingController();
  bool _hasNominee = true;

  @override
  void dispose() {
    _nameController.dispose();
    _nidController.dispose();
    _phoneController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nominee Update'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasNominee) _buildExistingNominee(),
            const SizedBox(height: 24),
            Text(
              _hasNominee ? 'Update Nominee' : 'Add Nominee',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Nominee Full Name',
              hint: 'Enter full name',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Relationship',
              hint: 'e.g. Mother, Father, Spouse',
              controller: _relationController,
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'NID Number',
              hint: 'Enter NID number',
              controller: _nidController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Phone Number',
              hint: 'Enter phone number',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Save Nominee',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Nominee updated successfully',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const BottomIssueBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildExistingNominee() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.15),
            radius: 24,
            child: const Icon(Icons.person, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Nominee',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Fatema Begum',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'Mother • 019*******2',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Active',
              style: GoogleFonts.poppins(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Information Update Screen ────────────────────────────────────────────────
class InformationUpdateScreen extends StatefulWidget {
  const InformationUpdateScreen({super.key});

  @override
  State<InformationUpdateScreen> createState() =>
      _InformationUpdateScreenState();
}

class _InformationUpdateScreenState
    extends State<InformationUpdateScreen> {
  final _nameController =
      TextEditingController(text: 'Rahul Ahmed');
  final _emailController =
      TextEditingController(text: 'rahul@example.com');
  final _addressController =
      TextEditingController(text: 'Mirpur, Dhaka');
  int _selectedGender = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Information Update'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      'R',
                      style: GoogleFonts.poppins(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            InputField(
              label: 'Full Name',
              hint: 'Enter your full name',
              controller: _nameController,
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Email Address',
              hint: 'Enter email address',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            Text(
              'Gender',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _GenderButton(
                  label: 'Male',
                  icon: Icons.male,
                  isSelected: _selectedGender == 0,
                  onTap: () => setState(() => _selectedGender = 0),
                ),
                const SizedBox(width: 12),
                _GenderButton(
                  label: 'Female',
                  icon: Icons.female,
                  isSelected: _selectedGender == 1,
                  onTap: () => setState(() => _selectedGender = 1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InputField(
              label: 'Address',
              hint: 'Enter your address',
              controller: _addressController,
            ),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Save Changes',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Information updated successfully',
                      style: GoogleFonts.poppins(),
                    ),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const BottomIssueBar(),
          ],
        ),
      ),
    );
  }
}

class _GenderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color:
                      isSelected ? Colors.white : AppColors.textSecondary,
                  size: 20),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
