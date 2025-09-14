import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../models/contact_request.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _companyController = TextEditingController();
  final _messageController = TextEditingController();
  
  ContactType _selectedType = ContactType.demo;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Contact',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildContactForm(context),
            _buildContactInfo(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.contact_mail,
            size: 64,
            color: Theme.of(context).colorScheme.primary,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Contactez-nous',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            'Ready to secure your infrastructure? Let\'s discuss your needs.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send us a message',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Contact type selection
            Text(
              'Request type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: ContactType.values.map((type) {
                final isSelected = type == _selectedType;
                return ChoiceChip(
                  label: Text(_getContactTypeLabel(type)),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = type;
                      });
                    }
                  },
                  backgroundColor: Colors.transparent,
                  selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected 
                      ? Theme.of(context).colorScheme.primary 
                      : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 24),
            
            // Name field
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Full Name *',
                hintText: 'Your first and last name',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                if (value.trim().length < 2) {
                  return 'Name must contain at least 2 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Email field
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email *',
                hintText: 'your.email@example.com',
                prefixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Company field
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(
                labelText: 'Company *',
                hintText: 'Your company name',
                prefixIcon: const Icon(Icons.business),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your company name';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Message field
            TextFormField(
              controller: _messageController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Message *',
                hintText: 'Describe your needs, questions, or specific requests...',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80),
                  child: Icon(Icons.message),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your message';
                }
                if (value.trim().length < 10) {
                  return 'Message must contain at least 10 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 24),
            
            // Submit button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: _getSubmitButtonText(),
                onPressed: _isSubmitting ? null : _submitForm,
                isLoading: _isSubmitting,
                icon: _getSubmitButtonIcon(),
                height: 56,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              '* Champs obligatoires',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Text(
            'Other ways to contact us',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Row(
            children: [
              Expanded(
                child: _buildContactInfoCard(
                  context,
                  Icons.email,
                  'Email',
                  'contact@ampdefend.com',
                  'Réponse sous 24h',
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildContactInfoCard(
                  context,
                  Icons.phone,
                  'Téléphone',
                  '+33 1 23 45 67 89',
                  'Lun-Ven 9h-18h',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildContactInfoCard(
            context,
            Icons.location_on,
            'Adresse',
            '123 Avenue de la Cybersécurité\n75001 Paris, France',
            'Siège social',
            isFullWidth: true,
          ),
          
          const SizedBox(height: 24),
          
          // Social links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(context, Icons.business, 'LinkedIn'),
              const SizedBox(width: 16),
              _buildSocialButton(context, Icons.alternate_email, 'Twitter'),
              const SizedBox(width: 16),
              _buildSocialButton(context, Icons.code, 'GitHub'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoCard(
    BuildContext context,
    IconData icon,
    String title,
    String info,
    String subtitle, {
    bool isFullWidth = false,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isFullWidth
            ? Row(
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          info,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, String platform) {
    return InkWell(
      onTap: () => _openSocialLink(platform),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
      ),
    );
  }

  String _getContactTypeLabel(ContactType type) {
    switch (type) {
      case ContactType.demo:
        return 'Demo request';
      case ContactType.general:
        return 'General question';
      case ContactType.support:
        return 'Technical support';
      case ContactType.partnership:
        return 'Partenariat';
    }
  }

  String _getSubmitButtonText() {
    switch (_selectedType) {
      case ContactType.demo:
        return 'Request demo';
      case ContactType.general:
        return 'Send Message';
      case ContactType.support:
        return 'Contact support';
      case ContactType.partnership:
        return 'Propose partnership';
    }
  }

  IconData _getSubmitButtonIcon() {
    switch (_selectedType) {
      case ContactType.demo:
        return Icons.play_arrow;
      case ContactType.general:
        return Icons.send;
      case ContactType.support:
        return Icons.support_agent;
      case ContactType.partnership:
        return Icons.handshake;
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    final request = ContactRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      company: _companyController.text.trim(),
      message: _messageController.text.trim(),
      type: _selectedType,
      submittedAt: DateTime.now(),
    );

    // In a real app, you would send this to your backend
    print('Contact request: ${request.toJson()}');

    setState(() {
      _isSubmitting = false;
    });

    if (mounted) {
      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          icon: Icon(
            Icons.check_circle,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          title: const Text('Message envoyé !'),
          content: Text(
            _selectedType == ContactType.demo
                ? 'Thank you for your demo request. Our team will contact you within 24 hours to schedule a personalized presentation.'
                : 'Thank you for your message. Our team will respond as soon as possible.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous page
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
      _companyController.clear();
      _messageController.clear();
      setState(() {
        _selectedType = ContactType.demo;
      });
    }
  }

  void _openSocialLink(String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Ouverture de $platform...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}