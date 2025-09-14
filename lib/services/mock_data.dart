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
      description: 'Intelligence artificielle avancée pour détecter et analyser les tentatives d\'intrusion en temps réel.',
      iconPath: 'assets/icons/shield.svg',
      category: 'Security',
      isHighlighted: true,
      benefits: [
        'Détection proactive des menaces',
        'Analyse comportementale avancée',
        'Apprentissage automatique adaptatif',
        'Faux positifs minimisés'
      ],
    ),
    const Feature(
      id: 'real-time-alerts',
      title: 'Alertes Temps Réel',
      description: 'Notifications instantanées et tableaux de bord pour une réponse rapide aux incidents de sécurité.',
      iconPath: 'assets/icons/alert.svg',
      category: 'Monitoring',
      benefits: [
        'Notifications push instantanées',
        'Tableaux de bord personnalisables',
        'Intégrations SIEM/SOAR',
        'Escalade automatique'
      ],
    ),
    const Feature(
      id: 'analytics-dashboard',
      title: 'Analytics & Reporting',
      description: 'Analyses approfondies et rapports détaillés pour optimiser votre posture de sécurité.',
      iconPath: 'assets/icons/analytics.svg',
      category: 'Analytics',
      benefits: [
        'Métriques de sécurité avancées',
        'Rapports automatisés',
        'Visualisations interactives',
        'Tendances et prédictions'
      ],
    ),
    const Feature(
      id: 'easy-deployment',
      title: 'Déploiement Facile',
      description: 'Installation simple et configuration automatique pour une mise en place rapide.',
      iconPath: 'assets/icons/deploy.svg',
      category: 'Deployment',
      benefits: [
        'Installation en un clic',
        'Configuration automatique',
        'Support multi-plateforme',
        'Documentation complète'
      ],
    ),
    const Feature(
      id: 'threat-intelligence',
      title: 'Threat Intelligence',
      description: 'Base de données de menaces mise à jour en continu pour une protection optimale.',
      iconPath: 'assets/icons/intelligence.svg',
      category: 'Intelligence',
      benefits: [
        'IOCs mis à jour en temps réel',
        'Corrélation de menaces',
        'Géolocalisation des attaques',
        'Signatures comportementales'
      ],
    ),
    const Feature(
      id: 'api-integration',
      title: 'Intégrations API',
      description: 'APIs robustes pour intégrer AMPDefend avec vos outils de sécurité existants.',
      iconPath: 'assets/icons/api.svg',
      category: 'Integration',
      benefits: [
        'REST API complète',
        'Webhooks configurables',
        'SDKs multi-langages',
        'Documentation OpenAPI'
      ],
    ),
  ];

  // Blog posts data
  static List<BlogPost> get blogPosts => [
    BlogPost(
      id: 'honeypots-future-cybersecurity',
      title: 'L\'avenir de la cybersécurité : Les honeypots intelligents',
      excerpt: 'Découvrez comment les honeypots nouvelle génération révolutionnent la détection des menaces.',
      content: '''
Les honeypots ont évolué bien au-delà de leurs origines simples. Dans le paysage actuel des menaces cybernétiques, les honeypots intelligents représentent une révolution dans la détection proactive des intrusions.

## Qu'est-ce qu'un honeypot intelligent ?

Un honeypot intelligent utilise l'intelligence artificielle et l'apprentissage automatique pour :
- Simuler des systèmes réalistes
- Adapter son comportement aux attaquants
- Analyser les techniques d'intrusion en temps réel

## Les avantages clés

1. **Détection précoce** : Identification des menaces avant qu'elles n'atteignent les systèmes critiques
2. **Analyse comportementale** : Compréhension approfondie des tactiques d'attaque
3. **Réduction des faux positifs** : Intelligence contextuelle pour filtrer les alertes

## Mise en pratique

L'implémentation d'AMPDefend dans votre infrastructure permet une protection proactive sans impact sur les performances des systèmes de production.
      ''',
      author: 'Dr. Marie Dubois',
      publishDate: DateTime(2024, 12, 15),
      imageUrl: 'assets/images/blog_honeypots.jpg',
      tags: ['Cybersécurité', 'IA', 'Honeypots', 'Innovation'],
      readTimeMinutes: 8,
      category: 'Security',
    ),
    BlogPost(
      id: 'threat-landscape-2024',
      title: 'Panorama des menaces 2024 : Nouvelles tendances',
      excerpt: 'Analyse des dernières tendances en matière de cybermenaces et comment s\'en protéger.',
      content: '''
L'année 2024 marque un tournant dans l'évolution des cybermenaces. Les attaquants adoptent des stratégies de plus en plus sophistiquées.

## Tendances principales

### 1. Attaques alimentées par l'IA
Les cybercriminels utilisent l'intelligence artificielle pour :
- Automatiser les reconnaissances
- Personnaliser les attaques de phishing
- Contourner les défenses traditionnelles

### 2. Supply Chain Attacks
Les attaques de la chaîne d'approvisionnement se multiplient, ciblant les fournisseurs pour atteindre les organisations finales.

### 3. Ransomware as a Service (RaaS)
La démocratisation des outils de ransomware facilite l'accès aux cybercriminels moins expérimentés.

## Stratégies de défense

Pour faire face à ces nouvelles menaces, les organisations doivent adopter une approche de sécurité proactive incluant :
- Surveillance comportementale avancée
- Intelligence artificielle défensive
- Analyse des indicateurs de compromission

AMPDefend répond à ces défis en offrant une détection précoce et une analyse comportementale en temps réel.
      ''',
      author: 'Jean-Pierre Martin',
      publishDate: DateTime(2024, 12, 10),
      imageUrl: 'assets/images/blog_threats.jpg',
      tags: ['Menaces', 'Trends', 'Ransomware', 'IA'],
      readTimeMinutes: 12,
      category: 'Threat Intelligence',
    ),
    BlogPost(
      id: 'implementing-zero-trust',
      title: 'Implémentation d\'une architecture Zero Trust',
      excerpt: 'Guide pratique pour migrer vers une architecture de sécurité Zero Trust.',
      content: '''
L'architecture Zero Trust devient la norme pour sécuriser les infrastructures modernes. Voici comment l'implémenter efficacement.

## Principes fondamentaux

### "Never Trust, Always Verify"
- Vérification continue de l'identité
- Validation de chaque accès
- Principe du moindre privilège

### Micro-segmentation
- Isolation des ressources critiques
- Contrôle granulaire des accès
- Limitation de la propagation latérale

## Étapes d'implémentation

1. **Inventaire et classification** des assets
2. **Mapping des flux** de données
3. **Définition des politiques** d'accès
4. **Déploiement progressif** des contrôles
5. **Monitoring et ajustement** continus

## Intégration avec AMPDefend

Les honeypots intelligents d'AMPDefend s'intègrent parfaitement dans une architecture Zero Trust en fournissant :
- Détection des mouvements latéraux
- Validation des comportements utilisateur
- Alertes sur les tentatives d'accès non autorisées

Cette approche combinée offre une protection robuste contre les menaces internes et externes.
      ''',
      author: 'Sophie Laurent',
      publishDate: DateTime(2024, 12, 5),
      imageUrl: 'assets/images/blog_zerotrust.jpg',
      tags: ['Zero Trust', 'Architecture', 'Sécurité', 'Best Practices'],
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
      testimonial: 'Les analyses détaillées et les rapports automatisés d\'AMPDefend nous font gagner un temps précieux dans nos investigations.',
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
      bio: 'Chercheur en sécurité informatique, spécialiste des honeypots et de l\'analyse comportementale des malwares.',
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
    'mission': 'Protéger les infrastructures critiques avec des solutions de cybersécurité intelligentes et proactives.',
    'vision': 'Devenir le leader mondial des solutions de honeypots intelligents et révolutionner la détection des menaces.',
    'values': [
      'Innovation continue',
      'Excellence technique',
      'Sécurité par design',
      'Transparence',
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