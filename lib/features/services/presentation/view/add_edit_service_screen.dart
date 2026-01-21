import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/formatters.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/accounts/presentation/state/accounts_state.dart';
import 'package:account_atlas/features/accounts/presentation/vm/accounts_view_model.dart';
import 'package:account_atlas/features/services/domain/entities/plan_entity.dart';
import 'package:account_atlas/features/services/domain/entities/service_entity.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/state/add_edit_service_state.dart';
import 'package:account_atlas/features/services/presentation/vm/add_edit_service_view_model.dart';
import 'package:account_atlas/features/shared/account_icon_config.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditServiceScreen extends ConsumerStatefulWidget {
  final int? serviceId;
  final int? accountId;
  final ServiceCatalogItem? catalogItem;

  const AddEditServiceScreen({
    super.key,
    this.serviceId,
    this.accountId,
    this.catalogItem,
  });

  @override
  ConsumerState<AddEditServiceScreen> createState() =>
      _AddEditServiceScreenState();
}

class _AddEditServiceScreenState extends ConsumerState<AddEditServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _loginIdController = TextEditingController();
  final _priceController = TextEditingController();
  final _memoController = TextEditingController();

  int? _selectedAccountId;
  ServiceCategory _selectedCategory =
      ServiceCategory.others; // Default to Others
  LoginType _selectedLoginType = LoginType.social; // Default to Social (#3)
  bool _isPay = false;
  BillingCycle _billingCycle = BillingCycle.monthly;
  // Currency is fixed to USD (#4)
  static const Currency _currency = Currency.en;
  DateTime? _nextBillingDate;

  bool _isInitialized = false;

  bool get _isEditMode => widget.serviceId != null;

  @override
  void initState() {
    super.initState();
    _selectedAccountId = widget.accountId;

    // Prefill from catalog if provided (#1)
    if (widget.catalogItem != null) {
      _serviceNameController.text = widget.catalogItem!.displayName;
      // Use catalog category, case-insensitive match
      _selectedCategory = ServiceCategory.fromDbcode(
        widget.catalogItem!.category,
      );
    }
    // If no catalog item, _selectedCategory stays as default (Others)
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _loginIdController.dispose();
    _priceController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  void _initializeForm(ServiceDetailReadModel? model) {
    if (_isInitialized) return;

    if (model != null) {
      final service = model.service;
      final plan = model.plan;

      _serviceNameController.text = service.displayName;
      _loginIdController.text = service.loginId ?? '';
      _memoController.text = service.memo ?? '';
      _selectedAccountId = service.accountId;
      _selectedCategory = service.category;
      _selectedLoginType = service.loginType;
      _isPay = service.isPay;

      if (plan != null) {
        // Format price with commas for display (empty for 0)
        _priceController.text = plan.amount > 0
            ? AppFormatters.formatPrice(plan.amount)
            : '';
        _billingCycle = plan.billingCycle;
        // Currency is fixed to USD, ignore plan.currency
        _nextBillingDate = plan.nextBillingDate;
      }
    }

    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(addEditserviceViewModelProvider(widget.serviceId));
    final accountsState = ref.watch(accountsViewModelProvider);

    ref.listen<AddEditServiceState>(
      addEditserviceViewModelProvider(widget.serviceId),
      (previous, next) {
        switch (next) {
          case AddEditServiceLoaded(service: final model)
              when previous is AddEditServiceSaving && model != null:
            // Clear provider state
            ref.invalidate(addEditserviceViewModelProvider(null));

            if (widget.serviceId != null) {
              // Edit flow: go back to service detail screen
              context.pop();
            } else {
              // Add flow: navigate to the newly created service detail screen
              final newServiceId = model.service.id;
              if (newServiceId != null) {
                context.go('/services/details/$newServiceId');
              } else {
                context.pop();
              }
            }
            break;
          case AddEditServiceError(message: final message):
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
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Service' : 'Add Service'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.basic),
          child: _buildContent(state, accountsState),
        ),
      ),
    );
  }

  Widget _buildContent(AddEditServiceState state, AccountsState accountsState) {
    return switch (state) {
      AddEditServiceLoading() => const Center(
        child: CircularProgressIndicator(),
      ),
      AddEditServiceLoaded(service: final model) => _buildForm(
        model: model,
        isSaving: false,
        accountsState: accountsState,
      ),
      AddEditServiceSaving(service: final model) => _buildForm(
        model: model,
        isSaving: true,
        accountsState: accountsState,
      ),
      AddEditServiceError() => _buildForm(
        model: null,
        isSaving: false,
        accountsState: accountsState,
      ),
    };
  }

  Widget _buildForm({
    required ServiceDetailReadModel? model,
    required bool isSaving,
    required AccountsState accountsState,
  }) {
    _initializeForm(model);

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Account Dropdown
            _buildLabel('Account *'),
            _buildAccountDropdown(accountsState, isSaving),
            Gaps.v16,

            // Service Name with Icon
            _buildLabel('Service Name *'),
            Row(
              children: [
                _buildServiceIcon(),
                Gaps.h12,
                Expanded(
                  child: TextFormField(
                    controller: _serviceNameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter service name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Service name is required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            Gaps.v16,

            // Category
            _buildLabel('Category'),
            DropdownButtonFormField<ServiceCategory>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ServiceCategory.values
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(category.dbCode),
                    ),
                  )
                  .toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
            ),
            Gaps.v16,

            // Login Type
            _buildLabel('Login Type'),
            DropdownButtonFormField<LoginType>(
              initialValue: _selectedLoginType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: LoginType.values
                  .map(
                    (type) =>
                        DropdownMenuItem(value: type, child: Text(type.dbCode)),
                  )
                  .toList(),
              onChanged: isSaving
                  ? null
                  : (value) {
                      if (value != null) {
                        setState(() => _selectedLoginType = value);
                      }
                    },
            ),
            Gaps.v16,

            // Login ID - only enabled when LoginType == ID (#2)
            _buildLabel(
              _selectedLoginType == LoginType.id ? 'Login ID *' : 'Login ID',
            ),
            TextFormField(
              controller: _loginIdController,
              enabled: !isSaving && _selectedLoginType == LoginType.id,
              decoration: InputDecoration(
                hintText: _selectedLoginType == LoginType.id
                    ? 'Enter login ID'
                    : 'Not applicable for this login type',
                border: const OutlineInputBorder(),
                filled: _selectedLoginType != LoginType.id,
                fillColor: _selectedLoginType != LoginType.id
                    ? Colors.grey.shade100
                    : null,
              ),
              validator: (value) {
                // Only validate when LoginType == ID (#2)
                if (_selectedLoginType == LoginType.id &&
                    (value == null || value.trim().isEmpty)) {
                  return 'Login ID is required when Login Type is ID';
                }
                return null;
              },
            ),
            Gaps.v16,

            // Is Subscription
            Container(
              padding: const EdgeInsets.all(AppSpacing.basic),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subscription Service',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Switch(
                    value: _isPay,
                    onChanged: isSaving
                        ? null
                        : (value) => setState(() => _isPay = value),
                    activeTrackColor: AppColor.primary,
                  ),
                ],
              ),
            ),
            Gaps.v16,

            // Subscription Details
            if (_isPay) ...[
              _buildLabel('Billing Cycle'),
              DropdownButtonFormField<BillingCycle>(
                initialValue: _billingCycle,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                items: BillingCycle.values
                    .map(
                      (cycle) => DropdownMenuItem(
                        value: cycle,
                        child: Text(cycle.name),
                      ),
                    )
                    .toList(),
                onChanged: isSaving
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => _billingCycle = value);
                        }
                      },
              ),
              Gaps.v16,

              // Currency - fixed to USD (#4)
              _buildLabel('Currency'),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.basic),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Text(
                  _currency.dbCode,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Gaps.v16,

              // Price with comma formatting (#5)
              _buildLabel('Price *'),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: '0',
                  border: const OutlineInputBorder(),
                  prefixText: '${_currency.dbCode} ',
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [ThousandsSeparatorInputFormatter()],
                validator: (value) {
                  // Price is required when subscription is ON (#6)
                  if (_isPay) {
                    final digitsOnly =
                        value?.replaceAll(RegExp(r'[^\d]'), '') ?? '';
                    if (digitsOnly.isEmpty) {
                      return 'Price is required for subscription services';
                    }
                  }
                  return null;
                },
              ),
              Gaps.v16,

              // Next Billing Date - required when subscription is ON (#6)
              _buildLabel('Next Billing Date *'),
              FormField<DateTime>(
                initialValue: _nextBillingDate,
                validator: (value) {
                  if (_isPay && _nextBillingDate == null) {
                    return 'Next billing date is required for subscription services';
                  }
                  return null;
                },
                builder: (formState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: isSaving ? null : _selectNextBillingDate,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.basic),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: formState.hasError
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: formState.hasError
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              Gaps.h12,
                              Text(
                                _nextBillingDate != null
                                    ? '${_nextBillingDate!.year}-${_nextBillingDate!.month.toString().padLeft(2, '0')}-${_nextBillingDate!.day.toString().padLeft(2, '0')}'
                                    : 'Select date',
                                style: TextStyle(
                                  color: _nextBillingDate != null
                                      ? Colors.black
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (formState.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 12),
                          child: Text(
                            formState.errorText!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              Gaps.v16,
            ],

            // Memo
            _buildLabel('Memo'),
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                hintText: 'Add notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            Gaps.v24,

            // Save Button
            ElevatedButton(
              onPressed: isSaving ? null : () => _handleSave(model),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primary,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.basic),
              ),
              child: isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _isEditMode ? 'Save Changes' : 'Create Service',
                      style: const TextStyle(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      ),
    );
  }

  Widget _buildServiceIcon() {
    final categoryIcon = serviceCategoryIcon[_selectedCategory.name];
    final catalogIcon = widget.catalogItem?.iconKey;
    final iconColor = widget.catalogItem?.iconColor;

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: iconColor != null ? Color(iconColor) : AppColor.black,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: catalogIcon != null
            ? Image.asset(
                'assets/logos/$catalogIcon.png',
                width: 32,
                height: 32,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) =>
                    categoryIcon ?? const Icon(Icons.category),
              )
            : categoryIcon ?? const Icon(Icons.category),
      ),
    );
  }

  Widget _buildAccountDropdown(AccountsState accountsState, bool isSaving) {
    return switch (accountsState) {
      AccountsLoading() => const LinearProgressIndicator(),
      AccountsError() => const Text('Error loading accounts'),
      AccountsEmpty() => ElevatedButton(
        onPressed: () => context.push('/accounts/add'),
        child: const Text('+ Add New Account'),
      ),
      AccountsLoaded(accounts: final accounts) => DropdownButtonFormField<int>(
        initialValue: _selectedAccountId,
        isExpanded: true,
        decoration: const InputDecoration(border: OutlineInputBorder()),
        validator: (value) {
          if (value == null) {
            return 'Please select an account';
          }
          return null;
        },
        items: [
          ...accounts.map((account) {
            final config = accountIconMap[account.provider];
            return DropdownMenuItem<int>(
              value: account.accountId,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: config?.bg ?? AppColor.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      config?.icon ?? Icons.account_circle,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  Gaps.h12,
                  Flexible(
                    child: Text(
                      '${account.provider.dbCode} (${account.identifier})',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),
          const DropdownMenuItem<int>(
            value: -1,
            child: Row(
              children: [
                Icon(Icons.add_circle_outline, color: AppColor.primary),
                Gaps.h12,
                Flexible(
                  child: Text(
                    '+ Add New Account',
                    style: TextStyle(color: AppColor.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: isSaving
            ? null
            : (value) {
                if (value == -1) {
                  context.push('/accounts/add').then((_) {
                    ref.invalidate(accountsViewModelProvider);
                  });
                } else {
                  setState(() => _selectedAccountId = value);
                }
              },
      ),
    };
  }

  Future<void> _selectNextBillingDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _nextBillingDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (date != null) {
      setState(() => _nextBillingDate = date);
    }
  }

  Future<void> _handleSave(ServiceDetailReadModel? loadedModel) async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedAccountId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select an account')));
      return;
    }

    final notifier = ref.read(
      addEditserviceViewModelProvider(widget.serviceId).notifier,
    );

    final service = ServiceEntity(
      id: widget.serviceId,
      accountId: _selectedAccountId!,
      providedServiceKey: widget.catalogItem?.key,
      displayName: _serviceNameController.text.trim(),
      loginType: _selectedLoginType,
      loginId: _loginIdController.text.trim().isEmpty
          ? null
          : _loginIdController.text.trim(),
      category: _selectedCategory,
      isPay: _isPay,
      memo: _memoController.text.trim().isEmpty
          ? null
          : _memoController.text.trim(),
      createdAt: loadedModel?.service.createdAt,
    );

    final plan = _isPay && _nextBillingDate != null
        ? PlanEntity(
            id: loadedModel?.plan?.id,
            accountServiceId: widget.serviceId ?? 0,
            currency: _currency,
            // Parse formatted price (remove commas) (#5)
            amount: ThousandsSeparatorInputFormatter.parseToInt(
              _priceController.text,
            ),
            billingCycle: _billingCycle,
            nextBillingDate: _nextBillingDate!,
            createdAt: loadedModel?.plan?.createdAt,
          )
        : null;

    final model = ServiceDetailReadModel(service: service, plan: plan);

    if (_isEditMode) {
      await notifier.update(model);
    } else {
      await notifier.create(model);
    }
  }
}
