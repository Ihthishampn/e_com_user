import 'package:flutter/material.dart';
import 'package:e_com_user/features/Profile/presentation/widgets/profile_progress_line.dart';
import 'package:e_com_user/features/Profile/presentation/widgets/profile_submit_button.dart';
import 'package:e_com_user/features/Profile/presentation/widgets/profile_text_field.dart';
import 'package:e_com_user/general/utils/themes/app_colors.dart';
import 'package:e_com_user/general/utils/themes/app_text_style.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
          ProfileProgressLine(
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
                  ProfileTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'What should we call you?',
                    icon: Icons.person_rounded,
                  ),
                  const Gap(20),
                  ProfileTextField(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hint: 'For delivery updates',
                    icon: Icons.phone_android_rounded,
                    keyboardType: TextInputType.phone,
                  ),
                  const Gap(20),
                  ProfileTextField(
                    controller: _addressController,
                    label: 'Address',
                    hint: 'House No, Street, Local Area',
                    icon: Icons.maps_home_work_rounded,
                    maxLines: 3,
                  ),
                  const Gap(20),
                  ProfileTextField(
                    controller: _landmarkController,
                    label: 'Landmark (Optional)',
                    hint: 'Spot nearest to you',
                    icon: Icons.explore_rounded,
                  ),
                  const Gap(20),
                  ProfileTextField(
                    controller: _notesController,
                    label: 'Notes (Optional)',
                    hint: 'Drop it at the door, ring bell, etc.',
                    icon: Icons.chat_bubble_rounded,
                    maxLines: 2,
                  ),
                  const Gap(40),
                  ProfileSubmitButton(
                    enabled: _formProgress > 0.4,
                    primaryAccent: primaryAccent,
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Handle submit action
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
