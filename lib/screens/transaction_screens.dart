import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/transaction_controller.dart';
import '../utils/app_assets.dart';
import '../utils/app_theme.dart';
import '../widgets/common_widgets.dart';

class ConfirmCashOutScreen extends StatefulWidget {
  const ConfirmCashOutScreen({super.key});

  @override
  State<ConfirmCashOutScreen> createState() => _ConfirmCashOutScreenState();
}

class _ConfirmCashOutScreenState extends State<ConfirmCashOutScreen> {
  final _amountController = TextEditingController();
  double _amount = 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {
        _amount = double.tryParse(_amountController.text) ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final agent = args?['agent'] ?? '01730805499';

    return GetX<TransactionController>(
      builder: (controller) {
        if (controller.state is CashOutSuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: 'Cash Out Successful',
                subtitle: 'Withdraw TK ${(controller.state as CashOutSuccess).amount.toStringAsFixed(0)}',
                imagePath: AppAssets.cashOutSuccess,
                onBackToHome: () {
                  controller.add(ResetTransaction());
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false);
                },
              ),
            );
          });
        } else if (controller.state is TransactionError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text((controller.state as TransactionError).message),
                  backgroundColor: AppColors.error),
            );
          });
        }
      final isLoading = controller.state is TransactionLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            scrolledUnderElevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            title: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 16),
                children: [
                  const TextSpan(
                      text: 'Confirm to ',
                      style: TextStyle(color: AppColors.primary,fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: 'Cash Out',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepPrimary)),
                ],
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _buildInfoRow('Agent', agent),
                const Divider(height: 32),
                _buildAmountSection(),
                const Spacer(),
                PrimaryButton(
                  text: 'Confirm',
                  isEnabled: _amount > 0,
                  isLoading: isLoading,
                  onPressed: _amount > 0
                      ? () => controller.add(
                            CashOutRequested(agentNumber: agent, amount: _amount),
                          )
                      : null,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Center(
          child: Text(value,
              style: GoogleFonts.poppins(
                  fontSize: 15, color: AppColors.textSecondary)),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount',
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 16),
        Center(
          child: TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: _amount > 0 ? AppColors.textPrimary : AppColors.textSecondary,
            ),
            decoration: InputDecoration(
              hintText: 'TK: 0',
              hintStyle: GoogleFonts.poppins(
                fontSize: 32,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              border: InputBorder.none,
              prefixText: _amount > 0 ? 'TK: ' : '',
              prefixStyle: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 14),
              children: [
                const TextSpan(
                  text: 'Available Balance: ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const TextSpan(
                  text: '13999 TK',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 32),
      ],
    );
  }
}

//todo send money screen
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _searchController = TextEditingController();

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
        title: const Text('Send Money'),
        elevation: 2,
        scrolledUnderElevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    style: GoogleFonts.poppins(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Enter The Name or Number',
                      hintStyle: GoogleFonts.poppins(
                          color: AppColors.textSecondary),
                      border: InputBorder.none,
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.chevron_right),
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/confirm-sendmoney',
                                  arguments: {
                                    'contact': _searchController.text
                                  },
                                );
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Image.asset(
                  AppAssets.icon3,
                  width: 42,
                  height: 42,
                ),              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildContactSection('Recent Contacts', [
                    {'name': 'Samantha', 'number': '0987 3422 8756'},
                    {'name': 'Rose Hope', 'number': '0987 3422 8756'},
                  ]),
                  const SizedBox(height: 16),
                  _buildContactSection('All Contacts', [
                    {'name': 'Andrea Summer', 'number': '0987 3422 8756'},
                    {'name': 'Karen William', 'number': '0987 3422 8756'},
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(
      String title, List<Map<String, String>> contacts) {
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
            name: c['name']!,
            number: c['number']!,
            type: 'Bank',
            onTap: () => Navigator.pushNamed(
              context,
              '/confirm-sendmoney',
              arguments: {'contact': c['number']},
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Confirm Send Money ───────────────────────────────────────────────────────
class ConfirmSendMoneyScreen extends StatefulWidget {
  const ConfirmSendMoneyScreen({super.key});

  @override
  State<ConfirmSendMoneyScreen> createState() => _ConfirmSendMoneyScreenState();
}

class _ConfirmSendMoneyScreenState extends State<ConfirmSendMoneyScreen> {
  final _amountController = TextEditingController();
  double _amount = 0;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      setState(() {
        _amount = double.tryParse(_amountController.text) ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final contact = args?['contact'] ?? '01730805499';

    return GetX<TransactionController>(
      builder: (controller) {
        if (controller.state is SendMoneySuccess) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => SuccessDialog(
                title: 'Send Money Successful',
                subtitle: 'Send TK ${(controller.state as SendMoneySuccess).amount.toStringAsFixed(0)}',
                imagePath: AppAssets.group41932,
                onBackToHome: () {
                  controller.add(ResetTransaction());
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (r) => false);
                },
              ),
            );
          });
        } else if (controller.state is TransactionError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text((controller.state as TransactionError).message),
                  backgroundColor: AppColors.error),
            );
          });
        }
      final isLoading = controller.state is TransactionLoading;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 2,
            scrolledUnderElevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
            title: RichText(
              text: TextSpan(
                style: GoogleFonts.poppins(fontSize: 16),
                children: [
                  const TextSpan(
                      text: 'Confirm to ',
                      style: TextStyle(
                          color: AppColors.primary,fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: 'Send Money',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: AppColors.deepPrimary)),
                ],
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('Contact Number',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 14),
                Center(
                  child: Text(contact,
                      style: GoogleFonts.poppins(
                          fontSize: 15, color: AppColors.grey)),
                ),
                const Divider(height: 32),
                Text('Amount',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 16),
                Center(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _amount > 0
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tk: 0',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 32,
                        color: AppColors.textSecondary.withOpacity(0.5),
                      ),
                        border: InputBorder.none,
                        prefixText: _amount > 0 ? 'TK: ' : '',
                        prefixStyle: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Available Balance: ',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const TextSpan(
                            text: '13999 TK',
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 32),
                  const Spacer(),
                  PrimaryButton(
                    text: 'Confirm',
                    isEnabled: _amount > 0,
                    isLoading: isLoading,
                    onPressed: _amount > 0
                        ? () => controller.add(
                              SendMoneyRequested(
                                  contactNumber: contact, amount: _amount),
                            )
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
        );
      },
    );
  }

}

