class OnboardingItem {
  final String imagePath1;
  final String imagePath2;
  final String title;
  final String description;

  OnboardingItem({
    required this.imagePath1,
    required this.imagePath2,
    required this.title,
    required this.description,
  });
}

final List<OnboardingItem> onboardingItems = [
  OnboardingItem(
    imagePath1: 'assets/images/placeholder.png',
    imagePath2: 'assets/images/placeholder.png',
    title: 'Plan Your Trip',
    description: 'Create personalized itineraries in minutes, with routes optimized between every stop you want to visit.',
  ),
  OnboardingItem(
    imagePath1: 'assets/images/placeholder.png',
    imagePath2: 'assets/images/placeholder.png',
    title: 'Discover New Places',
    description: 'Explore recommended destinations, hidden gems, and local favorites tailored to your interests.',
  ),
  OnboardingItem(
    imagePath1: 'assets/images/placeholder.png',
    imagePath2: 'assets/images/placeholder.png',
    title: 'Travel Smarter',
    description: 'Track your schedule, manage bookings, and get real-time updates so every trip runs smoothly.',
  ),
];
