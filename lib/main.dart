import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vendedores',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const VendedoresScreen(),
    );
  }
}

class VendedoresScreen extends StatefulWidget {
  const VendedoresScreen({super.key});

  @override
  _VendedoresScreenState createState() => _VendedoresScreenState();
}

class _VendedoresScreenState extends State<VendedoresScreen> {
  List<dynamic> vendedores = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchVendedores();
  }

  Future<void> fetchVendedores() async {
    const String apiUrl = 'https://ARQUIVOS.ECTARE.COM.BR/vendedores.json';
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        setState(() {
          vendedores = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Falha ao carregar os dados');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint('Erro: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Vendedores'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: vendedores.length,
              itemBuilder: (context, index) {
                final vendedor = vendedores[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(vendedor['nome']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Empresa: ${vendedor['empresa']}'),
                        Text('Produto Vendido: ${vendedor['produto_vendido']}'),
                        Text('Meta de Vendas: R\$${vendedor['meta_vendas']}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
