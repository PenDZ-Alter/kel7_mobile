import 'package:flutter/material.dart';
import 'package:tugas1_ui/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // AppBar transparan
        elevation: 0, // Menghilangkan bayangan (shadow)
        title: const Text(
          'LOG IN',
          style: TextStyle(
            fontFamily: 'Times New Roman',
            color: Colors.black, // Warna teks hitam
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // Agar teks berada di tengah
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo dan teks selamat datang
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/Images/hamilton_logo2.png', // Sesuaikan dengan lokasi file logo Anda
                        height: 100,
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Please log in to continue',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
          
                // Input email
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
          
                // Input password
                TextFormField(
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
          
                // Lupa password
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      // Handle lupa password
                    },
                    child: const Text('Forgot Password?'),
                  ),
                ),
          
                // Tombol login
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber, // Warna tombol login
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Handle login
                  },
                  child: const Text('Log in'),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Lupa password
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // Menampilkan pop-up dialog ketika tombol ditekan
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                            child: Container(child: Text("Forgot Password"))),
                        content: Text(
                            "To reset your password, please contact support or use the reset password option."),
                        actions: <Widget>[
                          TextButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.of(context).pop(); // Menutup dialog
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Center(child: const Text('Forgot Password?')),
              ),
            ),

            // Tombol login
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber, // Warna tombol login
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Navigasi kembali ke halaman home
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(title: "H A M I L T O N")),
                );
              },
              child: const Text('Log in'),
            ),
            const SizedBox(height: 20),

            // Belum punya akun
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Haven't signed up yet?",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber, // Warna kuning
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Menampilkan pop-up dialog ketika tombol ditekan
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Center(
                              child:
                                  Container(child: Text("Create an account"))),
                          content: Text(
                              "To make account, please contact support or use your current account."),
                          actions: <Widget>[
                            TextButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.of(context).pop(); // Menutup dialog
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold, // Warna hitam
                const SizedBox(height: 20),
          
                // Belum punya akun
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Haven't signed up yet?",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.amber, // Warna kuning
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle buat akun baru
                      },
                      child: const Text(
                        'Create an account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black, // Warna hitam
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
