import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/account_provider.dart';
import '../providers/transfer_provider.dart';
import '../utils/app_theme.dart';
import '../utils/formatters.dart';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _destinationAccountController = TextEditingController();
  final _amountController = TextEditingController();
  String? _destinationAccountName;
  bool _isValidatingAccount = false;

  @override
  void dispose() {
    _destinationAccountController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _validateDestinationAccount() async {
    final accountNumber = _destinationAccountController.text.trim();
    if (accountNumber.isEmpty) return;

    setState(() {
      _isValidatingAccount = true;
      _destinationAccountName = null;
    });

    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    final balance = await accountProvider.getBalanceByAccountNumber(accountNumber);

    setState(() {
      _isValidatingAccount = false;
      if (balance != null) {
        _destinationAccountName = balance.accountName;
      } else {
        _destinationAccountName = null;
      }
    });
  }

  Future<void> _makeTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    final transferProvider = Provider.of<TransferProvider>(context, listen: false);
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);

    final success = await transferProvider.makeTransfer(
      _destinationAccountController.text.trim(),
      Formatters.parseAmount(_amountController.text),
    );

    if (success) {
      await accountProvider.loadBalance();
      
      if (mounted) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        icon: const Icon(
          Icons.check_circle,
          color: AppTheme.successColor,
          size: 48,
        ),
        title: const Text('Transferência Realizada!'),
        content: Consumer<TransferProvider>(
          builder: (context, transferProvider, child) {
            return Text(
              transferProvider.successMessage ?? 'Transferência realizada com sucesso!',
            );
          },
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Voltar ao Dashboard'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferência'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current balance card
              Consumer<AccountProvider>(
                builder: (context, accountProvider, child) {
                  if (accountProvider.balance != null) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Saldo Disponível',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              Formatters.formatCurrency(accountProvider.balance!.balance),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 24),
              
              // Destination account field
              TextFormField(
                controller: _destinationAccountController,
                decoration: InputDecoration(
                  labelText: 'Conta de Destino',
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  suffixIcon: _isValidatingAccount
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : _destinationAccountName != null
                          ? const Icon(Icons.check_circle, color: AppTheme.successColor)
                          : null,
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  
                  if (_destinationAccountName == null && !_isValidatingAccount) {
                    return 'Conta não encontrada';
                  }
                  
                  return null;
                },
                onChanged: (value) {
                  if (value.length >= 6) {
                    _validateDestinationAccount();
                  } else {
                    setState(() {
                      _destinationAccountName = null;
                    });
                  }
                },
              ),
              
              // Destination account name
              if (_destinationAccountName != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppTheme.successColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _destinationAccountName!,
                          style: const TextStyle(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Amount field
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.attach_money),
                  prefixText: 'R\$ ',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Campo obrigatório';
                  }
                  
                  if (!Formatters.isValidAmount(value)) {
                    return 'Valor inválido';
                  }
                  
                  final amount = Formatters.parseAmount(value);
                  final accountProvider = Provider.of<AccountProvider>(context, listen: false);
                  
                  if (accountProvider.balance != null && amount > accountProvider.balance!.balance) {
                    return 'Saldo insuficiente';
                  }
                  
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Transfer button
              Consumer<TransferProvider>(
                builder: (context, transferProvider, child) {
                  return ElevatedButton(
                    onPressed: transferProvider.isLoading ? null : _makeTransfer,
                    child: transferProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Transferir'),
                  );
                },
              ),
              
              const SizedBox(height: 16),
              
              // Error message
              Consumer<TransferProvider>(
                builder: (context, transferProvider, child) {
                  if (transferProvider.errorMessage != null) {
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.errorColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error, color: AppTheme.errorColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              transferProvider.errorMessage!,
                              style: const TextStyle(color: AppTheme.errorColor),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              
              const SizedBox(height: 24),
              
              // Info card
              Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Colors.blue.shade700),
                          const SizedBox(width: 8),
                          Text(
                            'Informações Importantes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Uma tarifa de R\$ 5,00 será cobrada para transferências\n'
                        '• A transferência será processada imediatamente\n'
                        '• Verifique os dados antes de confirmar',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
