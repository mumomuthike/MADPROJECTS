import 'package:flutter/material.dart';
import '../../models/recipe.dart';

class DScreen extends StatelessWidget {
  final Recipe recipe;

  const DScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            elevation: 0,
            scrolledUnderElevation: 0,
            backgroundColor: const Color(0xFFFAF7F2),
            foregroundColor: const Color(0xFF111111),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _Circle_Btn(
                icon: Icons.arrow_back,
                onTap: () => Navigator.pop(context),
              ),
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 12),
                child: _Circle_Btn(icon: Icons.bookmark_border),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    recipe.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xFFF1EFEA),
                      child: const Center(
                        child: Icon(
                          Icons.restaurant_menu,
                          size: 52,
                          color: Color(0xFF111111),
                        ),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [Color(0xCC000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'RECIPE',
                          style: TextStyle(
                            color: Color(0xFFEFEFEF),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          recipe.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            _Meta_Tag(
                              text: '${recipe.ingredients.length} ingredients',
                              icon: Icons.shopping_bag_outlined,
                            ),
                            const _Meta_Tag(
                              text: 'Quick-ish',
                              icon: Icons.timer_outlined,
                            ),
                            const _Meta_Tag(
                              text: 'Easy',
                              icon: Icons.star_border,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Sec_Title(title: 'Ingredients'),
                  const SizedBox(height: 10),
                  _Info_Card(
                    child: Column(
                      children: recipe.ingredients.asMap().entries.map((entry) {
                        final isLast =
                            entry.key == recipe.ingredients.length - 1;
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            14,
                            12,
                            14,
                            isLast ? 14 : 12,
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 7),
                                    child: Icon(
                                      Icons.circle,
                                      size: 7,
                                      color: Color(0xFF111111),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      entry.value,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.35,
                                        color: Color(0xFF111111),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!isLast) ...[
                                const SizedBox(height: 12),
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFEFE7DC),
                                ),
                              ],
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const _Sec_Title(title: 'Instructions'),
                  const SizedBox(height: 10),
                  _Info_Card(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        recipe.instructions,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.75,
                          color: Color(0xFF1F1F1F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sec_Title extends StatelessWidget {
  final String title;
  const _Sec_Title({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16.5,
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
        color: Color(0xFF111111),
      ),
    );
  }
}

class _Info_Card extends StatelessWidget {
  final Widget child;
  const _Info_Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E2DA)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Meta_Tag extends StatelessWidget {
  final String text;
  final IconData icon;
  const _Meta_Tag({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFE8E2DA)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF111111)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
        ],
      ),
    );
  }
}

class _Circle_Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _Circle_Btn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE8E2DA)),
        ),
        child: Icon(icon, color: const Color(0xFF111111)),
      ),
    );
  }
}
