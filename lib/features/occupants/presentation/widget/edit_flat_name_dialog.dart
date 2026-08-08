import 'package:easy_localization/easy_localization.dart';
import 'package:fair_share/core/localization/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditFlatNameDialog extends HookConsumerWidget {
  final String currentFlatName;
  final String flatId;
  final Future<void> Function(String newName) onSave;

  const EditFlatNameDialog({
    super.key,
    required this.currentFlatName,
    required this.flatId,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: currentFlatName);
    final errorState = useState<String?>(null);
    final isLoading = useState(false);
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(LocaleKeys.occupants_edit_flat_name.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            autofocus: true,
            decoration: InputDecoration(
              labelText: LocaleKeys.occupants_flat_name_label.tr(),
              errorText: errorState.value,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value ? null : () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.dashboard_cancel.tr()),
        ),
        ElevatedButton(
          onPressed: isLoading.value
              ? null
              : () async {
                  final newName = controller.text.trim();
                  if (newName.isEmpty) {
                    errorState.value =
                        LocaleKeys.occupants_flat_name_empty_error.tr();
                    return;
                  }
                  isLoading.value = true;
                  try {
                    await onSave(newName);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (context.mounted) {
                      errorState.value = LocaleKeys.occupants_update_flat_error
                          .tr(args: [e.toString()]);
                    }
                  } finally {
                    isLoading.value = false;
                  }
                },
          child: isLoading.value
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : Text(LocaleKeys.dashboard_save.tr()),
        ),
      ],
    );
  }
}
