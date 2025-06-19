import 'package:flutter/material.dart';
// import 'package:camera/camera.dart'; // Commented out camera import
import 'dart:math' as math;
import 'batch.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final cameras = await availableCameras(); // Commented out camera initialization
  runApp(CoffeeQCApp()); // Removed cameras parameter
}

class CoffeeQCApp extends StatelessWidget {
  // final List<CameraDescription> cameras; // Commented out camera parameter

  const CoffeeQCApp({Key? key}) : super(key: key); // Removed required cameras parameter

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee QC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MainScreen(), // Removed cameras parameter
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  // final List<CameraDescription> cameras; // Commented out camera parameter

  const MainScreen({Key? key}) : super(key: key); // Removed required cameras parameter

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  // Dummy data for pending batches
  final List<BatchData> pendingBatches = [
    BatchData('BATCH 2024-001', 'Premium Coffee Beans', 'Moisture test', 'Factory A - Storage Bay 2', '2 hours', Colors.orange),
    BatchData('BATCH 2024-002', 'Robusta Coffee Beans', 'Density Test', 'Factory B - Storage Bay 3', '2 hours', Colors.orange),
    BatchData('BATCH 2024-003', 'Green Coffee Beans', 'Size Test', 'Factory C - Storage Bay 1', '4 hours', Colors.red),
    BatchData('BATCH 2024-004', 'Arabica Coffee Beans', 'Quality Test', 'Factory D - Storage Bay 4', '1 hour', Colors.green),
    BatchData('BATCH 2024-005', 'Espresso Coffee Beans', 'Aroma Test', 'Factory A - Storage Bay 5', '3 hours', Colors.orange),
    BatchData('BATCH 2024-006', 'Blend Coffee Beans', 'Color Test', 'Factory B - Storage Bay 2', '5 hours', Colors.red),
    BatchData('BATCH 2024-007', 'Organic Coffee Beans', 'Purity Test', 'Factory C - Storage Bay 3', '30 minutes', Colors.green),
  ];

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _waveAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_waveController);
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) { // Tasks tab - navigate to batch screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BatchScreen(),
        ),
      );
    } else if (index == 2) { // Scanner tab
      _openCamera();
    }
  }
  void _openCamera() async {
    // Camera functionality commented out - showing placeholder instead
    /*
    if (widget.cameras.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: widget.cameras.first),
        ),
      );
    }
    */

    // Show placeholder dialog instead of opening camera
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Scanner'),
          content: Text('Camera functionality is temporarily disabled.\nThis would normally open the QR/Barcode scanner.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  _buildWaveBackground(),
                  _buildContent(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 16,
            backgroundColor: Colors.blue,
            child: Text('N', style: TextStyle(color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(width: 12),
          const Text(
            'Good Morning, Nikhil',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
         
        ],
      ),
    );
  }

  Widget _buildWaveBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WavePainter(_waveAnimation.value),
            size: Size.infinite,
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildPendingBatchesSection(),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        int crossAxisCount = isMobile ? 2 : 4;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.2 : 1.0,
          children: [
            _buildStatCard('112', 'Total Certified lots', Colors.green, Icons.check_circle),
            _buildStatCard('3', 'Pending Inspection', Colors.orange, Icons.access_time),
            _buildStatCard('1', 'Failed Batches', Colors.red, Icons.error),
            _buildStatCard('12', 'Certificates this month', Colors.blue, Icons.description),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPendingBatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pending batches',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 400, // Fixed height for scrollable area
          child: ListView.builder(
            itemCount: pendingBatches.length,
            itemBuilder: (context, index) {
              return _buildBatchCard(pendingBatches[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBatchCard(BatchData batch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                batch.batchId,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: batch.statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Due in ${batch.dueTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: batch.statusColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            batch.productName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            batch.testType,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  batch.location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View map',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.brown,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 24),
            ),
            label: 'My scanner',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.description),
            label: 'Reports',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    final waveHeight = 30.0;
    final waveLength = size.width / 2;

    path.moveTo(0, size.height * 0.8);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.8 +
          waveHeight * math.sin((x / waveLength * 2 * math.pi) + animationValue);
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave
    final paint2 = Paint()
      ..color = Colors.cyan.withOpacity(0.05)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.85);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.85 +
          waveHeight * 0.7 * math.sin((x / waveLength * 2 * math.pi) + animationValue + math.pi / 4);
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

class BatchData {
  final String batchId;
  final String productName;
  final String testType;
  final String location;
  final String dueTime;
  final Color statusColor;

  BatchData(this.batchId, this.productName, this.testType, this.location, this.dueTime, this.statusColor);
}

// CAMERA SCREEN CLASS - COMPLETELY COMMENTED OUT
/*
class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Center(
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Picture saved: ${image.path}')),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
*/