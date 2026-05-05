import 'dart:ui';

import 'package:electra/common/widgets/nav/add_popup.dart';
import 'package:electra/core/router/route_names.dart';
import 'package:electra/presentation/purchase/widgets/bottom_sheet/add_purchase_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:electra/common/widgets/nav/custom_bottom_nav.dart';

class LayoutScaffold extends StatefulWidget {
  const LayoutScaffold({Key? key, required this.navigationShell})
    : super(key: key ?? const ValueKey('LayoutScaffold'));

  final StatefulNavigationShell navigationShell;

  @override
  State<LayoutScaffold> createState() => _LayoutScaffoldState();
}

class _LayoutScaffoldState extends State<LayoutScaffold>
    with SingleTickerProviderStateMixin {
  bool _popupOpen = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _togglePopup() {
    setState(() => _popupOpen = !_popupOpen);
    _popupOpen ? _animController.forward() : _animController.reverse();
  }

  void _closePopup() {
    setState(() => _popupOpen = false);
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          /// ✅ Main content
          widget.navigationShell,

          /// ✅ Blur + dismiss layer
          if (_popupOpen)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _closePopup,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withValues(alpha: 0.1)),
                ),
              ),
            ),

          /// ✅ 🔥 MOVE POPUP HERE (CRITICAL)
          if (_popupOpen)
            Positioned(
              bottom: 90, // adjust based on your nav height
              left: 0,
              right: 0,
              child: Center(
                child: Material(
                  color: Colors.transparent,
                  child: AddPopup(
                    animation: _scaleAnim,
                    isVisible: _popupOpen,
                    onManualEntry: () {
                      _closePopup();
                      AddPurchaseBottomSheet.show(context);
                    },
                    onVoiceInput: () {
                      _closePopup();
                      context.pushNamed(RouteNames.expenseRecorder);
                    },
                    onScanReceipt: () {
                      _closePopup();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),

      /// ✅ Bottom nav ONLY (no popup here anymore)
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
        child: CustomBottomNav(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            _closePopup();
            widget.navigationShell.goBranch(index);
          },
          onAddTapped: _togglePopup,
        ),
      ),
    );
  }
}
