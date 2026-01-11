import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Add Contact Dialog
/// Modal bottom sheet for adding or editing contacts
class AddContactDialog extends StatefulWidget {
  final Map<String, dynamic>? existingContact;
  final Function(Map<String, dynamic>) onContactAdded;

  const AddContactDialog({
    super.key,
    this.existingContact,
    required this.onContactAdded,
  });

  @override
  State<AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  String _selectedRelationship = 'Family';
  bool _smsEnabled = true;
  bool _callEnabled = true;
  bool _locationSharingEnabled = true;

  final List<String> _relationships = ['Family', 'Friend', 'Security', 'Other'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.existingContact?["name"] as String? ?? '',
    );
    _phoneController = TextEditingController(
      text: widget.existingContact?["phone"] as String? ?? '',
    );
    if (widget.existingContact != null) {
      _selectedRelationship = widget.existingContact!["relationship"] as String;
      final prefs =
          widget.existingContact!["notificationPreferences"]
              as Map<String, dynamic>?;
      if (prefs != null) {
        _smsEnabled = prefs["sms"] as bool? ?? true;
        _callEnabled = prefs["call"] as bool? ?? true;
        _locationSharingEnabled = prefs["locationSharing"] as bool? ?? true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_formKey.currentState?.validate() ?? false) {
      final contact = {
        "name": _nameController.text.trim(),
        "phone": _phoneController.text.trim(),
        "relationship": _selectedRelationship,
        "notificationPreferences": {
          "sms": _smsEnabled,
          "call": _callEnabled,
          "locationSharing": _locationSharingEnabled,
        },
      };
      widget.onContactAdded(contact);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEditing = widget.existingContact != null;

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomSheetTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isEditing ? 'Edit Contact' : 'Add Contact',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: CustomIconWidget(
                            iconName: 'close',
                            color: theme.colorScheme.onSurface,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        hintText: 'Enter contact name',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+1 (555) 123-4567',
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(12),
                          child: CustomIconWidget(
                            iconName: 'phone',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9+\-() ]'),
                        ),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (value.replaceAll(RegExp(r'[^0-9]'), '').length <
                            10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Relationship',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _relationships.map((relationship) {
                        final isSelected =
                            _selectedRelationship == relationship;
                        return ChoiceChip(
                          label: Text(relationship),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(
                                () => _selectedRelationship = relationship,
                              );
                            }
                          },
                          selectedColor: theme.colorScheme.primaryContainer,
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: theme.textTheme.labelLarge?.copyWith(
                            color: isSelected
                                ? theme.colorScheme.onPrimaryContainer
                                : theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Notification Preferences',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildPreferenceSwitch(
                      theme,
                      'SMS Alerts',
                      'Receive text message alerts',
                      _smsEnabled,
                      (value) => setState(() => _smsEnabled = value),
                    ),
                    _buildPreferenceSwitch(
                      theme,
                      'Phone Calls',
                      'Receive emergency phone calls',
                      _callEnabled,
                      (value) => setState(() => _callEnabled = value),
                    ),
                    _buildPreferenceSwitch(
                      theme,
                      'Location Sharing',
                      'Share real-time location during emergencies',
                      _locationSharingEnabled,
                      (value) =>
                          setState(() => _locationSharingEnabled = value),
                    ),
                    SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveContact,
                        child: Text(isEditing ? 'Save Changes' : 'Add Contact'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceSwitch(
    ThemeData theme,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
