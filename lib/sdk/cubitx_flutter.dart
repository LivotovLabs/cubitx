import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'cubitx_logic.dart';

abstract class CubitView<C extends Cubit<S>, S> extends StatefulWidget {
  final C controller;

  const CubitView(this.controller, {super.key});

  @override
  State createState() => _CubitViewState(controller);

  Widget _build(BuildContext context) {
    return onComposeWidget(context, controller.state());
  }

  void onWidgetMounted();
  Widget onComposeWidget(BuildContext context, S state);
}

class _CubitViewState extends State<CubitView> {
  final Cubit controller;
  final _observer = RxNotifier();
  late StreamSubscription subs;

  _CubitViewState(this.controller) : super();

  @override
  void initState() {
    super.initState();
    widget.onWidgetMounted();
    subs = _observer.listen(_updateTree, cancelOnError: false);
  }


  void _updateTree(_) {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller.stopCubit();
    subs.cancel();
    _observer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => RxInterface.notifyChildren(_observer, () => widget._build(context));
}
