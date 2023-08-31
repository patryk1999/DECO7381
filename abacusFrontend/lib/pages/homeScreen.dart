import 'package:flutter/material.dart';

void main() => runApp(const HomeScreen());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AppBarExample(),
    );
  }
}

class AppBarExample extends StatelessWidget {
  const AppBarExample({super.key});

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Color(0xFF78BC3F),
    );

    final double buttonWidth =
        MediaQuery.of(context).size.width * 0.8; // Adjust the factor as needed

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              style: style,
              onPressed: () {},
              child: const Icon(
                Icons.search,
                color: Color(0xFF78BC3F),
              ),
            ),
            Text('Home', style: TextStyle(color: Colors.black)),
            TextButton(
              style: style,
              onPressed: () {},
              child: const Icon(Icons.settings, color: Color(0xFF78BC3F)),
            ),
          ],
        ),
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50.0, horizontal: 2),
          width: buttonWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleElevatedButton(
                onPressed: () {},
                child: Text('Join Run'),
              ),
              SimpleElevatedButton(
                onPressed: () {},
                child: Text('Create Run'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimpleElevatedButton extends StatelessWidget {
  const SimpleElevatedButton(
      {this.child,
      this.color,
      this.onPressed,
      this.borderRadius = 30,
      this.padding = const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      Key? key})
      : super(key: key);
  final Color? color;
  final Widget? child;
  final Function? onPressed;
  final double borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);
    return FilledButton(
      style: FilledButton.styleFrom(
          padding: padding,
          shadowColor: Color(0x000000),
          backgroundColor: color ?? Color(0xFF78BC3F),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)),
          side: BorderSide(
            color: Colors.black,
          )),
      onPressed: onPressed as void Function()?,
      child: child,
    );
  }
}
