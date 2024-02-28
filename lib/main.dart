import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class Product {
  final String title;
  final String description;
  final String imageUrl;
  final String category;

  Product({required this.title, required this.description, required this.imageUrl, required this.category});
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> products = [
    Product(title: 'Product 1', description: 'hhfeheh', imageUrl: 'assets/images/ch1.jpg', category: 'Category 1'),
    Product(title: 'Product 2', description: 'jkesdhh', imageUrl: 'assets/images/ch2.jpg', category: 'Category 1'),
    Product(title: 'Product 3', description: 'Description 3', imageUrl: 'assets/images/ch3.jpg', category: 'Category 2'),
    Product(title: 'Product 3', description: 'Description 3', imageUrl: 'assets/images/ch4.jpg', category: 'Category 2'),
    Product(title: 'Product 4', description: 'Description 4', imageUrl: 'assets/images/j1.jpg', category: 'Category 2'),
    Product(title: 'Product 4', description: 'Description 4', imageUrl: 'assets/images/j2.jpg', category: 'Category 2'),
    Product(title: 'Product 4', description: 'Description 4', imageUrl: 'assets/images/j3.jpg', category: 'Category 2'),
  ];

  List<Product> filteredProducts = [];

  String selectedCategory = 'All Categories';
  List<String> categories = ['All Categories', 'Category 1', 'Category 2'];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
  }

  void filterProductsByCategory(String category) {
    setState(() {
      if (category == 'All Categories') {
        filteredProducts = List.from(products);
      } else {
        filteredProducts = products.where((product) => product.category == category).toList();
      }
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boutique'),
      ),
      drawer: DrawerWidget(),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedCategory,
            onChanged: (value) {
              filterProductsByCategory(value!);
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                return ProductItem(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}


class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  ProductDetailsScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            product.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class ProductListScreen extends StatelessWidget {
  final List<Product> products;

  ProductListScreen({required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Produits'),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductItem(product: products[index]);
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
ListTile(
  title: Text('Liste produit'),
  onTap: () {
    _HomeScreenState obj = _HomeScreenState();
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductListScreen(products: obj.products),
      ),
    );
  },
),

          ListTile(
            title: isLoggedIn ? Text('Déconnecté') : Text('Connecté'),
            onTap: () {
              Navigator.pop(context);
              if (mounted) {
                if (isLoggedIn) {
                  setState(() {
                    isLoggedIn = false;
                  });
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        onLogin: () {
                          if (mounted) {
                            setState(() {
                              isLoggedIn = true;
                            });
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  );
                }
              }
            },
          ),
       
            ListTile(
              title: Text('Se déconnecter'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  isLoggedIn = false;
                });
              },
            ),
            
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;

  LoginScreen({required this.onLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue ! Connectez-vous',
              style: TextStyle(fontSize: 20),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nom d\'utilisateur'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                if (_usernameController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  widget.onLogin(); 
                } else {

                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Champs vides'),
                      content: Text('Veuillez remplir tous les champs.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Se connecter'),
            ),
          ],
        ),
      ),
    );
  }
}
