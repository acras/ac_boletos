# coding: utf-8

require 'boleto_utils'


module AcBoletos

  class BoletoCaixa < Boleto

    def local_pagamento
      ['Preferencialmente nas casas lotéricas até o valor limite.']
    end

    def numero_guia
      numero_documento
    end

    def linha_digitavel
      dv1 = dv2 = dv3 = '?'
      c = codigo_barras.to_s
      c1 = c[0..3] + c[19..19] + c[20..23]
      c2 = c[24..33]
      c3 = c[34..43]
      c4 = c[4..4]
      c5 = c[5..18]

      dv1 = calculo_digito_verificador_modulo_10(c1)
      dv2 = calculo_digito_verificador_modulo_10(c2)
      dv3 = calculo_digito_verificador_modulo_10(c3)

      "#{c1[0..4]}.#{c1[5..8]}#{dv1}  #{c2[0..4]}.#{c2[5..9]}#{dv2}  #{c3[0..4]}.#{c3[5..9]}#{dv3}  #{c4}  #{c5}"
    end

    def codigo_barras
      '104' + #01-03 código do banco
      '9'   + #04-04 moeda 9 Real
      calculo_digito_verificador('1049' + fator_vencimento.to_s + valor_documento_formatado.to_s + get_campo_livre.to_s).to_s   + #TODO #05-05 dígito verificador Geral do Código de barras
      fator_vencimento + #06-09 fator de vencimento
      valor_documento_formatado + #10-19 valor do documento
      get_campo_livre #20-44 campo livre
    end

    # ok
    def get_campo_livre
      str = codigo_cedente[0..5] + # codigo cedente mas digito verificador
      calc_digito_verificador_cod_cedente.to_s + #
      nosso_numero[2..4] + # 3a a 5a posição do Nosso Número
      nosso_numero[0] + # 1a posição do Nosso Numero: Tipo de Cobrança (1-Registrada / 2-Sem Registro)
      nosso_numero[5..7] + # 6a a 8a posição do Nosso Número
      nosso_numero[1] + # 2a posição do Nosso Número: Identificador da Emissão do Boleto (4-Beneficiário)
      nosso_numero[8..16]  # 9a a 17a posição do Nosso Número
      str + calculo_digito_verificador(str, true).to_s

    end

    # ok
    def get_codigo_cedente_formatted
      codigo_cedente + '-' + calc_digito_verificador_cod_cedente.to_s
    end

    def agencia_codigo_cedente
      agencia + '/' + get_codigo_cedente_formatted
    end

    def nosso_numero
      if @carteira == '11'
        "%010d" % numero
      elsif @carteira == '12'
        "9%09d" % numero
      elsif @carteira == '14'
        "14%015d" % numero
      end
    end

    def nosso_numero_formatado
      nosso_numero + '-' + calculo_digito_verificador(nosso_numero.to_i, true).to_s
    end

    def carteira
      case @carteira
      when '11' then 'CS'
      when '12' then 'CR'
      when '14' then 'RG'
      when '41' then 'DE'
      else ""
      end
    end

    def codigo_banco_formatado
      '104-0'
    end

    def caminho_logo
      'logo_caixa.jpg'
    end

    private

    def codigo_banco
      104
    end


    def moeda
      9
    end

    def fator_vencimento
      (data_vencimento - Date.new(1997, 10, 7)).to_i.to_s
    end

    def valor_documento_formatado
      "%010d" % (valor * 100)
    end

    def calc_digito_verificador_cod_cedente
      calculo_digito_verificador(codigo_cedente.to_s, true)
    end

    def calc_digito_verificador_campo_livre(campo_livre)
      calculo_digito_verificador(campo_livre, true)
    end
  end

end
