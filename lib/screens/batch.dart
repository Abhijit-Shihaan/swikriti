import 'package:flutter/material.dart';

class BatchScreen extends StatefulWidget {
  @override
  _BatchScreenState createState() => _BatchScreenState();
}

class _BatchScreenState extends State<BatchScreen> with TickerProviderStateMixin {
  int _selectedTab = 0; // 0: Pending, 1: Completed, 2: Failed

  // Sample batch data
  final List<CompletedBatch> completedBatches = [
    CompletedBatch('BATCH 2024-001', 'Premium Coffee Beans', 'Moisture test', 'Factory A - Storage Bay 2', 'Certified'),
    CompletedBatch('BATCH 2024-002', 'Premium Coffee Beans', 'Moisture test', 'Factory A - Storage Bay 2', 'Certified'),
  ];

  final List<BatchData> pendingBatches = [
    BatchData('BATCH 2024-003', 'Green Coffee Beans', 'Size Test', 'Factory C - Storage Bay 1', '4 hours', Colors.red),
    BatchData('BATCH 2024-004', 'Arabica Coffee Beans', 'Quality Test', 'Factory D - Storage Bay 4', '1 hour', Colors.green),
  ];

  final List<BatchData> failedBatches = [
    BatchData('BATCH 2024-005', 'Espresso Coffee Beans', 'Aroma Test', 'Factory A - Storage Bay 5', 'Failed', Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: _buildTabContent(),
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
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
          const Text(
            'My Batches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Icon(Icons.filter_list, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: [
          _buildTab('Pending', 0),
          _buildTab('Completed', 1),
          _buildTab('Failed', 2),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.brown : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.brown : Colors.grey,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 0:
        return _buildPendingTab();
      case 1:
        return _buildCompletedTab();
      case 2:
        return _buildFailedTab();
      default:
        return _buildPendingTab();
    }
  }

  Widget _buildPendingTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: pendingBatches.length,
      itemBuilder: (context, index) {
        return _buildPendingBatchCard(pendingBatches[index]);
      },
    );
  }

  Widget _buildCompletedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: completedBatches.length,
      itemBuilder: (context, index) {
        return _buildCompletedBatchCard(completedBatches[index]);
      },
    );
  }

  Widget _buildFailedTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: failedBatches.length,
      itemBuilder: (context, index) {
        return _buildPendingBatchCard(failedBatches[index]);
      },
    );
  }

  Widget _buildPendingBatchCard(BatchData batch) {
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
                  batch.dueTime.contains('hour') ? 'Due in ${batch.dueTime}' : batch.dueTime,
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

  Widget _buildCompletedBatchCard(CompletedBatch batch) {
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
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  batch.status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.brown,
                side: const BorderSide(color: Colors.brown),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('View Certificate'),
            ),
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
        currentIndex: 1, // Tasks tab is selected for batch screen
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context); // Go back to home
          }
          // Handle other navigation as needed
        },
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

class BatchData {
  final String batchId;
  final String productName;
  final String testType;
  final String location;
  final String dueTime;
  final Color statusColor;

  BatchData(this.batchId, this.productName, this.testType, this.location, this.dueTime, this.statusColor);
}

class CompletedBatch {
  final String batchId;
  final String productName;
  final String testType;
  final String location;
  final String status;

  CompletedBatch(this.batchId, this.productName, this.testType, this.location, this.status);
}