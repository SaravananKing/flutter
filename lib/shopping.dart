import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class Product {
  final String name;
  final String description;
  final double price;
  final String image;

  Product({required this.name, required this.description, required this.price, required this.image});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShoppingScreen(),
    );
  }
}

class ShoppingScreen extends StatefulWidget {
  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  List<Product> products = [
    Product(name: 'Apple', description: 'Fresh Red Apple', price: 1.2, image: 'assets/apple.jpg'),
    Product(name: 'Banana', description: 'Ripe Yellow Banana', price: 0.5, image: 'assets/banana.jpg'),
    Product(name: 'Orange', description: 'Juicy Orange', price: 1.0, image: 'assets/orange.jpg'),
  ];

  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping App'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cart: cart)),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(products[index].image, width: 50, height: 50),
              title: Text(products[index].name),
              subtitle: Text(products[index].description),
              trailing: Text('\$${products[index].price}'),
              onTap: () {
                addToCart(products[index]);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${products[index].name} added to cart')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Product> cart;

  CartScreen({required this.cart});

  double calculateTotal() {
    double total = 0;
    for (var product in cart) {
      total += product.price;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Cart')),
      body: cart.isEmpty
          ? Center(child: Text('No items in the cart'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: Image.asset(cart[index].image, width: 50, height: 50),
                    title: Text(cart[index].name),
                    trailing: Text('\$${cart[index].price}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Total: \$${calculateTotal()}', style: TextStyle(fontSize: 24)),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Checkout'),
                    content: Text('Thank you for shopping!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          // Clear the cart when "OK" is pressed
                          Navigator.pop(context);
                          // Clear the cart by setting it to an empty list
                          cart.clear();
                          // Go back to the ProductListScreen after clearing the cart
                          Navigator.pop(context);
                        },
                        child: Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
