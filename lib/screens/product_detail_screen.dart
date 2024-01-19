import 'dart:convert';

import 'package:login_andriod/components/loading_component.dart';
import 'package:login_andriod/models/response/Products.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductDetailScreen extends StatefulWidget {
  Products? products;
  ProductDetailScreen({super.key, this.products});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Products product = Products();
  getProductById(int id) async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("https://dummyjson.com/products/${id}");
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      setState(() {
        product = Products.fromJson(map);
      });
    }
    setState(() {
      isLoading = false;
    });
  }
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getProductById(widget.products!.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(
          "Product Detail",
          style: TextStyle(fontSize: 28),
        ),
      ),
      body: isLoading == true
          ? const LoadingComponent()
          : ListView(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.deepPurple[200],
                  child: CarouselSlider(
                    options: CarouselOptions(),
                    items: product!.images!
                        .map((item) => Container(
                              child: Center(
                                  child: Image.network(item,
                                      fit: BoxFit.cover, width: 1000)),
                            ))
                        .toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    "${product.title}",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Brand"),
                      Text(" ${product.brand}")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Category"),
                      Text(" ${product.category}")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Price"),
                      Text("\$ ${product.price}")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stock"),
                      Text(" ${product!.stock}")
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating"),
                      Text(" ${product.rating}")
                    ],
                  ),
                ),Container(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rating"),
                      Text(" ${product.description}")
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
