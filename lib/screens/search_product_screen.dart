import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_andriod/models/response/Products.dart';
import 'package:login_andriod/screens/product_detail_screen.dart';
import 'package:login_andriod/components/loading_component.dart';
import '../components/loading_component.dart';

class SearchProduct extends StatefulWidget {
  const SearchProduct({super.key});

  @override
  State createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchController = TextEditingController();
  var isLoading = false;
  List<Products> productList = [];
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_searchProduct);
  }

  Future<void> _searchProduct() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse(
        "https://dummyjson.com/products/search?q=${_searchController.text.toLowerCase()}");
    var respone = await http.get(url);
    setState(() {
      productList = [];
    });
    productList = [];
    if (respone.statusCode == 200) {
      var map = jsonDecode(respone.body);
      map["products"].forEach((data) {
        var product = Products.fromJson(data);
        setState(() {
          productList.add(product);
        });
      });
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
              hintText: "Search product names..",
              hintStyle: TextStyle(color: Colors.white24),
              focusColor: Colors.white,
              border: InputBorder.none),
        ),
      ),
      body: isLoading == true
          ? const LoadingComponent()
          : ListView.builder(
          shrinkWrap: true,
          itemCount: productList.length,
          itemBuilder: (BuildContext context, index) {
            var product = productList[index];
            return Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(color: Colors.black12),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            products: product,
                          )));
                },
                leading: Image.network(
                  "${product.thumbnail}",
                  width: 100,
                  height: 150,
                ),
                title: Text("${product.title}"),
                subtitle: Text("${product.description}"),
              ),
            );
          }),
    );
  }
}