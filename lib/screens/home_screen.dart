import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:login_andriod/components/loading_component.dart';
import 'package:login_andriod/models/response/Products.dart';
import 'package:http/http.dart' as http;
import 'package:login_andriod/screens/search_product_screen.dart';
import 'package:login_andriod/screens/product_category_screen.dart';
import 'package:login_andriod/screens/product_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Products> productList = [];
  List<String> categories = [];
  bool isLoading = false;
  bool isgrid = false;

  @override
  void initState() {
    super.initState();
    getAllCategories();
    getAllProduct();
  }

  getAllProduct() async {
    setState(() {
      isLoading = true;
    });
    var url = Uri.parse("https://dummyjson.com/products");
    var respone = await http.get(url);
    if (respone.statusCode == 200) {
      var map = jsonDecode(respone.body);
      map["products"].forEach((data) {
        var product = Products.fromJson(data);
        productList.add(product);
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

  getAllCategories() async {
    categories.add("All");
    var url = Uri.parse("https://dummyjson.com/products/categories");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body);
      map.forEach((data) {
        categories.add("$data");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Sale App",
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchProduct()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ))
        ],
      ),
      body:
      isLoading == true
          ? const LoadingComponent()
          : RefreshIndicator(
          onRefresh: () async {
            getAllCategories();
            getAllProduct();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                      itemCount: categories.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductCategoryScreen(
                                            categoryName:
                                            categories[index])));
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Text(
                              categories[index],
                              style: const TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }),
                ),
                Container(
                  height: 100,
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 20, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Products",
                        style: TextStyle(fontSize: 16),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ProductCategoryScreen(
                                            categoryName: "All",
                                          )));
                            },
                            child: Text(
                              "View More",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                isgrid = !isgrid;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Image.asset(
                                isgrid == true
                                    ? "assets/images/app.png"
                                    : "assets/images/list.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isgrid == false
                    ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: productList.length,
                    itemBuilder: (BuildContext context, index) {
                      var product = productList[index];
                      return Container(
                        margin: const EdgeInsets.only(top: 5),
                        decoration:
                        const BoxDecoration(color: Colors.black12),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(
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
                    })
                    : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: productList.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4),
                    itemBuilder: (BuildContext context, index) {
                      var product = productList[index];
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03)),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProductDetailScreen(
                                              products: product,
                                            )));
                              },
                              child: Image.network(
                                "${product.thumbnail}",
                                width: 80,
                                height: 100,
                              ),
                            ),
                            Center(
                              child: Text("${product.title}"),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${product.discountPercentage!.toStringAsFixed(0)} %"),
                                  Text(
                                    "\$ ${product.price!.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ],
            ),
          )),
    );
  }
}