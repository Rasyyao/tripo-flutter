import 'package:flutter/material.dart';
import 'package:tripo/theme/app_colors.dart';

class ForumTab extends StatefulWidget {
  const ForumTab({super.key});

  @override
  State<ForumTab> createState() => _ForumTabState();
}

class _ForumTabState extends State<ForumTab> {
  int _likes1 = 342;
  bool _isLiked1 = false;
  int _likes2 = 512;
  bool _isLiked2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Traveler Forum 🌍",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Share itineraries and clone plans",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          "Share",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Forum Post 1
              ForumCard(
                author: "Sarah Jenkins",
                badge: "Top Explorer",
                timeAgo: "2h ago",
                title: "The Ultimate 5-Day Bali Hidden Waterfalls & Cafes 🌴",
                description:
                    "Visited Tegenungan, Tibumana, and all secret spots in Ubud. Full daily schedule and scooter rental tips included!",
                tags: const ["#Bali", "#Waterfalls", "#Budget"],
                likes: _likes1,
                comments: 48,
                isLiked: _isLiked1,
                onLike: () {
                  setState(() {
                    _isLiked1 = !_isLiked1;
                    _likes1 += _isLiked1 ? 1 : -1;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Forum Post 2
              ForumCard(
                author: "Alex Rivera",
                badge: "Solo Traveler",
                timeAgo: "5h ago",
                title: "3-Day Swiss Alps Scenic Train & Glacier Route 🏔️",
                description:
                    "How to take the Glacier Express on a budget, best photo spots at Zermatt, and Matterhorn hiking itinerary.",
                tags: const ["#Switzerland", "#Alps", "#Trains"],
                likes: _likes2,
                comments: 82,
                isLiked: _isLiked2,
                onLike: () {
                  setState(() {
                    _isLiked2 = !_isLiked2;
                    _likes2 += _isLiked2 ? 1 : -1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ForumCard extends StatelessWidget {
  const ForumCard({
    super.key,
    required this.author,
    required this.badge,
    required this.timeAgo,
    required this.title,
    required this.description,
    required this.tags,
    required this.likes,
    required this.comments,
    required this.isLiked,
    required this.onLike,
  });

  final String author;
  final String badge;
  final String timeAgo;
  final String title;
  final String description;
  final List<String> tags;
  final int likes;
  final int comments;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight.withOpacity(0.2),
                child: Text(
                  author[0],
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      author,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    const Text(
                      " • ",
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Clone Plan",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            children: tags.map((tag) {
              return Text(
                tag,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          const Divider(),
          Row(
            children: [
              GestureDetector(
                onTap: onLike,
                child: Row(
                  children: [
                    Icon(
                      isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 18,
                      color: isLiked ? AppColors.error : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      "",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Icon(Icons.chat_bubble_outline_rounded, size: 17, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  const Text(
                    "",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.share_outlined, size: 18, color: AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }
}
