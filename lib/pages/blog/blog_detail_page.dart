import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/blog_post.dart';
import '../../services/mock_data.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogPost post;

  const BlogDetailPage({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareArticle(context),
            tooltip: 'Partager',
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () => _bookmarkArticle(context),
            tooltip: 'Sauvegarder',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroImage(context),
            _buildArticleContent(context),
            _buildAuthorSection(context),
            _buildRelatedArticles(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.8),
            Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ],
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.article,
              size: 80,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    post.category,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article meta
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                '${post.readTimeMinutes} min de lecture',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              
              const SizedBox(width: 16),
              
              Icon(
                Icons.calendar_today,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
              const SizedBox(width: 4),
              Text(
                post.formattedDate,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Excerpt
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            child: Text(
              post.excerpt,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.6,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Article content
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.8,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Tags
          if (post.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: post.tags.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    tag,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 32),
          ],
          
          // Share section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  'Cet article vous a été utile ?',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 16),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      context,
                      Icons.thumb_up_outlined,
                      'Utile',
                      () => _likeArticle(context),
                    ),
                    _buildActionButton(
                      context,
                      Icons.share,
                      'Partager',
                      () => _shareArticle(context),
                    ),
                    _buildActionButton(
                      context,
                      Icons.bookmark_border,
                      'Sauvegarder',
                      () => _bookmarkArticle(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            child: Text(
              post.author.split(' ').map((e) => e[0]).join(''),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.author,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 4),
                
                Text(
                  'Expert en Cybersécurité',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Spécialiste en sécurité informatique avec plus de 10 ans d\'expérience dans la détection et la prévention des cybermenaces.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelatedArticles(BuildContext context) {
    // Get related articles (same category, excluding current)
    final relatedPosts = MockData.blogPosts
        .where((p) => p.category == post.category && p.id != post.id)
        .take(2)
        .toList();
    
    if (relatedPosts.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Articles Similaires',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 16),
          
          ...relatedPosts.map((relatedPost) => _buildRelatedArticleCard(context, relatedPost)),
        ],
      ),
    );
  }

  Widget _buildRelatedArticleCard(BuildContext context, BlogPost relatedPost) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailPage(post: relatedPost),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.8),
                      Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.article,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      relatedPost.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      '${relatedPost.readTimeMinutes} min • ${relatedPost.formattedDate}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareArticle(BuildContext context) {
    Clipboard.setData(ClipboardData(text: 'Découvrez cet article : ${post.title}'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lien copié dans le presse-papiers'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _bookmarkArticle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Article sauvegardé'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _likeArticle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Merci pour votre retour !'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}