import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final List<Widget>? actions;
  final bool isTransparent;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.actions,
    this.isTransparent = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: showBackButton 
        ? IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },
            tooltip: 'Retour à l\'accueil',
          )
        : null,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.shield,
                    color: Theme.of(context).colorScheme.primary,
                    size: 24,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title.isEmpty ? 'AMPDefend' : title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
      backgroundColor: isTransparent ? Colors.transparent : null,
      elevation: isTransparent ? 0 : null,
      automaticallyImplyLeading: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}