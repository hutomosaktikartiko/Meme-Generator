import 'package:equatable/equatable.dart';

// TODO: Uncomment this to assign others parameter
class TextCaptionEntity extends Equatable {
  final String text;
  // color, outlineColor;
  // final int height, width, positionX, positionY;

  const TextCaptionEntity({
    required this.text,
    // required this.color,
    // required this.outlineColor,
    // required this.height,
    // required this.width,
    // required this.positionX,
    // required this.positionY,
  });

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      // "x": 10,
      // "y": 10,
      // "width": 548,
      // "height": 100,
      // "color": "#ffffff",
      // "outline_color": "#000000"
    };
  }

  TextCaptionEntity copyWith({
    String? text,
    // String? color,
    // String? outlineColor,
    // int? height,
    // int? width,
    // int? positionX,
    // int? positionY,
  }) {
    return TextCaptionEntity(
      text: text ?? this.text,
      // color: color ?? this.color,
      // outlineColor: outlineColor ?? this.outlineColor,
      // height: height ?? this.height,
      // width: width ?? this.width,
      // positionX: positionX ?? this.positionX,
      // positionY: positionY ?? this.positionY,
    );
  }

  @override
  List<Object?> get props => [
        text,
        // color,
        // outlineColor,
        // height,
        // width,
        // positionX,
        // positionY,
      ];
}
