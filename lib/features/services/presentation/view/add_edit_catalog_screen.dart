import 'package:account_atlas/core/constants/app_color.dart';
import 'package:account_atlas/core/constants/app_spacing.dart';
import 'package:account_atlas/features/accounts/data/repositories/service_catalog_repository.dart';
import 'package:account_atlas/features/services/domain/services_enums.dart';
import 'package:account_atlas/features/services/presentation/provider/service_catalog_provider.dart';
import 'package:account_atlas/features/shared/service_category_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AddEditCatalogScreen extends ConsumerStatefulWidget {
  final int? accountId; // optional for add flow, required for edit flow
  final int? serviceId; // null for add, non-null for edit

  const AddEditCatalogScreen({super.key, this.accountId, this.serviceId});

  @override
  ConsumerState<AddEditCatalogScreen> createState() =>
      _AddEditCatalogScreenState();
}

class _AddEditCatalogScreenState extends ConsumerState<AddEditCatalogScreen> {
  final _searchController = TextEditingController();
  ServiceCategory? _selectedCategory; // null means "All"
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleServiceSelect(ServiceCatalogItem item) {
    final extraData = <String, dynamic>{'catalogItem': item};
    if (widget.accountId != null) {
      extraData['accountId'] = widget.accountId;
    }

    if (widget.serviceId != null) {
      // Edit flow: navigate to /services/details/:id/edit
      context.push(
        '/services/details/${widget.serviceId}/edit',
        extra: extraData,
      );
    } else {
      // Add flow: navigate to /services/add
      context.push('/services/add', extra: extraData);
    }
  }

  void _handleManualEntry() {
    final extraData = <String, dynamic>{};
    if (widget.accountId != null) {
      extraData['accountId'] = widget.accountId;
    }

    if (widget.serviceId != null) {
      // Edit flow
      context.push(
        '/services/details/${widget.serviceId}/edit',
        extra: extraData,
      );
    } else {
      // Add flow
      context.push('/services/add', extra: extraData);
    }
  }

  Widget _buildCategoryChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.basic,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColor.primary : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(serviceCatalogProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          widget.serviceId != null ? 'Edit Service' : 'Select Service',
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: catalogState.when(
          data: (catalog) => _buildContent(catalog),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  Widget _buildContent(Map<String, ServiceCatalogItem> catalog) {
    // Filter services by category and search query
    final filteredServices = catalog.values.where((service) {
      // "All" when _selectedCategory is null, otherwise compare lowercase
      final matchesCategory =
          _selectedCategory == null ||
          service.category.toLowerCase() ==
              _selectedCategory!.dbCode.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          service.displayName.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
      return matchesCategory && matchesSearch;
    }).toList();

    return Column(
      children: [
        // Search Bar
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(AppSpacing.basic),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search for a service...',
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColor.primary),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.basic,
                vertical: 12,
              ),
            ),
          ),
        ),

        // Category Tabs
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.basic),
            child: Row(
              children: [
                // "All" chip
                _buildCategoryChip(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                // Category chips
                ...ServiceCategory.values.map((category) {
                  return _buildCategoryChip(
                    label: category.dbCode,
                    isSelected: _selectedCategory == category,
                    onTap: () => setState(() => _selectedCategory = category),
                  );
                }),
              ],
            ),
          ),
        ),

        const Divider(height: 1, color: Color(0xFFE5E7EB)),

        // Service Grid
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.basic),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Popular Services',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: filteredServices.length,
                  itemBuilder: (context, index) {
                    final service = filteredServices[index];
                    return _ServiceCard(
                      service: service,
                      onTap: () => _handleServiceSelect(service),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.basic),
                // Manual Entry Button
                GestureDetector(
                  onTap: _handleManualEntry,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.basic),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFD1D5DB),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '+ Enter Manually',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final ServiceCatalogItem service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final categoryIcon = serviceCategoryIcon[service.category];
    final hasLogo = service.iconKey != null;
    final backgroundColor = service.iconColor != null
        ? Color(service.iconColor!)
        : AppColor.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: hasLogo ? backgroundColor : AppColor.black,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: hasLogo
                    ? Image.asset(
                        'assets/logos/${service.iconKey}.png',
                        width: 32,
                        height: 32,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) =>
                            categoryIcon ?? const Icon(Icons.category),
                      )
                    : categoryIcon ?? const Icon(Icons.category),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                service.displayName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Color(0xFF111827)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
