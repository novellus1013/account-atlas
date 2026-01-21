import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/core/constants/app_text_sizes.dart';
import 'package:account_atlas/core/theme/gaps.dart';
import 'package:account_atlas/core/utils/formatters.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/services/domain/model/service_detail_read_model.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/services/presentation/state/services_state.dart';
import 'package:account_atlas/features/services/presentation/view/widgets/service_card.dart';
import 'package:account_atlas/features/services/presentation/vm/services_view_model.dart';
import 'package:account_atlas/features/shared/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum ServiceSortOption {
  latestAdded('Latest Added'),
  highestPrice('Highest Price'),
  lowestPrice('Lowest Price');

  final String label;
  const ServiceSortOption(this.label);
}

class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  ServiceCategory? _selectedCategory;
  bool _subscriptionOnly = false;
  ServiceSortOption _sortOption = ServiceSortOption.latestAdded;
  bool _showFilterPanel = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceDetailReadModel> _filterAndSortServices(
    List<ServiceDetailReadModel> services,
  ) {
    var filtered = services.where((s) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          s.service.displayName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      final matchesCategory =
          _selectedCategory == null || s.service.category == _selectedCategory;
      final matchesSubscription = !_subscriptionOnly || s.service.isPay;
      return matchesSearch && matchesCategory && matchesSubscription;
    }).toList();

    switch (_sortOption) {
      case ServiceSortOption.latestAdded:
        filtered.sort((a, b) {
          final aDate = a.service.createdAt ?? DateTime(1970);
          final bDate = b.service.createdAt ?? DateTime(1970);
          return bDate.compareTo(aDate);
        });
      case ServiceSortOption.highestPrice:
        filtered.sort((a, b) {
          final aPrice = a.plan?.amount ?? 0;
          final bPrice = b.plan?.amount ?? 0;
          return bPrice.compareTo(aPrice);
        });
      case ServiceSortOption.lowestPrice:
        filtered.sort((a, b) {
          final aPrice = a.plan?.amount ?? 0;
          final bPrice = b.plan?.amount ?? 0;
          return aPrice.compareTo(bPrice);
        });
    }

    return filtered;
  }

  int _calculateTotalMonthlyCost(List<ServiceDetailReadModel> services) {
    return services.fold<int>(0, (sum, s) {
      if (s.plan != null) {
        if (s.plan!.billingCycle == BillingCycle.yearly) {
          return sum + (s.plan!.amount / 12).round();
        }
        return sum + s.plan!.amount;
      }
      return sum;
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesViewModelProvider);
    final catalogAsync = ref.watch(serviceCatalogProvider);

    final catalog = catalogAsync.when(
      data: (data) => data,
      loading: () => <String, ServiceCatalogItem>{},
      error: (e, s) => <String, ServiceCatalogItem>{},
    );

    return Scaffold(
      backgroundColor: AppColor.grey50,
      appBar: AppBar(
        title: const Text('Services'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(child: _buildContent(state, catalog)),
    );
  }

  Widget _buildContent(
    ServicesState state,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    return Column(
      children: [
        _SearchBar(
          controller: _searchController,
          searchQuery: _searchQuery,
          onChanged: (value) => setState(() => _searchQuery = value),
          onClear: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),
        _ControlsRow(
          sortOption: _sortOption,
          showFilterPanel: _showFilterPanel,
          subscriptionOnly: _subscriptionOnly,
          onSortChanged: (value) => setState(() => _sortOption = value),
          onFilterToggle: () =>
              setState(() => _showFilterPanel = !_showFilterPanel),
          onAddTap: () => context.push('/services/add/catalog'),
        ),
        if (_showFilterPanel)
          _FilterPanel(
            subscriptionOnly: _subscriptionOnly,
            onChanged: (value) => setState(() => _subscriptionOnly = value),
          ),
        _CategoryChips(
          selectedCategory: _selectedCategory,
          onCategorySelected: (category) =>
              setState(() => _selectedCategory = category),
        ),
        const Divider(height: 1, color: AppColor.grey200),
        Expanded(
          child: switch (state) {
            ServicesLoading() => const LoadingStateWidget(),
            ServicesEmpty() => EmptyStateWidget(
              icon: Icons.subscriptions_outlined,
              title: 'No services yet',
              message: 'Add your first service to get started',
              actionLabel: 'Add Service',
              actionIcon: Icons.add,
              onAction: () => context.push('/services/add/catalog'),
            ),
            ServicesError(message: final message) => ErrorStateWidget(
              title: 'Error loading services',
              message: message,
              onRetry: () => ref.invalidate(servicesViewModelProvider),
            ),
            ServicesLoaded(services: final services) => _buildServicesList(
              services,
              catalog,
            ),
          },
        ),
      ],
    );
  }

  Widget _buildServicesList(
    List<ServiceDetailReadModel> services,
    Map<String, ServiceCatalogItem> catalog,
  ) {
    final filteredServices = _filterAndSortServices(services);
    final totalMonthlyCost = _calculateTotalMonthlyCost(filteredServices);

    if (filteredServices.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No matching services',
        message: 'Try adjusting your filters',
      );
    }

    return Column(
      children: [
        _SummaryRow(
          count: filteredServices.length,
          totalMonthlyCost: totalMonthlyCost,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.basic),
            itemCount: filteredServices.length,
            itemBuilder: (context, index) {
              final service = filteredServices[index];
              return ServiceCard(
                service: service,
                catalog: catalog,
                onTap: () {
                  final id = service.service.id;
                  if (id != null) {
                    context.push('/services/details/$id');
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String searchQuery;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.searchQuery,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.all(AppSpacing.basic),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search services...',
          hintStyle: const TextStyle(color: AppColor.grey400),
          prefixIcon: const Icon(Icons.search, color: AppColor.grey400),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColor.grey400),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: AppColor.grey50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColor.grey200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColor.grey200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            borderSide: const BorderSide(color: AppColor.primary),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.basic,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }
}

class _ControlsRow extends StatelessWidget {
  final ServiceSortOption sortOption;
  final bool showFilterPanel;
  final bool subscriptionOnly;
  final ValueChanged<ServiceSortOption> onSortChanged;
  final VoidCallback onFilterToggle;
  final VoidCallback onAddTap;

  const _ControlsRow({
    required this.sortOption,
    required this.showFilterPanel,
    required this.subscriptionOnly,
    required this.onSortChanged,
    required this.onFilterToggle,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    final isFilterActive = showFilterPanel || subscriptionOnly;

    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.basic,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          // Sort Dropdown
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.grey200),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ServiceSortOption>(
                value: sortOption,
                icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                style: const TextStyle(
                  color: AppColor.grey600,
                  fontSize: AppTextSizes.md,
                ),
                items: ServiceSortOption.values.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option.label),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) onSortChanged(value);
                },
              ),
            ),
          ),
          Gaps.h8,
          // Filter Button
          _IconButton(
            icon: Icons.filter_list,
            isActive: isFilterActive,
            onTap: onFilterToggle,
          ),
          const Spacer(),
          // Add Button
          _IconButton(icon: Icons.add, isPrimary: true, onTap: onAddTap),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isPrimary;
  final VoidCallback onTap;

  const _IconButton({
    required this.icon,
    this.isActive = false,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary
              ? AppColor.primary
              : isActive
              ? AppColor.primary.withValues(alpha: 0.1)
              : AppColor.white,
          border: Border.all(
            color: isPrimary
                ? AppColor.primary
                : isActive
                ? AppColor.primary
                : AppColor.grey200,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          icon,
          size: AppSpacing.iconMd,
          color: isPrimary
              ? AppColor.white
              : isActive
              ? AppColor.primary
              : AppColor.grey600,
        ),
      ),
    );
  }
}

class _FilterPanel extends StatelessWidget {
  final bool subscriptionOnly;
  final ValueChanged<bool> onChanged;

  const _FilterPanel({required this.subscriptionOnly, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.basic,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          const Text(
            'Subscription only',
            style: TextStyle(
              fontSize: AppTextSizes.md,
              color: AppColor.grey600,
            ),
          ),
          const Spacer(),
          Switch(
            value: subscriptionOnly,
            onChanged: onChanged,
            activeTrackColor: AppColor.primary,
          ),
        ],
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  final ServiceCategory? selectedCategory;
  final ValueChanged<ServiceCategory?> onCategorySelected;

  const _CategoryChips({
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.basic),
        child: Row(
          children: [
            _CategoryChip(
              label: 'All',
              isSelected: selectedCategory == null,
              onTap: () => onCategorySelected(null),
            ),
            ...ServiceCategory.values.map((category) {
              return _CategoryChip(
                label: category.dbCode,
                isSelected: selectedCategory == category,
                onTap: () => onCategorySelected(category),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.basic,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primary : AppColor.grey100,
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColor.white : AppColor.grey600,
              fontWeight: FontWeight.w500,
              fontSize: AppTextSizes.md,
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final int count;
  final int totalMonthlyCost;

  const _SummaryRow({required this.count, required this.totalMonthlyCost});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.basic),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count service${count != 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: AppTextSizes.md,
              color: AppColor.grey500,
            ),
          ),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: AppTextSizes.md),
              children: [
                const TextSpan(
                  text: 'Total: ',
                  style: TextStyle(color: AppColor.grey500),
                ),
                TextSpan(
                  text: AppFormatters.formatPriceWithSymbol(totalMonthlyCost),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColor.primary,
                  ),
                ),
                const TextSpan(
                  text: ' / month',
                  style: TextStyle(color: AppColor.grey500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
