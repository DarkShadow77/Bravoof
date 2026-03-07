import 'package:bravoo/features/dashboard/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../profile/data/model/user_profile.dart';
import '../../../profile/data/repository/auth_link_repository_impl.dart';

class LinkedAccountsScreen extends StatefulWidget {
  const LinkedAccountsScreen({Key? key}) : super(key: key);

  @override
  State<LinkedAccountsScreen> createState() => _LinkedAccountsScreenState();
}

class _LinkedAccountsScreenState extends State<LinkedAccountsScreen> {
  final AuthLinkRepositoryImpl _authService = AuthLinkRepositoryImpl();

  UserProfile _userProfile = UserProfile.empty();
  bool _isLoading = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verificationController = TextEditingController();

  String? _pendingProvider;
  String? _pendingProviderEmail;
  String? _currentEmail;
  bool _emailsMatch = false;

  @override
  void initState() {
    super.initState();
    _userProfile = context.read<ProfileBloc>().state.profile;
  }

  // ═══════════════════════════════════════════════════════════════
  // ADD PASSWORD
  // ═══════════════════════════════════════════════════════════════

  Future<void> _showPasswordDialog() async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Create a password to enable email/password sign-in',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter password (min 6 characters)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _addPassword();
            },
            child: const Text('Add Password'),
          ),
        ],
      ),
    );
  }

  Future<void> _addPassword() async {
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please enter a password', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.addPassword(
      password: _passwordController.text,
    );
    _passwordController.clear();

    setState(() => _isLoading = false);

    result.fold((error) => _showSnackBar(error, isError: true), (message) {
      _showSnackBar(message, isError: false);
      // Also refresh profile bloc if you're using it
      context.read<ProfileBloc>().add(GetProfileEvent());
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // LINK GOOGLE
  // ═══════════════════════════════════════════════════════════════

  Future<void> _linkGoogle() async {
    setState(() => _isLoading = true);

    final result = await _authService.initiateGoogleLink();

    setState(() => _isLoading = false);

    result.fold((error) => _showSnackBar(error, isError: true), (response) {
      if (response.requiresVerification) {
        setState(() {
          _pendingProvider = 'google';
          _pendingProviderEmail = response.providerEmail;
          _currentEmail = response.currentEmail;
          _emailsMatch = response.emailsMatch;
        });
        _showVerificationDialog();
      } else {
        _showSnackBar('Google account linked successfully', isError: false);
        // Also refresh profile bloc if you're using it
        context.read<ProfileBloc>().add(GetProfileEvent());
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // LINK APPLE
  // ═══════════════════════════════════════════════════════════════

  Future<void> _linkApple() async {
    setState(() => _isLoading = true);

    final result = await _authService.initiateAppleLink();

    setState(() => _isLoading = false);

    result.fold((error) => _showSnackBar(error, isError: true), (response) {
      if (response.requiresVerification) {
        setState(() {
          _pendingProvider = 'apple';
          _pendingProviderEmail = response.providerEmail;
          _currentEmail = response.currentEmail;
          _emailsMatch = response.emailsMatch;
        });
        _showVerificationDialog();
      } else {
        _showSnackBar('Apple account linked successfully', isError: false);
        // Also refresh profile bloc if you're using it
        context.read<ProfileBloc>().add(GetProfileEvent());
      }
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // VERIFICATION DIALOG
  // ═══════════════════════════════════════════════════════════════

  Future<void> _showVerificationDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(
          'Verify ${_pendingProvider?.toUpperCase()} Account',
          style: const TextStyle(fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!_emailsMatch) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: Colors.orange.shade700,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Different email detected',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade900,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Current: $_currentEmail',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Linking: $_pendingProviderEmail',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'A verification code has been sent to:',
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Text(
                _pendingProviderEmail ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _verificationController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  hintText: 'Enter 6-digit code',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                  fontWeight: FontWeight.bold,
                ),
                maxLength: 6,
                textCapitalization: TextCapitalization.characters,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _verificationController.clear();
              setState(() {
                _pendingProvider = null;
                _pendingProviderEmail = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _verifyLink();
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // VERIFY LINK
  // ═══════════════════════════════════════════════════════════════
  Future<void> _verifyLink() async {
    if (_verificationController.text.length != 6) {
      _showSnackBar('Please enter a 6-digit code', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final result = await _authService.verifyAndCompleteLink(
      verificationCode: _verificationController.text,
    );

    setState(() => _isLoading = false);

    _verificationController.clear();
    setState(() {
      _pendingProvider = null;
      _pendingProviderEmail = null;
    });

    result.fold((error) => _showSnackBar(error, isError: true), (response) {
      _showSnackBar(
        '${response.provider.toUpperCase()} account linked successfully!',
        isError: false,
      );
      // Also refresh profile bloc if you're using it
      context.read<ProfileBloc>().add(GetProfileEvent());
    });
  }

  // ═══════════════════════════════════════════════════════════════
  // UNLINK PROVIDER
  // ═══════════════════════════════════════════════════════════════
  Future<void> _unlinkProvider(String provider) async {
    if (!_userProfile.authProviders.canUnlink(provider)) {
      _showSnackBar(
        'You must have at least one authentication method',
        isError: true,
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unlink Account'),
        content: Text(
          'Are you sure you want to unlink your $provider account? '
          'You will no longer be able to sign in with this method.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Unlink'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);

      final result = await _authService.unlinkProvider(provider: provider);

      setState(() => _isLoading = false);

      result.fold((error) => _showSnackBar(error, isError: true), (message) {
        _showSnackBar(message, isError: false);
        // Also refresh profile bloc if you're using it
        context.read<ProfileBloc>().add(GetProfileEvent());
      });
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // HELPER METHODS
  // ═══════════════════════════════════════════════════════════════

  void _showSnackBar(String message, {required bool isError}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // BUILD UI
  // ═══════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Linked Accounts'), elevation: 0),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          _userProfile = state.profile;
          return _buildContent();
        },
      ),
    );
  }

  Widget _buildContent() {
    final authProviders = _userProfile.authProviders;
    final providerEmails = _userProfile.providerEmails;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Manage your sign-in methods',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),

        // Show linked emails if multiple
        if (_userProfile.allEmails.length > 1)
          Card(
            color: Colors.blue.shade50,
            elevation: 0,
            margin: const EdgeInsets.only(top: 8, bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Linked Emails',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._userProfile.allEmails.map(
                    (email) => Padding(
                      padding: const EdgeInsets.only(left: 28, top: 4),
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          const SizedBox(height: 16),

        // Email/Password
        _buildProviderTile(
          icon: Icons.email,
          title: 'Email & Password',
          subtitle: providerEmails.email,
          isLinked: authProviders.email,
          onLink: _showPasswordDialog,
          onUnlink: () => _unlinkProvider('email'),
        ),

        const Divider(height: 32),

        // Google
        _buildProviderTile(
          icon: Icons.g_mobiledata,
          title: 'Google',
          subtitle: providerEmails.google,
          isLinked: authProviders.google,
          onLink: _linkGoogle,
          onUnlink: () => _unlinkProvider('google'),
          color: Colors.red,
        ),

        const Divider(height: 32),

        // Apple
        _buildProviderTile(
          icon: Icons.apple,
          title: 'Apple',
          subtitle: providerEmails.apple,
          isLinked: authProviders.apple,
          onLink: _linkApple,
          onUnlink: () => _unlinkProvider('apple'),
          color: Colors.black,
        ),

        const SizedBox(height: 24),

        // Status card
        Card(
          color: Colors.green.shade50,
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade700),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${authProviders.activeProvidersCount} sign-in method(s) active',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
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

  Widget _buildProviderTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool isLinked,
    required VoidCallback onLink,
    required VoidCallback onUnlink,
    Color? color,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? Colors.blue).withValues(alpha:0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 28, color: color ?? Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        isLinked ? (subtitle ?? 'Linked') : 'Not linked',
        style: TextStyle(
          fontSize: 13,
          color: isLinked ? Colors.green.shade700 : Colors.grey.shade600,
        ),
      ),
      trailing: isLinked
          ? IconButton(
              icon: const Icon(Icons.link_off),
              color: Colors.red.shade400,
              onPressed: onUnlink,
              tooltip: 'Unlink',
            )
          : OutlinedButton(
              onPressed: onLink,
              style: OutlinedButton.styleFrom(
                foregroundColor: color ?? Colors.blue,
              ),
              child: const Text('Link'),
            ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _verificationController.dispose();
    super.dispose();
  }
}
