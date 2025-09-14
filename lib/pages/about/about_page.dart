import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/team_member.dart';
import '../../services/mock_data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'À propos',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(context),
            _buildMissionVisionSection(context),
            _buildValuesSection(context),
            _buildStatsSection(context),
            _buildTeamSection(context),
            _buildCertificationsSection(context),
            _buildTimelineSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.shield,
              size: 50,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'À propos d\'AMPDefend',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Nous sommes une équipe passionnée d\'experts en cybersécurité, dédiée à révolutionner la détection des menaces grâce à l\'intelligence artificielle.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    final companyInfo = MockData.companyInfo;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Notre Mission',
                  companyInfo['mission'] as String,
                  Icons.flag,
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(width: 16),
              
              Expanded(
                child: _buildInfoCard(
                  context,
                  'Notre Vision',
                  companyInfo['vision'] as String,
                  Icons.visibility,
                  Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, String title, String content, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context) {
    final values = MockData.companyInfo['values'] as List<String>;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Text(
            'Nos Valeurs',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: values.map((value) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final companyInfo = MockData.companyInfo;
    
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'AMPDefend en chiffres',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _buildStatCard(context, companyInfo['founded'].toString(), 'Fondée en'),
              _buildStatCard(context, companyInfo['employees'].toString(), 'Employés'),
              _buildStatCard(context, companyInfo['headquarters'].toString(), 'Siège social'),
              _buildStatCard(context, '${(companyInfo['certifications'] as List).length}', 'Certifications'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Notre Équipe',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 16),
          
          Text(
            'Rencontrez les experts qui font d\'AMPDefend une solution de sécurité d\'exception.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          ...MockData.teamMembers.map((member) => _buildTeamMemberCard(context, member)),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(BuildContext context, TeamMember member) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: Text(
                    member.name.split(' ').map((e) => e[0]).join(''),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                
                const SizedBox(width: 20),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 4),
                      
                      Text(
                        member.position,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Row(
                        children: [
                          if (member.linkedIn != null)
                            IconButton(
                              icon: const Icon(Icons.business),
                              onPressed: () => _launchUrl(member.linkedIn!),
                              tooltip: 'LinkedIn',
                              iconSize: 20,
                            ),
                          if (member.twitter != null)
                            IconButton(
                              icon: const Icon(Icons.alternate_email),
                              onPressed: () => _launchUrl('https://twitter.com/${member.twitter}'),
                              tooltip: 'Twitter',
                              iconSize: 20,
                            ),
                          IconButton(
                            icon: const Icon(Icons.email),
                            onPressed: () => _launchUrl('mailto:${member.email}'),
                            tooltip: 'Email',
                            iconSize: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              member.bio,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: member.skills.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    skill,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertificationsSection(BuildContext context) {
    final certifications = MockData.companyInfo['certifications'] as List<String>;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Text(
            'Certifications & Conformité',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 24),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: certifications.map((cert) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.verified,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    cert,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'Notre Histoire',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 32),
          
          _buildTimelineItem(
            context,
            '2020',
            'Fondation',
            'Création d\'AMPDefend avec la vision de révolutionner la cybersécurité.',
            Icons.foundation,
          ),
          
          _buildTimelineItem(
            context,
            '2021',
            'Premier Produit',
            'Lancement de notre première solution de honeypots intelligents.',
            Icons.rocket_launch,
          ),
          
          _buildTimelineItem(
            context,
            '2023',
            'Expansion',
            'Expansion internationale et certification ISO 27001.',
            Icons.public,
          ),
          
          _buildTimelineItem(
            context,
            '2024',
            'Innovation',
            'Intégration de l\'IA avancée et partenariats stratégiques.',
            Icons.psychology,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(
    BuildContext context,
    String year,
    String title,
    String description,
    IconData icon, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
          ],
        ),
        
        const SizedBox(width: 16),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                year,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 4),
              
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
              ),
              
              if (!isLast) const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}