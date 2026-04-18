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

/// Wizard-ish page that binds a physical SIM card to the current user via
/// ICCID.  The real camera scanner will land in a native-only branch (depends
/// on mobile_scanner permissions not available on web) — for now we expose
/// manual entry + paste, which is enough to validate the flow end-to-end.
class PhysicalSimPage extends ConsumerStatefulWidget {
  const PhysicalSimPage({super.key});

  @override
  ConsumerState<PhysicalSimPage> createState() => _PhysicalSimPageState();
}

class _PhysicalSimPageState extends ConsumerState<PhysicalSimPage> {
  final _iccidCtrl = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _iccidCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Activate PCCW SIM'),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.pageHorizontal),
          children: [
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
                  const Text(
                    '1. Find your PCCW SIM ICCID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'It is the 18–22 digit number printed next to the barcode on the back of the card.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    '2. Enter ICCID',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  BrandTextField(
                    controller: _iccidCtrl,
                    hint: '89012345678901234567',
                    keyboardType: TextInputType.number,
                    icon: Icons.sim_card,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: _pasteFromClipboard,
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
                      'Camera scanning launches with native iOS/Android in Milestone 7. '
                      'Manual entry works on all platforms.',
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
                  style: const TextStyle(color: AppColors.error, fontSize: 12)),
            ],
            const SizedBox(height: AppSpacing.xl),
            PrimaryButton(
              label: 'Activate SIM',
              icon: Icons.check_circle_outline,
              isLoading: _submitting,
              onPressed: _submitting ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData('text/plain');
    if (!mounted) return;
    final text = (data?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (text.length >= 18) {
      _iccidCtrl.text = text;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid ICCID in clipboard.')),
      );
    }
  }

  Future<void> _submit() async {
    final iccid = _iccidCtrl.text.trim();
    if (iccid.length < 18 || iccid.length > 22) {
      setState(() => _error = 'ICCID must be 18–22 digits.');
      return;
    }
    setState(() {
      _error = null;
      _submitting = true;
    });
    final repo = ref.read(simRepositoryProvider);
    final res = await repo.bindSim(iccid: iccid);
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
          const SnackBar(content: Text('SIM activated.')),
        );
        context.pop();
      },
    );
  }
}
