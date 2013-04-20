# coding: utf-8

require 'boleto_utils'

module AcBoletos

  class BoletoReal < Boleto

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
      codigo_banco.to_s + #01-03 código do banco
      moeda.to_s   + #04-04 moeda 9 Real
      calculo_digito_verificador('3569' + fator_vencimento.to_s + valor_documento_formatado.to_s + get_campo_livre.to_s).to_s   + #TODO #05-05 dígito verificador Geral do Código de barras
      fator_vencimento + #06-09 fator de vencimento
      valor_documento_formatado + #10-19 valor do documento
      get_campo_livre #20-44 campo livre
    end

    def get_campo_livre
      agencia.to_s + codigo_cedente.to_s +
        calc_digitao_cobranca_real.to_s + nosso_numero.to_s
    end

    def get_codigo_cedente_formatted
      codigo_cedente.to_s + '-' + calc_digito_verificador_cod_cedente.to_s
    end

    def agencia_codigo_cedente
      agencia + '/' + get_codigo_cedente_formatted
    end

    def nosso_numero
      "%013d" % numero
    end

    def nosso_numero_formatado
      "%013d" % numero
    end

    def carteira
      'SR'
    end

    def caminho_logo
      'ac_boletos/logo_real.jpg'
    end

    def codigo_banco_formatado
      "356-5"
    end

    private

    def codigo_banco
      356
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

    def calc_digitao_cobranca_real
      valor = nosso_numero + agencia + codigo_cedente
      pesos = '121212121212121212121212'
      soma = 0
      23.downto(0) do |i|
        soma = soma + m(valor[i..i], pesos[i..i])
      end
      resto = soma.divmod(10)[1]
      r = 10 - resto
      r = 0 if r == 10
      r
    end

    private

    def m(a,b)
      r = a.to_i * b.to_i
      (r > 9) ? r.divmod(10).inject(0) {|s,i| s + i} : r
    end

  end
end
