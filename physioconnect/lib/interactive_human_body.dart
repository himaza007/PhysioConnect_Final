import 'package:flutter/material.dart';
import 'main_body_part_page.dart';

class InteractiveHumanBody extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const InteractiveHumanBody({
    Key? key, 
    required this.toggleTheme, 
    required this.isDarkMode
  }) : super(key: key);

  @override
  State<InteractiveHumanBody> createState() => _InteractiveHumanBodyState();
}

class _InteractiveHumanBodyState extends State<InteractiveHumanBody> with SingleTickerProviderStateMixin {
  String currentView = 'front';
  bool isMale = true;
  
  // Animation controller for sophisticated animations
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void changeView(String view) {
    setState(() {
      currentView = view;
      
      // Trigger animation
      _animationController.forward(from: 0);
    });
  }

  void toggleGender() {
    setState(() {
      isMale = !isMale;
      // Add a subtle animation when toggling gender
      _animationController.forward(from: 0);
    });
  }

  void navigateToMainBodyPart(String bodyPart) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, animation, secondaryAnimation) => 
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), 
              end: Offset.zero
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOutQuart,
            )),
            child: MainBodyPartPage(
              bodyPart: bodyPart,
              isDarkMode: widget.isDarkMode,
            ),
          ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isDarkMode 
        ? const Color(0xFF121212) 
        : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Advanced App Bar
            _buildAdvancedAppBar(),
            
            // View and Gender Selection
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildViewChips(),
                  _buildGenderToggle(),
                ],
              ),
            ),

            // Expandable Body Visualization
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // Interactive Body Visualization
                  Center(
                    child: _buildBodyVisualization(),
                  ),
                  
                  // Gradient Overlay
                  Positioned.fill(
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              widget.isDarkMode 
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Advanced Body Part Selector
            _buildAdvancedBodyPartSelector(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'PhysioConnect',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Pro',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.isDarkMode 
                    ? Colors.tealAccent 
                    : Colors.teal.shade700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Row(
            children: [
              // Notification Icon
              Icon(
                Icons.notifications_outlined,
                color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                size: 28,
              ),
              const SizedBox(width: 16),
              // Theme Toggle
              GestureDetector(
                onTap: widget.toggleTheme,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: widget.isDarkMode 
                      ? Colors.white12 
                      : Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    color: widget.isDarkMode ? Colors.white70 : Colors.black87,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewChips() {
    final viewOptions = [
      {'label': 'Front', 'view': 'front'},
      {'label': 'Back', 'view': 'back'},
      {'label': 'Side', 'view': 'side_right'},
    ];

    return Row(
      children: viewOptions.map((option) => 
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: _buildViewChip(
            option['label'] as String, 
            currentView == option['view'], 
            () => changeView(option['view'] as String)
          ),
        )
      ).toList(),
    );
  }

  Widget _buildGenderToggle() {
    return GestureDetector(
      onTap: toggleGender,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: widget.isDarkMode 
            ? Colors.white12 
            : Colors.black12,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              isMale ? Icons.male : Icons.female,
              color: widget.isDarkMode 
                ? (isMale ? Colors.blueAccent : Colors.pinkAccent)
                : (isMale ? Colors.blue : Colors.pink),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isMale ? 'Male' : 'Female',
              style: TextStyle(
                color: widget.isDarkMode 
                  ? Colors.white70 
                  : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

    Widget _buildBodyVisualization() {
    // Placeholder for body visualization
    // You can replace this with your actual body visualization method
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: widget.isDarkMode ? Colors.black26 : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Human Body Model Image (Dynamic based on gender & view)
          Image.asset(
            isMale
                ? (currentView == 'front'
                    ? 'assets/images/front.png'
                    : currentView == 'back'
                        ? 'assets/images/back.png'
                        : 'assets/images/side_right.png')
                : (currentView == 'front'
                    ? 'assets/images/front_female.png'
                    : currentView == 'back'
                        ? 'assets/images/back_female.png'
                        : 'assets/images/side_female.png'),
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildViewChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
            ? (widget.isDarkMode ? const Color(0xFF2C2C2C) : Colors.blue.shade50)
            : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
              ? (widget.isDarkMode ? Colors.white24 : Colors.blue.shade100)
              : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected 
              ? (widget.isDarkMode ? Colors.white : Colors.blue)
              : (widget.isDarkMode ? Colors.white70 : Colors.black54),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedBodyPartSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: widget.isDarkMode 
          ? const Color(0xFF1E1E1E) 
          : Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _getBodyParts().map((bodyPart) => 
            _buildBodyPartButton(bodyPart)
          ).toList(),
        ),
      ),
    );
  }

  Widget _buildBodyPartButton(String bodyPart) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => navigateToMainBodyPart(bodyPart),
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.isDarkMode 
            ? Colors.white12 
            : Colors.black12,
          foregroundColor: widget.isDarkMode ? Colors.white70 : Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(bodyPart),
      ),
    );
  }

  List<String> _getBodyParts() {
    return currentView == 'front'
      ? ['Head', 'Chest', 'Abdomen', 'Arms', 'Legs']
      : ['Upper Back', 'Lower Back', 'Shoulders', 'Glutes', 'Hamstrings'];
  }
}