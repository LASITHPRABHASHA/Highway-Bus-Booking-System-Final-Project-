import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BusBookingScreen extends StatefulWidget {
  final Map<String, dynamic> busData;
  final String apiUrl = 'http://10.11.3.159:4242'; // Change to your API URL

  const BusBookingScreen({
    super.key,
    required this.busData,
  });

  @override
  State<BusBookingScreen> createState() => _BusBookingScreenState();
}

class _BusBookingScreenState extends State<BusBookingScreen> {
  final List<int> selectedSeats = [];
  List<int> bookedSeats = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Convert the booked seats from API to List<int>
    bookedSeats = List<int>.from(widget.busData['Booked_Seats_Number'] ?? []);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Bus Seats'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Bus Info Section
              _buildBusInfo(),

              // Seats Section
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      BusSeatLayout(
                        selectedSeats: selectedSeats,
                        bookedSeats: bookedSeats,
                        onSeatSelected: _handleSeatSelection,
                        totalSeats: widget.busData['Total_Seats'] ?? 49,
                      ),
                      const SizedBox(height: 20),
                      _buildSeatLegend(),
                    ],
                  ),
                ),
              ),

              // Bottom Bar
              _buildBottomBar(),
            ],
          ),

          // Loading Overlay
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBusInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bus: ${widget.busData['Bus_Name']}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Route: ${widget.busData['Start_Location']} to ${widget.busData['End_Location']}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Time: ${widget.busData['Start_Time']}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Date: ${widget.busData['Journey_Date']}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final double seatPrice = widget.busData['Ticket_Price'].toDouble();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selected Seats: ${selectedSeats.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total: LKR ${(selectedSeats.length * seatPrice).toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: selectedSeats.isEmpty ? null : _handleBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              'Book Seats',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSeatSelection(int seatNumber) {
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  void _handleBooking() async {
    if (selectedSeats.isEmpty) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bus: ${widget.busData['Bus_Name']}'),
                Text('From: ${widget.busData['Start_Location']}'),
                Text('To: ${widget.busData['End_Location']}'),
                Text('Date: ${widget.busData['Journey_Date']}'),
                Text('Time: ${widget.busData['Start_Time']}'),
                Text('Selected Seats: ${selectedSeats.join(", ")}'),
                Text('Price per seat: LKR ${widget.busData['Ticket_Price']}'),
                const SizedBox(height: 8),
                Text(
                  'Total Amount: LKR ${(selectedSeats.length * widget.busData['Ticket_Price']).toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _processPayment();
              },
              child: const Text('Proceed to Payment'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _processPayment() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create the booking data

      // Create the URL for the checkout session
      final Uri checkoutUrl =
          Uri.parse('${widget.apiUrl}/create-checkout-session');

      // Launch the URL in the default browser
      if (!await launchUrl(
        checkoutUrl,
        mode: LaunchMode.externalApplication,
      )) {
        throw Exception('Could not launch payment page');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redirecting to payment page...'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}

class BusSeatLayout extends StatelessWidget {
  final Function(int) onSeatSelected;
  final List<int> selectedSeats;
  final List<int> bookedSeats;
  final int totalSeats;

  const BusSeatLayout({
    super.key,
    required this.onSeatSelected,
    required this.selectedSeats,
    required this.bookedSeats,
    required this.totalSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Front indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'FRONT',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main seat layout
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Left side seats (2 columns)
              Column(
                children: [
                  Row(
                    children: [
                      _buildSeatColumn(1, 41, 4), // First column
                      const SizedBox(width: 8),
                      _buildSeatColumn(2, 42, 4), // Second column
                    ],
                  ),
                ],
              ),

              // Aisle
              const SizedBox(width: 24),

              // Right side seats (2 columns)
              Column(
                children: [
                  Row(
                    children: [
                      _buildSeatColumn(3, 43, 4), // Third column
                      const SizedBox(width: 8),
                      _buildSeatColumn(4, 44, 4), // Fourth column
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Last row
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 45; i <= totalSeats; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildSeat(i),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSeatColumn(int startNum, int maxNum, int increment) {
    return Column(
      children: [
        for (int i = startNum; i <= maxNum; i += increment)
          Padding(
            padding: const EdgeInsets.all(4),
            child: _buildSeat(i),
          ),
      ],
    );
  }

  Widget _buildSeat(int seatNumber) {
    if (seatNumber > totalSeats) return const SizedBox(width: 40, height: 40);

    bool isSelected = selectedSeats.contains(seatNumber);
    bool isBooked = bookedSeats.contains(seatNumber);

    return GestureDetector(
      onTap: isBooked ? null : () => onSeatSelected(seatNumber),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey
              : isSelected
                  ? Colors.orange
                  : Colors.white,
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            seatNumber.toString(),
            style: TextStyle(
              color: isSelected || isBooked ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildSeatLegend() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem('Available', Colors.white),
        _buildLegendItem('Selected', Colors.orange),
        _buildLegendItem('Booked', Colors.grey),
      ],
    ),
  );
}

Widget _buildLegendItem(String label, Color color) {
  return Row(
    children: [
      Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        label,
        style: const TextStyle(color: Colors.black),
      ),
    ],
  );
}
