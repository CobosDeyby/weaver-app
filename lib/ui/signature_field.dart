import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';

const _box = 1000;

/// A drawn signature: strokes of `[x, y]` points in a 0..1000 box, drawn on a
/// `w` × `h` canvas. It is stored as data, not as an image, so it travels
/// inside the response.
Map<String, dynamic>? signatureOf(Object? value) {
  if (value is Map && value['strokes'] is List && (value['strokes'] as List).isNotEmpty) {
    return Map<String, dynamic>.from(value);
  }
  return null;
}

/// Sign with a finger. Drawing wins over scrolling the form.
class SignatureField extends StatefulWidget {
  const SignatureField({super.key, required this.value, required this.onChanged, this.error});

  final Object? value;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final String? error;

  @override
  State<SignatureField> createState() => _SignatureFieldState();
}

class _SignatureFieldState extends State<SignatureField> {
  static const _height = 160.0;

  /// Strokes while the finger is down; null when showing the saved value.
  List<List<List<int>>>? _live;
  Size _size = const Size(1, _height);

  List<List<List<int>>> get _saved {
    final signature = signatureOf(widget.value);
    if (signature == null) {
      return const [];
    }

    return [
      for (final stroke in signature['strokes'] as List)
        [
          for (final point in stroke as List) [(point[0] as num).round(), (point[1] as num).round()],
        ],
    ];
  }

  List<int> _point(Offset local) => [
    (local.dx / _size.width * _box).clamp(0, _box).round(),
    (local.dy / _size.height * _box).clamp(0, _box).round(),
  ];

  void _down(PointerDownEvent event) => setState(
    () => _live = [
      ..._saved,
      [_point(event.localPosition)],
    ],
  );

  void _move(PointerMoveEvent event) {
    final live = _live;
    if (live == null) {
      return;
    }

    setState(() => live.last.add(_point(event.localPosition)));
  }

  void _up(PointerEvent event) {
    final live = _live;
    if (live == null) {
      return;
    }

    setState(() => _live = null);
    widget.onChanged({'w': _size.width.round(), 'h': _size.height.round(), 'strokes': live});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strokes = _live ?? _saved;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            _size = Size(constraints.maxWidth, _height);

            return RawGestureDetector(
              // Claim the touch at once so the form does not scroll while signing.
              gestures: {
                EagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<EagerGestureRecognizer>(
                  EagerGestureRecognizer.new,
                  (_) {},
                ),
              },
              child: Listener(
                onPointerDown: _down,
                onPointerMove: _move,
                onPointerUp: _up,
                onPointerCancel: _up,
                child: Container(
                  key: const Key('signature-pad'),
                  height: _height,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: widget.error != null ? theme.colorScheme.error : theme.colorScheme.outline,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _StrokesPainter(strokes),
                    child: strokes.isEmpty
                        ? Center(
                            child: Text(
                              'Firme aquí con el dedo',
                              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black38),
                            ),
                          )
                        : null,
                  ),
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            key: const Key('clear-signature'),
            onPressed: strokes.isEmpty ? null : () => widget.onChanged(null),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Borrar firma'),
          ),
        ),
      ],
    );
  }
}

class _StrokesPainter extends CustomPainter {
  _StrokesPainter(this.strokes);

  final List<List<List<int>>> strokes;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    Offset at(List<int> point) => Offset(point[0] / _box * size.width, point[1] / _box * size.height);

    for (final stroke in strokes) {
      if (stroke.length == 1) {
        canvas.drawCircle(at(stroke.first), 1.5, paint..style = PaintingStyle.fill);
        paint.style = PaintingStyle.stroke;
        continue;
      }

      final path = Path()..moveTo(at(stroke.first).dx, at(stroke.first).dy);
      for (final point in stroke.skip(1)) {
        path.lineTo(at(point).dx, at(point).dy);
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_StrokesPainter old) => true;
}
