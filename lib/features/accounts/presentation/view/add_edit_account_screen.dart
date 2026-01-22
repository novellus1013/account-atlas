import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/features/accounts/domain/accounts_enums.dart';
import 'package:account_atlas/features/accounts/domain/entities/account_entity.dart';
import 'package:account_atlas/features/accounts/presentation/state/add_edit_account_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/add_edit_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditAccountScreen extends ConsumerStatefulWidget {
  final String? id;

  const AddEditAccountScreen({super.key, this.id});

  @override
  ConsumerState<AddEditAccountScreen> createState() =>
      _AddEditAccountScreenState();
}

class _AddEditAccountScreenState extends ConsumerState<AddEditAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  AccountProvider _selectedProvider = AccountProvider.email;

  int? get _accountId => widget.id == null ? null : int.tryParse(widget.id!);
  bool get _isEditMode => _accountId != null;

  bool _isInitialized = false;

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _initializeForm(AccountEntity? account) {
    if (_isInitialized) return;

    if (account != null) {
      _identifierController.text = account.identifier;
      _selectedProvider = account.provider;
    } else {
      _identifierController.clear();
      _selectedProvider = AccountProvider.email;
    }
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEditAccountViewModelProvider(_accountId));

    ref.listen<AddEditAccountState>(
      addEditAccountViewModelProvider(_accountId),
      (previous, next) {
        switch (next) {
          case AddEditAccountLoaded(account: final account)
              when previous is AddEditAccountSaving && account?.id != null:
            ref.invalidate(addEditAccountViewModelProvider(null));
            // Navigate to AccountsScreen after add/edit
            context.go('/accounts');
            break;
          case AddEditAccountError(message: final message):
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(message)));
            break;
          default:
            break;
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColor.grey50,
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Account' : 'Add Account'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.basic),
          child: _buildContent(state),
        ),
      ),
    );
  }

  Widget _buildContent(AddEditAccountState state) {
    return switch (state) {
      AddEditAccountLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      AddEditAccountLoaded(account: final account) => _buildForm(
        account: account,
        isSaving: false,
      ),
      AddEditAccountSaving(account: final account) => _buildForm(
        account: account,
        isSaving: true,
      ),
      AddEditAccountError() => _buildForm(account: null, isSaving: false),
    };
  }

  Widget _buildForm({required AccountEntity? account, required bool isSaving}) {
    _initializeForm(account);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _identifierController,
            decoration: const InputDecoration(
              labelText: 'Identifier',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Identifier is required.';
              }
              return null;
            },
          ),
          Gaps.v16,
          DropdownButtonFormField<AccountProvider>(
            initialValue: _selectedProvider,
            decoration: const InputDecoration(
              labelText: 'Provider',
              border: OutlineInputBorder(),
            ),
            items: AccountProvider.values
                .map(
                  (provider) => DropdownMenuItem(
                    value: provider,
                    child: Text(provider.dbCode),
                  ),
                )
                .toList(),
            onChanged: isSaving
                ? null
                : (value) {
                    if (value != null) {
                      setState(() {
                        _selectedProvider = value;
                      });
                    }
                  },
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: isSaving ? null : () => _handleSave(account),
            child: isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isEditMode ? 'Save Changes' : 'Create Account',
                    style: TextStyle(color: AppColor.white),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSave(AccountEntity? loadedAccount) async {
    if (!_formKey.currentState!.validate()) return;

    final notifier = ref.read(
      addEditAccountViewModelProvider(_accountId).notifier,
    );

    final account = AccountEntity(
      id: _accountId,
      identifier: _identifierController.text.trim(),
      provider: _selectedProvider,
      createdAt: loadedAccount?.createdAt,
    );

    if (_isEditMode) {
      await notifier.update(account);
    } else {
      await notifier.create(account);
    }
  }
}
