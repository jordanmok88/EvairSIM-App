import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../providers/sim_providers.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/forms/brand_text_field.dart';

/// Connects an existing Red Tea eSIM (issued via email or the admin portal)
/// to the current account. Unlike the old marketplace flow, the customer
/// does NOT buy an eSIM here — they register one they already have.
///
/// Minimum info needed:
///   • ICCID of the eSIM (printed on the email / admin assignment)
///   • LPA activation string  `LPA:1$<smdp-address>$<matching-id>`  (optional
///     but normally included)
///
/// The app posts to `/v1/app/users/bind-sim` with both fields; the backend
/// currently stores `activation_code` for future SM-DP+ verification.
class ConnectEsimPage extends ConsumerStatefulWidget {
  const ConnectEsimPage({super.key});

  @override
  ConsumerState<ConnectEsimPage> createState() => _ConnectEsimPageState();
}

class _ConnectEsimPageState extends ConsumerState<ConnectEsimPage> {
  final _iccidCtrl = TextEditingController();
  final _lpaCtrl = TextEditingController();

  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _iccidCtrl.dispose();
    _lpaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Connect eSIM'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
            _IntroCard(),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: AppRadius.card,
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _FieldLabel('1. Enter ICCID'),
                  const SizedBox(height: 4),
                  const Text(
                    '18–22 digit number in your activation email.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  BrandTextField(
                    controller: _iccidCtrl,
                    hint: '89012345678901234567',
                    keyboardType: TextInputType.number,
                    icon: Icons.sim_card,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _pasteInto(_iccidCtrl, digitsOnly: true),
                      icon: const Icon(Icons.content_paste, size: 16),
                      label: const Text('Paste from clipboard'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _FieldLabel('2. Paste LPA activation code'),
                  const SizedBox(height: 4),
                  const Text(
                    'Looks like LPA:1\$smdp.example.com\$ABCDEF…  — usually in the same email.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  BrandTextField(
                    controller: _lpaCtrl,
                    hint: r'LPA:1$smdp.redtea.io$ABC…',
                    keyboardType: TextInputType.text,
                    icon: Icons.qr_code_2,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _pasteInto(_lpaCtrl, digitsOnly: false),
                      icon: const Icon(Icons.content_paste, size: 16),
                      label: const Text('Paste from clipboard'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warningBg,
                borderRadius: BorderRadius.circular(AppRadius.r12),
                border: Border.all(color: AppColors.warningBorder),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline,
                      color: AppColors.warningDeep, size: 18),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'eSIM profiles can only be installed once. After connecting, '
                      'install the QR to your device from My SIMs.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.warningDeep,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!,
                  style:
                      const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Connect eSIM',
              icon: Icons.link,
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pasteInto(
    TextEditingController controller, {
    required bool digitsOnly,
  }) async {
    final data = await Clipboard.getData('text/plain');
    if (!mounted) return;
    final raw = (data?.text ?? '').trim();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Clipboard is empty.')),
      );
      return;
    }
    if (digitsOnly) {
      final digits = raw.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 18) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No valid ICCID in clipboard.')),
        );
        return;
      }
      controller.text = digits;
    } else {
      controller.text = raw;
    }
  }

  Future<void> _submit() async {
    final iccid = _iccidCtrl.text.trim();
    final lpa = _lpaCtrl.text.trim();

    if (iccid.length < 18 || iccid.length > 22) {
      setState(() => _error = 'ICCID must be 18–22 digits.');
      return;
    }
    if (lpa.isNotEmpty && !lpa.toUpperCase().startsWith('LPA:')) {
      setState(() =>
          _error = 'LPA activation code should start with "LPA:". Leave blank to skip.');
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });

    final repo = ref.read(simRepositoryProvider);
    final res = await repo.bindSim(
      iccid: iccid,
      activationCode: lpa.isEmpty ? null : lpa,
    );
    if (!mounted) return;
    res.match(
      (l) => setState(() {
        _submitting = false;
        _error = l.message;
      }),
      (_) {
        ref.invalidate(userSimsProvider);
        setState(() => _submitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('eSIM connected to your account.')),
        );
        context.pop();
      },
    );
  }
}

class _IntroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brandOrange, AppColors.brandRed],
        ),
        borderRadius: BorderRadius.circular(AppRadius.r16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link_rounded, color: AppColors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Connect a Red Tea eSIM',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            'Already received your activation email? Enter the ICCID + LPA code '
            'below and we\'ll add the eSIM to your account.',
            style: TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: AppColors.textPrimary,
        ),
      );
}
