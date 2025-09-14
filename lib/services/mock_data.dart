import '../models/feature.dart';
import '../models/blog_post.dart';
import '../models/testimonial.dart';
import '../models/team_member.dart';

class MockData {
  // Features data
  static List<Feature> get features => [
    const Feature(
      id: 'smart-honeypot',
      title: 'Smart Honeypot Technology',
      description: 'Advanced artificial intelligence to detect and analyze intrusion attempts in real time.',
      iconPath: 'assets/icons/shield.svg',
      category: 'Security',
      isHighlighted: true,
      benefits: [
        'Proactive threat detection',
        'Advanced behavioral analysis',
        'Adaptive machine learning',
        'Minimized false positives'
      ],
    ),
    const Feature(
      id: 'real-time-alerts',
      title: 'Real-Time Alerts',
      description: 'Instant notifications and dashboards for quick response to security incidents.',
      iconPath: 'assets/icons/alert.svg',
      category: 'Monitoring',
      benefits: [
        'Instant push notifications',
        'Customizable dashboards',
        'SIEM/SOAR integrations',
        'Automatic escalation'
      ],
    ),
    const Feature(
      id: 'analytics-dashboard',
      title: 'Analytics & Reporting',
      description: 'In-depth analysis and detailed reports to optimize your security posture.',
      iconPath: 'assets/icons/analytics.svg',
      category: 'Analytics',
      benefits: [
        'Advanced security metrics',
        'Automated reports',
        'Interactive visualizations',
        'Trends and predictions'
      ],
    ),
    const Feature(
      id: 'easy-deployment',
      title: 'Easy Deployment',
      description: 'Simple installation and automatic configuration for quick setup.',
      iconPath: 'assets/icons/deploy.svg',
      category: 'Deployment',
      benefits: [
        'One-click installation',
        'Automatic configuration',
        'Multi-platform support',
        'Complete documentation'
      ],
    ),
    const Feature(
      id: 'threat-intelligence',
      title: 'Threat Intelligence',
      description: 'Continuously updated threat database for optimal protection.',
      iconPath: 'assets/icons/intelligence.svg',
      category: 'Intelligence',
      benefits: [
        'Real-time updated IOCs',
        'Threat correlation',
        'Attack geolocation',
        'Behavioral signatures'
      ],
    ),
    const Feature(
      id: 'api-integration',
      title: 'API Integrations',
      description: 'Robust APIs to integrate AMPDefend with your existing security tools.',
      iconPath: 'assets/icons/api.svg',
      category: 'Integration',
      benefits: [
        'Complete REST API',
        'Configurable webhooks',
        'Multi-language SDKs',
        'OpenAPI documentation'
      ],
    ),
  ];

  // Blog posts data
  static List<BlogPost> get blogPosts => [
    BlogPost(
      id: 'honeypots-future-cybersecurity',
      title: 'The Future of Cybersecurity: Intelligent Honeypots',
      excerpt: 'Discover how next-generation honeypots are revolutionizing threat detection.',
      content: '''
Honeypots have evolved far beyond their simple origins. In today's cyber threat landscape, intelligent honeypots represent a revolution in proactive intrusion detection.

## What is an intelligent honeypot?

An intelligent honeypot uses artificial intelligence and machine learning to:
- Simulate realistic systems
- Adapt its behavior to attackers
- Analyze intrusion techniques in real time

## Key Benefits

1. **Early Detection**: Identifying threats before they reach critical systems
2. **Behavioral Analysis**: Deep understanding of attack tactics
3. **Reduced False Positives**: Contextual intelligence to filter alerts

## Implementation

Implementing AMPDefend in your infrastructure enables proactive protection without impacting production system performance.
      ''',
      author: 'Dr. Marie Dubois',
      publishDate: DateTime(2024, 12, 15),
      imageUrl: 'assets/images/blog_honeypots.jpg',
      tags: ['Cybersecurity', 'AI', 'Honeypots', 'Innovation'],
      readTimeMinutes: 8,
      category: 'Security',
    ),
    BlogPost(
      id: 'threat-landscape-2024',
      title: 'Threat Landscape 2024: New Trends',
      excerpt: 'Analysis of the latest cyberthreat trends and how to protect against them.',
      content: '''
The year 2024 marks a turning point in the evolution of cyber threats. Attackers are adopting increasingly sophisticated strategies.

## Main Trends

### 1. AI-Powered Attacks
Cybercriminals are using artificial intelligence to:
- Automate reconnaissance
- Personalize phishing attacks
- Bypass traditional defenses

### 2. Supply Chain Attacks
Supply chain attacks are multiplying, targeting vendors to reach end organizations.

### 3. Ransomware as a Service (RaaS)
The democratization of ransomware tools makes access easier for less experienced cybercriminals.

## Defense Strategies

To face these new threats, organizations must adopt a proactive security approach including:
- Advanced behavioral monitoring
- Defensive artificial intelligence
- Analysis of compromise indicators

AMPDefend addresses these challenges by offering early detection and real-time behavioral analysis.
      ''',
      author: 'Jean-Pierre Martin',
      publishDate: DateTime(2024, 12, 10),
      imageUrl: 'assets/images/blog_threats.jpg',
      tags: ['Threats', 'Trends', 'Ransomware', 'AI'],
      readTimeMinutes: 12,
      category: 'Threat Intelligence',
    ),
    BlogPost(
      id: 'implementing-zero-trust',
      title: 'Implementing Zero Trust Architecture',
      excerpt: 'Practical guide to migrating to a Zero Trust security architecture.',
      content: '''
Zero Trust architecture is becoming the standard for securing modern infrastructures. Here's how to implement it effectively.

## Fundamental Principles

### "Never Trust, Always Verify"
- Continuous identity verification
- Validation of every access
- Principle of least privilege

### Micro-segmentation
- Isolation of critical resources
- Granular access control
- Limitation of lateral propagation

## Implementation Steps

1. **Inventory and classification** of assets
2. **Data flow mapping**
3. **Access policy definition**
4. **Progressive deployment** of controls
5. **Continuous monitoring and adjustment**

## Integration with AMPDefend

AMPDefend's intelligent honeypots integrate perfectly into a Zero Trust architecture by providing:
- Lateral movement detection
- User behavior validation
- Alerts on unauthorized access attempts

This combined approach offers robust protection against internal and external threats.
      ''',
      author: 'Sophie Laurent',
      publishDate: DateTime(2024, 12, 5),
      imageUrl: 'assets/images/blog_zerotrust.jpg',
      tags: ['Zero Trust', 'Architecture', 'Security', 'Best Practices'],
      readTimeMinutes: 15,
      category: 'Architecture',
    ),
  ];

  // Testimonials data
  static List<Testimonial> get testimonials => [
    Testimonial(
      id: 'testimonial-1',
      name: 'Alexandre Rousseau',
      company: 'TechCorp France',
      position: 'CISO',
      testimonial: 'AMPDefend a transformé notre approche de la sécurité. La détection précoce des menaces nous a permis d\'éviter plusieurs incidents critiques.',
      avatarUrl: 'assets/images/avatar_1.jpg',
      rating: 5,
      date: DateTime(2024, 11, 20),
    ),
    Testimonial(
      id: 'testimonial-2',
      name: 'Camille Moreau',
      company: 'SecureBank',
      position: 'Responsable Cybersécurité',
      testimonial: 'L\'interface intuitive et les alertes en temps réel d\'AMPDefend ont considérablement amélioré notre temps de réponse aux incidents.',
      avatarUrl: 'assets/images/avatar_2.jpg',
      rating: 5,
      date: DateTime(2024, 11, 15),
    ),
    Testimonial(
      id: 'testimonial-3',
      name: 'Thomas Bernard',
      company: 'InnovTech Solutions',
      position: 'CTO',
      testimonial: 'La facilité de déploiement et l\'efficacité des honeypots intelligents font d\'AMPDefend un choix évident pour toute organisation soucieuse de sa sécurité.',
      avatarUrl: 'assets/images/avatar_3.jpg',
      rating: 5,
      date: DateTime(2024, 11, 10),
    ),
    Testimonial(
      id: 'testimonial-4',
      name: 'Julie Petit',
      company: 'DataSecure Ltd',
      position: 'Security Analyst',
      testimonial: 'AMPDefend\'s detailed analyses and automated reports save us precious time in our investigations.',
      avatarUrl: 'assets/images/avatar_4.jpg',
      rating: 4,
      date: DateTime(2024, 11, 5),
    ),
  ];

  // Team members data
  static List<TeamMember> get teamMembers => [
    const TeamMember(
      id: 'ceo-founder',
      name: 'Dr. Éric Dubois',
      position: 'CEO & Fondateur',
      bio: 'Expert en cybersécurité avec plus de 15 ans d\'expérience dans la recherche et le développement de solutions de sécurité innovantes.',
      imageUrl: 'assets/images/team_ceo.jpg',
      skills: ['Cybersécurité', 'IA', 'Leadership', 'Innovation'],
      email: 'eric.dubois@ampdefend.com',
      linkedIn: 'https://linkedin.com/in/ericdubois',
      twitter: '@ericdubois_sec',
    ),
    const TeamMember(
      id: 'cto',
      name: 'Sarah Johnson',
      position: 'CTO',
      bio: 'Architecte logiciel spécialisée dans les systèmes distribués et l\'intelligence artificielle appliquée à la sécurité.',
      imageUrl: 'assets/images/team_cto.jpg',
      skills: ['Architecture', 'IA/ML', 'Systèmes distribués', 'DevOps'],
      email: 'sarah.johnson@ampdefend.com',
      linkedIn: 'https://linkedin.com/in/sarahjohnson',
    ),
    const TeamMember(
      id: 'security-lead',
      name: 'Marc Lefebvre',
      position: 'Lead Security Researcher',
      bio: 'Computer security researcher, specialist in honeypots and behavioral analysis of malware.',
      imageUrl: 'assets/images/team_security.jpg',
      skills: ['Reverse Engineering', 'Malware Analysis', 'Honeypots', 'Threat Hunting'],
      email: 'marc.lefebvre@ampdefend.com',
      linkedIn: 'https://linkedin.com/in/marclefebvre',
    ),
    const TeamMember(
      id: 'product-manager',
      name: 'Lisa Chen',
      position: 'Product Manager',
      bio: 'Gestionnaire produit passionnée par l\'expérience utilisateur et l\'innovation en cybersécurité.',
      imageUrl: 'assets/images/team_pm.jpg',
      skills: ['Product Management', 'UX Design', 'Agile', 'Market Research'],
      email: 'lisa.chen@ampdefend.com',
      linkedIn: 'https://linkedin.com/in/lisachen',
    ),
  ];

  // Company information
  static Map<String, dynamic> get companyInfo => {
    'mission': 'Protect critical infrastructures with intelligent and proactive cybersecurity solutions.',
    'vision': 'Become the global leader in intelligent honeypot solutions and revolutionize threat detection.',
    'values': [
      'Continuous innovation',
      'Technical excellence',
      'Security by design',
      'Transparency',
      'Collaboration'
    ],
    'founded': 2020,
    'employees': '50-100',
    'headquarters': 'Paris, France',
    'certifications': ['ISO 27001', 'SOC 2 Type II', 'ANSSI Qualifié'],
  };

  // Statistics
  static Map<String, dynamic> get statistics => {
    'threatsDetected': '10M+',
    'clientsProtected': '500+',
    'uptimePercentage': '99.9%',
    'averageResponseTime': '< 30s',
    'falsPositiveRate': '< 0.1%',
    'dataProcessed': '1TB+/day',
  };

  // Social media links
  static Map<String, String> get socialLinks => {
    'linkedin': 'https://linkedin.com/company/ampdefend',
    'twitter': 'https://twitter.com/ampdefend',
    'github': 'https://github.com/ampdefend',
    'youtube': 'https://youtube.com/c/ampdefend',
  };

  // Client logos (placeholder paths)
  static List<String> get clientLogos => [
    'assets/images/client_1.png',
    'assets/images/client_2.png',
    'assets/images/client_3.png',
    'assets/images/client_4.png',
    'assets/images/client_5.png',
    'assets/images/client_6.png',
  ];
}