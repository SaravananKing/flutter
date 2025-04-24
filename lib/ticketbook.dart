import 'package:flutter/material.dart';

void main() {
  runApp(TicketBookingApp());
}

class TicketBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ticket Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: TicketListScreen(),
    );
  }
}

class Ticket {
  String name;
  String destination;
  DateTime journeyDate;

  Ticket({required this.name, required this.destination, required this.journeyDate});
}

class TicketListScreen extends StatefulWidget {
  @override
  _TicketListScreenState createState() => _TicketListScreenState();
}

class _TicketListScreenState extends State<TicketListScreen> {
  List<Ticket> tickets = [];

  void _addOrEditTicket({Ticket? ticket, int? index}) async {
    final result = await showDialog<Ticket>(
      context: context,
      builder: (context) => TicketDialog(ticket: ticket),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          tickets[index] = result;
        } else {
          tickets.add(result);
        }
      });
    }
  }

  void _deleteTicket(int index) {
    setState(() {
      tickets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Booking')),
      body: tickets.isEmpty
          ? Center(child: Text('No tickets booked'))
          : ListView.builder(
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          return Card(
            child: ListTile(
              title: Text(ticket.name),
              subtitle: Text('${ticket.destination}\n${ticket.journeyDate.toLocal().toString().split(' ')[0]}'),
              onTap: () => _addOrEditTicket(ticket: ticket, index: index),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteTicket(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addOrEditTicket(),
      ),
    );
  }
}

class TicketDialog extends StatefulWidget {
  final Ticket? ticket;
  TicketDialog({this.ticket});

  @override
  _TicketDialogState createState() => _TicketDialogState();
}

class _TicketDialogState extends State<TicketDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _destinationController;
  late TextEditingController _journeyDateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.ticket?.name ?? '');
    _destinationController = TextEditingController(text: widget.ticket?.destination ?? '');
    _journeyDateController = TextEditingController(
        text: widget.ticket != null ? widget.ticket!.journeyDate.toLocal().toString().split(' ')[0] : '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _destinationController.dispose();
    _journeyDateController.dispose();
    super.dispose();
  }

  void _saveTicket() {
    if (_formKey.currentState!.validate()) {
      final dateParts = _journeyDateController.text.split('-');
      if (dateParts.length == 3) {
        final newTicket = Ticket(
          name: _nameController.text,
          destination: _destinationController.text,
          journeyDate: DateTime(
            int.parse(dateParts[0]), // Year
            int.parse(dateParts[1]), // Month
            int.parse(dateParts[2]), // Day
          ),
        );
        Navigator.pop(context, newTicket);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid date in YYYY-MM-DD format')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.ticket == null ? 'Book Ticket' : 'Edit Ticket'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Passenger Name'),
              validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
            ),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: 'Destination'),
              validator: (value) => value!.isEmpty ? 'Please enter a destination' : null,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _journeyDateController,
              decoration: InputDecoration(labelText: 'Journey Date (YYYY-MM-DD)'),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a date';
                } else {
                  final parts = value.split('-');
                  if (parts.length == 3 && parts.every((part) => int.tryParse(part) != null)) {
                    return null;
                  }
                  return 'Invalid date format. Use YYYY-MM-DD';
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveTicket,
          child: Text('Save'),
        ),
      ],
    );
  }
}
