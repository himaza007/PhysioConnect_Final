import 'package:flutter/material.dart';
import 'selected_muscles_page.dart';

class MuscleSelectionPage extends StatefulWidget {
  final String bodyPart;
  final bool isDarkMode;
  final List<String> previouslySelectedBodyParts;
  final List<String> previouslySelectedMuscles;
  final Function(List<String>, List<String>) onSelectionComplete;

  const MuscleSelectionPage({
    Key? key,
    required this.bodyPart,
    required this.isDarkMode,
    this.previouslySelectedBodyParts = const [],
    this.previouslySelectedMuscles = const [],
    required this.onSelectionComplete,
  }) : super(key: key);

  @override
  State<MuscleSelectionPage> createState() => _MuscleSelectionPageState();
}

class _MuscleSelectionPageState extends State<MuscleSelectionPage> {
  List<String> selectedMuscles = [];
  late List<String> previousBodyParts;
  late List<String> previousMuscles;

  @override
  void initState() {
    super.initState();
    // Initialize with previously selected muscles and body parts
    selectedMuscles = List.from(widget.previouslySelectedMuscles);
    previousBodyParts = List.from(widget.previouslySelectedBodyParts);
    
    // Add current body part if not already in the list
    if (!previousBodyParts.contains(widget.bodyPart)) {
      previousBodyParts.add(widget.bodyPart);
    }
  }

  // Updated muscle data with comprehensive lists
  final Map<String, List<String>> muscleData = {
    "Head": [
      "Clavicular Head of Sternocleidomastoid",
      "Orbicularis Oculi",
      "Temporalis Muscle",
      "Masseter Muscle",
      "Platysma Muscle",
      "Zygomaticus Major",
      "Frontalis Muscle",
      "Occipitalis Muscle",
    ],
    "Chest": [
      "Pectoralis Major",
      "Pectoralis Minor",
      "Serratus Anterior",
      "Intercostal Muscles",
    ],
    "Abdomen": [
      "Rectus Abdominis",
      "External Oblique",
      "Internal Oblique",
      "Transversus Abdominis",
    ],
    "Arms": [
      "Biceps Brachii",
      "Triceps Brachii",
      "Deltoid",
      "Brachialis",
      "Forearm Muscles",
    ],
    "Legs": [
      "Quadriceps",
      "Hamstrings",
      "Calves",
      "Glutes",
    ],
    "Upper Back": [
      "Trapezius",
      "Rhomboids",
      "Latissimus Dorsi",
      "Infraspinatus",
    ],
    "Lower Back": [
      "Erector Spinae",
      "Quadratus Lumborum",
      "Multifidus",
    ],
    "Shoulders": [
      "Rotator Cuff Muscles",
      "Deltoid",
      "Supraspinatus",
    ],
    "Glutes": [
      "Gluteus Maximus",
      "Gluteus Medius",
      "Gluteus Minimus",
    ],
    "Hamstrings": [
      "Biceps Femoris",
      "Semitendinosus",
      "Semimembranosus",
    ],
  };

  String getMuscleImagePath(String bodyPart, int index) {
    final folderMap = {
      "Head": "Head",
      "Chest": "Area2",
      "Abdomen": "abdomen",
      "Arms": "Area4",
      "Legs": "Area3",
      "Upper Back": "back_muscles",
      "Lower Back": "back_muscles",
      "Shoulders": "Area2",
      "Glutes": "Area3",
      "Hamstrings": "Area3",
    };

    final folder = folderMap[bodyPart] ?? "Head";
    // Ensure index is within range
    final safeIndex = index % 10 + 1;
    return 'assets/body_parts/$folder/muscles/$safeIndex.avif';
  }

  void toggleMuscleSelection(String muscle) {
    setState(() {
      if (selectedMuscles.contains(muscle)) {
        selectedMuscles.remove(muscle);
      } else {
        selectedMuscles.add(muscle);
      }
    });
  }

  void proceedToNextBodyPart() {
    // If no muscles selected for current body part, show a warning
    if (selectedMuscles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one muscle'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show a modal to choose the next body part
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // Filter out already selected body parts
        final availableBodyParts = [
          'Head', 'Chest', 'Abdomen', 'Arms', 'Legs', 
          'Upper Back', 'Lower Back', 'Shoulders', 'Glutes', 'Hamstrings'
        ].where((part) => !previousBodyParts.contains(part)).toList();

        return ListView(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Next Body Part',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            ...availableBodyParts.map((bodyPart) => ListTile(
                  title: Text(bodyPart),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MuscleSelectionPage(
                          bodyPart: bodyPart,
                          isDarkMode: widget.isDarkMode,
                          previouslySelectedBodyParts: previousBodyParts,
                          previouslySelectedMuscles: selectedMuscles,
                          onSelectionComplete: widget.onSelectionComplete,
                        ),
                      ),
                    );
                  },
                )).toList(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Finish selection and go to selected muscles page
                  Navigator.pop(context);
                  widget.onSelectionComplete(previousBodyParts, selectedMuscles);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectedMusclesPage(
                        selectedBodyParts: previousBodyParts,
                        selectedMuscles: selectedMuscles,
                        isDarkMode: widget.isDarkMode,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF33724B),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text(
                  'Finish Muscle Selection',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final muscles = muscleData[widget.bodyPart] ?? [];

    // Handle case with no muscles
    if (muscles.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('${widget.bodyPart} Muscles'),
          backgroundColor: const Color(0xFF33724B),
        ),
        body: Center(
          child: Text(
            'No muscles found for ${widget.bodyPart}',
            style: const TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: widget.isDarkMode 
        ? const Color(0xFF06130D) 
        : const Color(0xFFEAF7FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF33724B),
        title: Text(
          '${widget.bodyPart} Muscles',
          style: const TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.w600, 
            color: Colors.white
          ),
        ),
        actions: [
          if (selectedMuscles.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                label: Text(
                  '${selectedMuscles.length} Selected',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: const Color(0xFF1F5F3A),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: muscles.length,
              itemBuilder: (context, index) {
                final muscle = muscles[index];
                final imagePath = getMuscleImagePath(widget.bodyPart, index);
                
                return _buildMuscleCard(
                  muscle: muscle, 
                  imagePath: imagePath,
                  isSelected: selectedMuscles.contains(muscle),
                  onTap: () => toggleMuscleSelection(muscle),
                );
              },
            ),
          ),
          // Proceed to Next Body Part or Finish Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: proceedToNextBodyPart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF33724B),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40, 
                  vertical: 15
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                selectedMuscles.isEmpty 
                  ? 'Select Muscles' 
                  : 'Next Body Part (${selectedMuscles.length} Selected)',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reuse existing _buildMuscleCard method from previous implementation
  Widget _buildMuscleCard({
    required String muscle, 
    required String imagePath, 
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected 
            ? const Color(0xFF33724B).withOpacity(0.2)
            : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(
            color: isSelected 
              ? const Color(0xFF33724B) 
              : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $imagePath');
                    return const Center(
                      child: Icon(
                        Icons.broken_image, 
                        color: Colors.grey, 
                        size: 50
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        muscle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isSelected 
                            ? const Color(0xFF33724B) 
                            : Colors.black87,
                        ),
                      ),
                    ),
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => onTap(),
                      activeColor: const Color(0xFF33724B),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}