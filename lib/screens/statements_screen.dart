import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_theme.dart';

class StatementsScreen extends StatefulWidget {
  const StatementsScreen({super.key});

  @override
  State<StatementsScreen> createState() => _StatementsScreenState();
}

class _StatementsScreenState extends State<StatementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Credit', 'Debit'];

  final List<Map<String, dynamic>> _transactions = [
    {
      'title': 'Cash Out',
      'subtitle': 'Agent: 01730805499',
      'amount': -5000.0,
      'date': 'Today, 10:32 AM',
      'icon': Icons.arrow_upward_rounded,
      'color': AppColors.error,
    },
    {
      'title': 'Send Money',
      'subtitle': 'To: Samantha',
      'amount': -1000.0,
      'date': 'Today, 09:15 AM',
      'icon': Icons.send_rounded,
      'color': AppColors.error,
    },
    {
      'title': 'Add Money',
      'subtitle': 'From: Bank Account',
      'amount': 10000.0,
      'date': 'Yesterday, 03:40 PM',
      'icon': Icons.add_circle_outline,
      'color': AppColors.success,
    },
    {
      'title': 'Electricity Bill',
      'subtitle': 'DESCO - Account #4521',
      'amount': -1500.0,
      'date': 'Mar 27, 2026',
      'icon': Icons.lightbulb_outline,
      'color': AppColors.error,
    },
    {
      'title': 'Mobile Recharge',
      'subtitle': 'Grameenphone - 01701*****4',
      'amount': -200.0,
      'date': 'Mar 26, 2026',
      'icon': Icons.phone_android,
      'color': AppColors.error,
    },
    {
      'title': 'Cash In',
      'subtitle': 'Agent: 01812345678',
      'amount': 5000.0,
      'date': 'Mar 25, 2026',
      'icon': Icons.arrow_downward_rounded,
      'color': AppColors.success,
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Grameenphone - Home',
      'amount': -800.0,
      'date': 'Mar 24, 2026',
      'icon': Icons.wifi,
      'color': AppColors.error,
    },
    {
      'title': 'Send Money',
      'subtitle': 'To: Rose Hope',
      'amount': -2500.0,
      'date': 'Mar 23, 2026',
      'icon': Icons.send_rounded,
      'color': AppColors.error,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() => _selectedFilter = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 0) return _transactions;
    if (_selectedFilter == 1) {
      return _transactions.where((t) => (t['amount'] as double) > 0).toList();
    }
    return _transactions.where((t) => (t['amount'] as double) < 0).toList();
  }

  double get _totalCredit => _transactions
      .where((t) => (t['amount'] as double) > 0)
      .fold(0, (sum, t) => sum + (t['amount'] as double));

  double get _totalDebit => _transactions
      .where((t) => (t['amount'] as double) < 0)
      .fold(0, (sum, t) => sum + (t['amount'] as double));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Statements'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_download_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCard(),
          _buildFilterTabs(),
          Expanded(
            child: _filtered.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    itemCount: _filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: AppColors.divider),
                    itemBuilder: (context, i) =>
                        _TransactionTile(data: _filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Total Credit',
              amount: '+৳${_totalCredit.toStringAsFixed(0)}',
              icon: Icons.arrow_downward_rounded,
              color: Colors.greenAccent,
            ),
          ),
          Container(width: 1, height: 50, color: Colors.white24),
          Expanded(
            child: _SummaryItem(
              label: 'Total Debit',
              amount: '-৳${_totalDebit.abs().toStringAsFixed(0)}',
              icon: Icons.arrow_upward_rounded,
              color: Colors.redAccent.shade100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: List.generate(_filters.length, (i) {
          final selected = _selectedFilter == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                _tabController.animateTo(i);
                setState(() => _selectedFilter = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  _filters[i],
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color:
                        selected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64, color: AppColors.textSecondary.withOpacity(0.4)),
          const SizedBox(height: 16),
          Text(
            'No transactions found',
            style: GoogleFonts.poppins(
              color: AppColors.textSecondary,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;

  const _SummaryItem({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final Map<String, dynamic> data;

  const _TransactionTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final amount = data['amount'] as double;
    final isCredit = amount > 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: (data['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(data['icon'] as IconData,
                color: data['color'] as Color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['title'] as String,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  data['subtitle'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  data['date'] as String,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.textSecondary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : ''}৳${amount.abs().toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isCredit ? AppColors.success : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
