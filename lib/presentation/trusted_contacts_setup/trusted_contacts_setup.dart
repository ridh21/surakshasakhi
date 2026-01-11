import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/add_contact_dialog.dart';
import './widgets/contact_card_widget.dart';
import './widgets/empty_state_widget.dart';

/// Trusted Contacts Setup Screen
/// Enables users to configure emergency contact list for automatic alert system
/// Uses stack navigation with contact management interface optimized for mobile
class TrustedContactsSetup extends StatefulWidget {
  const TrustedContactsSetup({super.key});

  @override
  State<TrustedContactsSetup> createState() => _TrustedContactsSetupState();
}

class _TrustedContactsSetupState extends State<TrustedContactsSetup> {
  List<Map<String, dynamic>> _contacts = [];
  bool _isLoading = false;
  final int _minimumContactsRequired = 2;

  @override
  void initState() {
    super.initState();
    _loadMockContacts();
  }

  void _loadMockContacts() {
    setState(() {
      _contacts = [
        {
          "id": "1",
          "name": "Vijay Patel",
          "phone": "+91 99099 90999",
          "relationship": "Family",
          "isVerified": true,
          "notificationPreferences": {
            "sms": true,
            "call": true,
            "locationSharing": true,
          },
        },
        {
          "id": "2",
          "name": "Campus Security",
          "phone": "+91 89876 54321",
          "relationship": "Security",
          "isVerified": true,
          "notificationPreferences": {
            "sms": true,
            "call": true,
            "locationSharing": true,
          },
        },
      ];
    });
  }

  Future<void> _requestContactsPermission() async {
    final status = await Permission.contacts.request();
    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Contacts permission is required to add contacts'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _showAddContactDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactDialog(
        onContactAdded: (contact) {
          setState(() {
            _contacts.add({
              "id": DateTime.now().millisecondsSinceEpoch.toString(),
              ...contact,
              "isVerified": false,
            });
          });
        },
      ),
    );
  }

  void _deleteContact(String id) {
    setState(() {
      _contacts.removeWhere((contact) => contact["id"] == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contact removed'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _editContact(Map<String, dynamic> contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddContactDialog(
        existingContact: contact,
        onContactAdded: (updatedContact) {
          setState(() {
            final index = _contacts.indexWhere((c) => c["id"] == contact["id"]);
            if (index != -1) {
              _contacts[index] = {
                "id": contact["id"],
                ...updatedContact,
                "isVerified": contact["isVerified"],
              };
            }
          });
        },
      ),
    );
  }

  Future<void> _verifyContact(Map<String, dynamic> contact) async {
    setState(() => _isLoading = true);

    await Future.delayed(Duration(seconds: 2));

    setState(() {
      final index = _contacts.indexWhere((c) => c["id"] == contact["id"]);
      if (index != -1) {
        _contacts[index]["isVerified"] = true;
      }
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification message sent to ${contact["name"]}'),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
  }

  void _reorderContacts(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final contact = _contacts.removeAt(oldIndex);
      _contacts.insert(newIndex, contact);
    });
  }

  bool get _canContinue => _contacts.length >= _minimumContactsRequired;

  void _handleContinue() {
    if (_canContinue) {
      Navigator.of(context, rootNavigator: true).pushNamed('/safety-dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Trusted Contacts',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            )
          : _contacts.isEmpty
          ? EmptyStateWidget(onAddContact: _showAddContactDialog)
          : Column(
              children: [
                _buildHeaderSection(theme),
                Expanded(child: _buildContactsList(theme)),
                _buildBottomSection(theme),
              ],
            ),
      floatingActionButton: _contacts.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: _showAddContactDialog,
              backgroundColor: theme.colorScheme.primary,
              icon: CustomIconWidget(
                iconName: 'add',
                color: theme.colorScheme.onPrimary,
                size: 24,
              ),
              label: Text(
                'Add Contact',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildHeaderSection(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info_outline',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Emergency Contact Information',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'These contacts will receive location sharing and emergency alerts when your safety score reaches critical levels.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList(ThemeData theme) {
    return ReorderableListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: _contacts.length,
      onReorder: _reorderContacts,
      itemBuilder: (context, index) {
        final contact = _contacts[index];
        return Slidable(
          key: ValueKey(contact["id"]),
          startActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _deleteContact(contact["id"] as String),
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => _editContact(contact),
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: theme.colorScheme.onSecondary,
                icon: Icons.edit,
                label: 'Edit',
              ),
              if (!(contact["isVerified"] as bool))
                SlidableAction(
                  onPressed: (context) => _verifyContact(contact),
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                  icon: Icons.verified_user,
                  label: 'Verify',
                ),
            ],
          ),
          child: ContactCardWidget(
            contact: contact,
            onTap: () => _editContact(contact),
            onVerify: () => _verifyContact(contact),
          ),
        );
      },
    );
  }

  Widget _buildBottomSection(ThemeData theme) {
    final progress = _contacts.length / _minimumContactsRequired;
    final progressClamped = progress > 1.0 ? 1.0 : progress;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'security',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Minimum $_minimumContactsRequired contacts required',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${_contacts.length}/$_minimumContactsRequired',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _canContinue
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progressClamped,
                minHeight: 8,
                backgroundColor: theme.colorScheme.outline.withValues(
                  alpha: 0.2,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(
                  _canContinue
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.error,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'lock',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Contact data is encrypted and used only during emergencies',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canContinue ? _handleContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _canContinue
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withValues(alpha: 0.3),
                  foregroundColor: _canContinue
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Continue',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
