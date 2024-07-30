import 'package:amazon/common/widgets/loader.dart';
import 'package:amazon/constants/global_variables.dart';
import 'package:amazon/features/account/widgets/single_product.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:amazon/features/admin/services/admin_services.dart';
import 'package:amazon/models/product.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<Product>? products;

  final AdminServices adminServices = AdminServices();

  @override
  void initState() {
    super.initState();
    fetchAllProducts(); // Ekran yüklendiğinde tüm ürünleri getirme fonksiyonu çağrılır
  }

  // Tüm ürünleri getirme fonksiyonu
  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {}); // Ürünler getirildikten sonra arayüz güncellenir
  }

  // Ürün silme fonksiyonu
  void deleteProduct(Product product, int index) {
    adminServices.deleteProduct(
      context: context,
      product: product,
      onSuccess: () {
        products!.removeAt(
            index); // Başarılı silme işleminde ürün listeden çıkarılır
        setState(() {}); // Arayüz güncellenir
      },
    );
  }

  // Ürün ekleme ekranına yönlendirme fonksiyonu
  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // Eğer ürünler yüklenmediyse loading animasyonu gösterilir
    return products == null
        ? const Loader()
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length, // Ürün sayısı
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 sütun
                ),
                itemBuilder: (context, index) {
                  final productData = products![index];
                  return Column(
                    children: [
                      // Ürün resmi ve adı gösterilir
                      SizedBox(
                        height: 130,
                        child: SingleProduct(
                          image: productData.images[0],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Text(
                              productData.name,
                              overflow: TextOverflow
                                  .ellipsis, // Taşan metin noktalı gösterilir (...)
                              maxLines: 2, // Maksimum 2 satır gösterilir
                            ),
                          ),
                          IconButton(
                            // Ürün silme fonksiyonu çağrılır
                            onPressed: () => deleteProduct(productData, index),
                            icon: const Icon(Icons.delete_outline_outlined),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: navigateToAddProduct,
              shape: const CircleBorder(),
              backgroundColor: GlobalVariables.floatingActionButtonColor,
              splashColor: GlobalVariables.floatingActionSplashColor,
              tooltip: 'Add Product', // Buton üzerinde gösterilen ipucu metni
              child: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat, // Butonun konumu
          );
  }
}
