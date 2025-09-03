import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/fee_provider.dart';
import '../models/fee.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class FeesScreen extends StatefulWidget {
  const FeesScreen({super.key});

  @override
  State<FeesScreen> createState() => _FeesScreenState();
}

class _FeesScreenState extends State<FeesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFees();
    });
  }

  Future<void> _loadFees() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final feeProvider = Provider.of<FeeProvider>(context, listen: false);
    
    if (authProvider.currentAccountNumber != null) {
      await feeProvider.loadFees(authProvider.currentAccountNumber!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarifas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFees,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadFees,
        child: Consumer<FeeProvider>(
          builder: (context, feeProvider, child) {
            if (feeProvider.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (feeProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error,
                      color: AppTheme.errorColor,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Erro ao carregar tarifas',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      feeProvider.errorMessage!,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadFees,
                      child: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              );
            }

            if (feeProvider.fees.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt_long,
                      color: AppTheme.textSecondary,
                      size: 64,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Nenhuma tarifa encontrada',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Suas tarifas aparecerão aqui quando você realizar operações',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Summary card
                Card(
                  margin: const EdgeInsets.all(16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Resumo de Tarifas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Total de Tarifas',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  '${feeProvider.fees.length}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text(
                                  'Valor Total',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                Text(
                                  Formatters.formatCurrency(feeProvider.totalFees),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.errorColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Fees list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: feeProvider.fees.length,
                    itemBuilder: (context, index) {
                      final fee = feeProvider.fees[index];
                      return _FeeCard(fee: fee);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FeeCard extends StatelessWidget {
  final Fee fee;

  const _FeeCard({required this.fee});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getFeeTypeColor(fee.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getFeeTypeIcon(fee.type),
                    color: _getFeeTypeColor(fee.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fee.typeDisplayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fee.description,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Formatters.formatCurrency(fee.amount),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.errorColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      Formatters.formatDateTime(fee.createdAt),
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getFeeTypeColor(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFER':
        return AppTheme.primaryColor;
      case 'WITHDRAWAL':
        return AppTheme.errorColor;
      case 'DEPOSIT':
        return AppTheme.successColor;
      default:
        return AppTheme.warningColor;
    }
  }

  IconData _getFeeTypeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'TRANSFER':
        return Icons.send;
      case 'WITHDRAWAL':
        return Icons.remove_circle;
      case 'DEPOSIT':
        return Icons.add_circle;
      default:
        return Icons.receipt;
    }
  }
}
