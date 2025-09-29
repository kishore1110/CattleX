import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../data/cattle_breeds.dart';
import '../data/buffalo_breeds.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'Cattle'; // Default category
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  bool _showAllBreeds = false; // Track if all breeds should be shown

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Enhanced Professional App Bar with Government Branding
          SliverAppBar(
            expandedHeight: 330,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primaryGreen,
            leadingWidth: 80, // Give more space for the logo
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: 0.9,
                child: _buildHeaderSection(context),
              ),
            ),
            leading: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/innerLogo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            title: const Text(
              'CattleX',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
            ],
          ),

          // Enhanced Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.backgroundLight, Colors.white],
                  stops: const [0.0, 0.1],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Enhanced Breed Database Section
                    _buildSectionHeader(
                      context,
                      'Breed Information',
                      'View All',
                    ),
                    const SizedBox(height: 16),

                    // Category Selector - only show when not searching
                    if (!_isSearching) ...[
                      _buildCategorySelector(),
                      const SizedBox(height: 20),
                    ] else ...[
                      const SizedBox(height: 8),
                    ],

                    _buildBreedCardsSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryGreen,
            AppColors.accentGreen,
            AppColors.primaryGreenDark,
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryGreenDark.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Welcome Message Section
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.agriculture,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome to CattleX',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your digital companion for livestock management',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Discover comprehensive breed information, utilize AI-powered identification tools, and test your knowledge with our interactive quiz system.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Enhanced Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                      _isSearching = value.isNotEmpty;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search breed information...',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    prefixIcon: const Icon(
                      Icons.search,
                      color: AppColors.primaryGreen,
                      size: 24,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppColors.textLight,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                                _isSearching = false;
                              });
                            },
                          )
                        : null,
                    hintStyle: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            actionText,
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = 'Cattle';
                  _showAllBreeds =
                      false; // Reset load more state when switching categories
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedCategory == 'Cattle'
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.cow,
                      color: _selectedCategory == 'Cattle'
                          ? Colors.white
                          : AppColors.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Cattle',
                      style: TextStyle(
                        color: _selectedCategory == 'Cattle'
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: _selectedCategory == 'Cattle'
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCategory = 'Buffalo';
                  _showAllBreeds =
                      false; // Reset load more state when switching categories
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: _selectedCategory == 'Buffalo'
                      ? AppColors.primaryGreen
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/buffalo.svg',
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        _selectedCategory == 'Buffalo'
                            ? Colors.white
                            : AppColors.textSecondary,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Buffalo',
                      style: TextStyle(
                        color: _selectedCategory == 'Buffalo'
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: _selectedCategory == 'Buffalo'
                            ? FontWeight.w600
                            : FontWeight.normal,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreedCardsSection(BuildContext context) {
    // Get breeds from separate data files
    final cattleBreeds = CattleBreeds.getCattleBreeds();
    final buffaloBreeds = BuffaloBreeds.getBuffaloBreeds();

    // Get breeds based on category
    List<Map<String, String>> allBreeds = _selectedCategory == 'Cattle'
        ? cattleBreeds
        : buffaloBreeds;

    // Filter breeds based on search query
    List<Map<String, String>> filteredBreeds = allBreeds;
    if (_searchQuery.isNotEmpty) {
      // Search across both categories when searching (search all breeds)
      List<Map<String, String>> allBreedsForSearch = [
        ...cattleBreeds,
        ...buffaloBreeds,
      ];
      filteredBreeds = allBreedsForSearch.where((breed) {
        return breed['title']!.toLowerCase().contains(_searchQuery) ||
            breed['description']!.toLowerCase().contains(_searchQuery);
      }).toList();
    } else {
      // When not searching, limit to first 4 breeds unless 'Load more' is clicked
      if (!_showAllBreeds) {
        filteredBreeds = allBreeds.take(4).toList();
      }
    }

    // Show search results or no results message
    if (_isSearching && filteredBreeds.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(Icons.search_off, size: 64, color: AppColors.textLight),
            const SizedBox(height: 16),
            Text(
              'No breeds found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try searching with different keywords or check the other category.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textLight),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Show search results count if searching
        if (_isSearching)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Icon(Icons.search, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  '${filteredBreeds.length} result${filteredBreeds.length != 1 ? 's' : ''} found for "$_searchQuery"',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),

        // Display filtered breeds
        for (int i = 0; i < filteredBreeds.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildBreedCard(
                    filteredBreeds[i]['title']!,
                    filteredBreeds[i]['description']!,
                    filteredBreeds[i]['image']!,
                    filteredBreeds[i]['yield']!,
                    () => _showBreedDetails(context, filteredBreeds[i]),
                  ),
                ),
                const SizedBox(width: 16),
                if (i + 1 < filteredBreeds.length)
                  Expanded(
                    child: _buildBreedCard(
                      filteredBreeds[i + 1]['title']!,
                      filteredBreeds[i + 1]['description']!,
                      filteredBreeds[i + 1]['image']!,
                      filteredBreeds[i + 1]['yield']!,
                      () => _showBreedDetails(context, filteredBreeds[i + 1]),
                    ),
                  )
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),

        // Load More Button (only show when not searching and there are more breeds to show)
        if (!_isSearching && !_showAllBreeds && allBreeds.length > 4)
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _showAllBreeds = true;
                  });
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen,
                  side: const BorderSide(color: AppColors.primaryGreen),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.expand_more, size: 20),
                label: Text(
                  'Load More $_selectedCategory Breeds (${allBreeds.length - 4} more)',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

        // Common Learn More Button for Cattle and Buffalo
        if (!_isSearching)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final url = _selectedCategory == 'Cattle'
                      ? 'https://dahd.gov.in/pashupedia-cattle-breed'
                      : 'https://dahd.gov.in/pashupedia-buffalo-breed';
                  await _launchURL(context, url);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.open_in_new, size: 20),
                label: Text(
                  'Learn More About $_selectedCategory Breeds',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBreedCard(
    String title,
    String description,
    String imagePath,
    String yield,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                      letterSpacing: 0.2,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBreedDetails(BuildContext context, Map<String, String> breed) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Image
                  Container(
                    height: 180,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(breed['image']!),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Gradient overlay for better text visibility
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                        // Close button
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          breed['title']!,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Yield Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.success,
                                AppColors.secondaryGreen,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Milk Yield: ${breed['yield']}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Description
                        Text(
                          'About this Breed',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Detailed Description with Fixed Height and Scroll
                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.backgroundLight,
                          ),
                          child: SingleChildScrollView(
                            child: RichText(
                              text: _getDetailedDescriptionRich(
                                breed['title']!,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Close Button Only
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryGreen,
                              side: const BorderSide(
                                color: AppColors.primaryGreen,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: const Text('Close'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  TextSpan _getDetailedDescriptionRich(String breedName) {
    String description = _getDetailedDescription(breedName);
    List<TextSpan> spans = [];

    // Split by lines and format headings
    List<String> lines = description.split('\n');

    for (String line in lines) {
      if (line.contains(':') &&
          (line.startsWith('Colour:') ||
              line.startsWith('Horn Shape & Size:') ||
              line.startsWith('Characteristics:') ||
              line.startsWith('Visible Characteristic:') ||
              line.startsWith('Origin:') ||
              line.startsWith('Physical Features:') ||
              line.startsWith('Special Qualities:'))) {
        // Split heading and content
        List<String> parts = line.split(':');
        if (parts.length >= 2) {
          // Add heading in black
          spans.add(
            TextSpan(
              text: '${parts[0]}:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.6,
              ),
            ),
          );

          // Add content in gray
          spans.add(
            TextSpan(
              text: ' ${parts.sublist(1).join(':')}',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
          );
        }
      } else {
        // Regular text
        spans.add(
          TextSpan(
            text: line,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        );
      }

      // Add line break except for last line
      if (line != lines.last) {
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return TextSpan(children: spans);
  }

  String _getDetailedDescription(String breedName) {
    // Check if it's a cattle breed
    final cattleDescription = CattleBreeds.getDetailedDescription(breedName);
    if (cattleDescription != CattleBreeds.getDetailedDescription('Unknown')) {
      return cattleDescription;
    }

    // Check if it's a buffalo breed
    final buffaloDescription = BuffaloBreeds.getDetailedDescription(breedName);
    if (buffaloDescription != BuffaloBreeds.getDetailedDescription('Unknown')) {
      return buffaloDescription;
    }

    // Default fallback
    return 'Detailed information about this breed will be available soon. Please visit the official Pashupedia website for more comprehensive breed information.';
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Try to launch the URL directly
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // If direct launch fails, try with different mode
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      // If URL launching fails, show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open website: $e'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}
