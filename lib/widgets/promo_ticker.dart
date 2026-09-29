import 'package:flutter/material.dart';

class PromoTicker extends StatefulWidget {
  const PromoTicker({super.key});

  @override
  State<PromoTicker> createState() => _PromoTickerState();
}

class _PromoTickerState extends State<PromoTicker> {
  final ScrollController _controller = ScrollController();

  static const _message =
      'Free Shipping over \$150!      New Supply, Order Now      ';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loop());
  }

  Future<void> _loop() async {
    while (mounted) {
      if (!_controller.hasClients) return;
      final max = _controller.position.maxScrollExtent;
      if (max <= 0) return;
      await _controller.animateTo(
        max,
        duration: const Duration(seconds: 14),
        curve: Curves.linear,
      );
      if (!mounted) return;
      _controller.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: double.infinity,
      color: const Color(0xFF654039),
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(
          _message * 6,
          style: const TextStyle(fontSize: 10, color: Colors.white),
        ),
      ),
    );
  }
}