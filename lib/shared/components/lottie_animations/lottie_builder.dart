import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NetworkLotties extends StatelessWidget {
  const NetworkLotties({Key? key, required this.asset}) : super(key: key);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Lottie.network(
      asset,
      backgroundLoading: true,
      reverse: true,
    );
  }
}

class AssetLotties extends StatelessWidget {
  const AssetLotties({Key? key, required this.asset}) : super(key: key);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      backgroundLoading: true,
      reverse: true,
    );
  }
}
