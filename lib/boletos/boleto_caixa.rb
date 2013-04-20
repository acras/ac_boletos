# coding: utf-8

require 'boleto_utils'


module AcBoletos

  class BoletoCaixa < Boleto

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

    def get_campo_livre
      campo_livre = codigo_cedente.to_s + #20-25 Código do Cedente
      calc_digito_verificador_cod_cedente.to_s + #26-26 Dígito Verificador do Código do Cedente
      nosso_numero[2..4] + #27–29 Nosso Número – Seqüência 1 (vide Nota 2) - posição 3 a 5 do nosso número
      nosso_numero[0..0] + #30–30 Constante 1 (vide Nota 2) - primeira posição do nosso número
      nosso_numero[5..7] + #31–33 Nosso Número – Seqüência 2 (vide Nota 2) - posição 6 a 8 do nosso número
      nosso_numero[1..1] + #34–34 Constante 2 (vide Nota 2) - segunda posição do nosso número
      nosso_numero[8..16] #35–43 Nosso Número – Seqüência 3 (vide Nota 2) - posição 9 a 17 do nosso número
      campo_livre = campo_livre + calc_digito_verificador_campo_livre(campo_livre).to_s #44–44 Dígito Verificador do Campo Livre
    end

    def get_codigo_cedente_formatted
      codigo_cedente.to_s + '-' + calc_digito_verificador_cod_cedente.to_s
    end

    def agencia_codigo_cedente
      agencia + '/' + get_codigo_cedente_formatted
    end

    def nosso_numero
      '24' + "%015d" % numero
    end

    def nosso_numero_formatado
      nosso_numero + '-' + calculo_digito_verificador(nosso_numero.to_i, true).to_s
    end

    def carteira
      'SR'
    end

    def codigo_banco_formatado
      '104-0'
    end
    
    def caminho_logo
      'ac_boletos/logo_caixa.jpg'
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
      calculo_digito_verificador(codigo_cedente.to_s)
    end

    def calc_digito_verificador_campo_livre(campo_livre)
      calculo_digito_verificador(campo_livre, true)
    end
  end

end
