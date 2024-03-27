import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class LogoSelector extends StatefulWidget {
  final List<String> logos;
  final String? selectedLogo;
  final ValueChanged<String> onLogoSelected;

  const LogoSelector(
      {super.key,
      required this.logos,
      this.selectedLogo,
      required this.onLogoSelected});

  @override
  _LogoSelectorState createState() => _LogoSelectorState();
}

class _LogoSelectorState extends State<LogoSelector> {
  late ValueNotifier<String?> selectedLogoNotifier;

  @override
  void initState() {
    super.initState();
    selectedLogoNotifier = ValueNotifier<String?>(widget.selectedLogo);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.logos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        return ValueListenableBuilder<String?>(
          valueListenable: selectedLogoNotifier,
          builder: (context, value, child) {
            return Card(
              color: value == widget.logos[index]
                  ? Colors.blueGrey
                  : Colors.white70,
              child: InkWell(
                onTap: () {
                  selectedLogoNotifier.value = widget.logos[index];
                  widget.onLogoSelected(widget.logos[index]);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: index == widget.logos.length - 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 2,
                              child: Image.asset(
                                widget.logos[index],
                              ),
                            ),
                            const Flexible(
                              child: Center(child: AutoSizeText('Sem Logo')),
                            ),
                          ],
                        )
                      : Image.asset(
                          widget.logos[index],
                        ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    selectedLogoNotifier.dispose();
    super.dispose();
  }
}
