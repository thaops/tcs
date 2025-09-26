import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tcs_flutter/common/widgets/enhanced_text_widget.dart';

/// Widget showcase các fonts mới
class FontShowcase extends StatelessWidget {
  const FontShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText.h3('Font Showcase'),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Headers', [
              AppText.h1('Heading 1 - Inter Bold'),
              SizedBox(height: 8.h),
              AppText.h2('Heading 2 - Inter SemiBold'),
              SizedBox(height: 8.h),
              AppText.h3('Heading 3 - Inter SemiBold'),
              SizedBox(height: 8.h),
              AppText.h4('Heading 4 - Inter Medium'),
            ]),

            SizedBox(height: 24.h),
            _buildSection('Body Text', [
              AppText.bodyLarge('Body Large - Inter Regular (16px)'),
              SizedBox(height: 8.h),
              AppText.bodyMedium('Body Medium - Inter Regular (14px)'),
              SizedBox(height: 8.h),
              AppText.bodySmall('Body Small - Inter Regular (12px)'),
            ]),

            SizedBox(height: 24.h),
            _buildSection('Labels', [
              AppText.labelLarge('Label Large - Inter Medium'),
              SizedBox(height: 8.h),
              AppText.labelMedium('Label Medium - Inter Medium'),
              SizedBox(height: 8.h),
              AppText.labelSmall('Label Small - Inter Medium'),
            ]),

            SizedBox(height: 24.h),
            _buildSection('Buttons', [
              AppText.buttonLarge('Button Large - Inter SemiBold'),
              SizedBox(height: 8.h),
              AppText.buttonMedium('Button Medium - Inter SemiBold'),
              SizedBox(height: 8.h),
              AppText.buttonSmall('Button Small - Inter SemiBold'),
            ]),

            SizedBox(height: 24.h),
            _buildSection('Other', [
              AppText.caption('Caption - Inter Regular'),
              SizedBox(height: 8.h),
              AppText.overline('OVERLINE - Inter Medium'),
            ]),

            SizedBox(height: 24.h),
            _buildSection('Colors', [
              AppText.h3('Primary Color', color: Colors.blue),
              SizedBox(height: 8.h),
              AppText.bodyMedium(
                'Secondary Color',
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8.h),
              AppText.labelLarge('Success Color', color: Colors.green),
              SizedBox(height: 8.h),
              AppText.buttonMedium('Warning Color', color: Colors.orange),
              SizedBox(height: 8.h),
              AppText.caption('Error Color', color: Colors.red),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.h4(title, color: Colors.grey.shade700),
        SizedBox(height: 12.h),
        ...children,
      ],
    );
  }
}
