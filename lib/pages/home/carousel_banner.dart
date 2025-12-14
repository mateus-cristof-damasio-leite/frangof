import 'dart:async';
import 'package:flutter/material.dart';
import '../product/product_page.dart';

class CarouselBanner extends StatefulWidget {
  const CarouselBanner({super.key});

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  final PageController _controller = PageController(viewportFraction: 0.92);

  int _currentPage = 0;
  Timer? _timer;

  final List<Map<String, String>> promotions = [
    {
      'title': 'Promoção do Dia',
      'subtitle': 'Frango assado com desconto',
      'image': 'lib/assets/images/custelinha.png',
    },
    {
      'title': 'Combo Família',
      'subtitle': 'Frango + arroz + farofa',
      'image': 'lib/assets/images/combo_familia.png',
    },
    {
      'title': 'Frango + Farofa',
      'subtitle': 'O mais pedido da casa',
      'image': 'lib/assets/images/frango+farofa.png',
    },
    {
      'title': 'Arroz Especial',
      'subtitle': 'ao alho e manteiga',
      'image': 'lib/assets/images/arroz.png',
    },
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        _currentPage = (_currentPage + 1) % promotions.length;

        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: PageView.builder(
        controller: _controller,
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          final promo = promotions[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductPage()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                image: DecorationImage(
                  image: AssetImage(promo['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.75),
                      Colors.transparent,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      promo['title']!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      promo['subtitle']!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
