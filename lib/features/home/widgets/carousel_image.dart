import 'package:amazon/constants/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

// Görselleri kaydırarak gösteren bir bileşen.
class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map(
        (i) {
          return Builder(
            builder: (BuildContext context) => Image.network(
              i,
              fit: BoxFit.cover,
              height: 200,
            ),
          );
        },
      ).toList(),
      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
      ),
    );
  }
}


/*
  carousel_slider paketi, Flutter uygulamalarında görsellerin veya widget'ların kaydırılabilir bir galerisini oluşturmamıza olanak tanır. 
  Bu paket, bir dizi içeriği (resimler, metinler, widget'lar vb.) yatay veya dikey olarak kaydırarak kullanıcıya sunmamızı sağlar.

  viewportFraction gibi parametrelerle her bir öğenin ne kadar alan kaplayacağını ayarlayabilirsiniz.
  autoPlay seçeneği ile galerinin otomatik olarak kaymasını sağlayabilirsiniz. Bu, özellikle reklam veya tanıtım amaçlı galerilerde kullanışlıdır.
 */