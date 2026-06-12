import 'package:e_com_user/features/Address/data/model/address_model.dart';
import 'package:e_com_user/features/Address/presentation/provider/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_com_user/features/Address/presentation/widgets/address_progress_line.dart';
import 'package:e_com_user/features/Address/presentation/widgets/address_submit_button.dart';
import 'package:e_com_user/general/utils/enums/app_state.dart';
import 'package:e_com_user/features/Address/presentation/widgets/address_text_field.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _notesController = TextEditingController();

  double _formProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_calculateProgress);
    _phoneController.addListener(_calculateProgress);
    _addressController.addListener(_calculateProgress);
    _landmarkController.addListener(_calculateProgress);
    _notesController.addListener(_calculateProgress);
  }

  void _calculateProgress() {
    int completedSteps = 0;
    if (_nameController.text.trim().isNotEmpty) completedSteps++;
    if (_phoneController.text.trim().isNotEmpty) completedSteps++;
    if (_addressController.text.trim().isNotEmpty) completedSteps++;
    if (_landmarkController.text.trim().isNotEmpty) completedSteps++;
    if (_notesController.text.trim().isNotEmpty) completedSteps++;

    setState(() {
      _formProgress = completedSteps / 5;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _landmarkController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryAccent = AppColors.primaryColor;
    final addressProv = Provider.of<AddressProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'Add Delivery Address',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: Stack(
        children: [
          AddressProgressLine(
            progress: _formProgress,
            primaryAccent: primaryAccent,
          ),
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 140,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111827),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF374151)),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (addressProv.fetchState == AppState.loading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (addressProv.addressList.isEmpty) {
                          return Center(
                            child: Text(
                              'No address saved',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          );
                        }

                        final AddressModel a = addressProv.addressList.first;
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    a.name,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Gap(6),
                                  Text(
                                    a.phone,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                  const Gap(8),
                                  Flexible(
                                    child: Text(
                                      a.address,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: const Color(0xFF9CA3AF),
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // removed 'Use' button per request
                          ],
                        );
                      },
                    ),
                  ),
                  AddressTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'What should we call you?',
                    icon: Icons.person_rounded,
                  ),
                  const Gap(20),
                  AddressTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'For delivery updates',
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                    maxDigits: 10,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Phone number is required';
                      if (s.length != 10)
                        return 'Enter a 10 digit phone number';
                      return null;
                    },
                  ),
                  const Gap(20),
                  AddressTextField(
                    controller: _addressController,
                    label: 'Address',
                    hint: 'House No, Street, Local Area',
                    icon: Icons.maps_home_work_rounded,
                    maxLines: 3,
                  ),
                  const Gap(20),
                  AddressTextField(
                    controller: _landmarkController,
                    label: 'Landmark (Optional)',
                    hint: 'Spot nearest to you',
                    icon: Icons.explore_rounded,
                  ),
                  const Gap(20),
                  AddressTextField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    hint: 'Drop it at the door, ring bell, etc.',
                    icon: Icons.chat_bubble_rounded,
                    maxLines: 2,
                  ),
                  const Gap(40),
                  AddressSubmitButton(
                    enabled: _formProgress > 0.4,
                    primaryAccent: primaryAccent,
                    isLoading: addressProv.addState == AppState.loading,
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;

                      final provider = context.read<AddressProvider>();
                      await provider.handleAddAddress(
                        address: AddressModel(
                          id: DateTime.timestamp().toString(),
                          name: _nameController.text,
                          phone: _phoneController.text.trim(),
                          address: _addressController.text,
                          landMark: _landmarkController.text,
                          note: _notesController.text,
                        ),
                      );

                      // If add was successful, clear fields and reset progress.
                      if (provider.addState == AppState.success) {
                        _nameController.clear();
                        _phoneController.clear();
                        _addressController.clear();
                        _landmarkController.clear();
                        _notesController.clear();
                        setState(() => _formProgress = 0.0);
                        _formKey.currentState?.reset();
                      }
                    },
                  ),
                  const Gap(60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
