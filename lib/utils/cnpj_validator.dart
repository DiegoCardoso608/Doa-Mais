class CnpjValidator {
  static bool isValid(String cnpj) {
    // Remove caracteres especiais
    String cnpjLimpo = cnpj.replaceAll(RegExp(r'[^0-9]'), '');

    // Verifica se tem exatamente 14 dígitos
    if (cnpjLimpo.length != 14) {
      return false;
    }

    // Verifica se todos os dígitos são iguais (CNPJ inválido)
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpjLimpo)) {
      return false;
    }

    // Valida o primeiro dígito verificador
    int primeiro = _calcularDigito(cnpjLimpo.substring(0, 12), 5);
    if (int.parse(cnpjLimpo[12]) != primeiro) {
      return false;
    }

    // Valida o segundo dígito verificador
    int segundo = _calcularDigito(cnpjLimpo.substring(0, 12) + primeiro.toString(), 6);
    if (int.parse(cnpjLimpo[13]) != segundo) {
      return false;
    }

    return true;
  }

  static int _calcularDigito(String cnpj, int multiplicadorInicial) {
    int soma = 0;
    int multiplicador = multiplicadorInicial;

    for (int i = 0; i < cnpj.length; i++) {
      soma += int.parse(cnpj[i]) * multiplicador;
      multiplicador--;

      if (multiplicador == 1) {
        multiplicador = 9;
      }
    }

    int resto = soma % 11;
    return resto < 2 ? 0 : 11 - resto;
  }
}
