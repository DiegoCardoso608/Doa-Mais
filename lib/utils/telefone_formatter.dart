import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TelefoneFormatter extends MaskTextInputFormatter {
  TelefoneFormatter()
      : super(
          mask: '(##) #####-####',
          filter: {
            "#": RegExp(r'[0-9]')
          },
        );
}
