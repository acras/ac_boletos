# coding: utf-8

require 'boleto_utils'

module AcBoletos

  class BoletoSantander < Boleto

    def local_pagamento
      ['Até o vencimento, preferencialmente no Santander', 'Após o vencimento, somente no Santander']
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
      str = codigo_barras_sem_dv.gsub("?", "")
      codigo_barras_sem_dv.gsub("?", calculo_digito_verificador(str).to_s)
    end

    def codigo_barras_sem_dv
      codigo_banco + #01-03 código do banco
      moeda.to_s + #04-04 moeda 9 Real
      "?" + #05-05 dígito verificador Geral do Código de barras
      fator_vencimento + #06-09 fator de vencimento
      valor_documento_formatado + #10-19 valor do documento
      "9" + # 9 fixo
      codigo_cedente + # 21 - 27 código cedente
      nosso_numero + # 28 - 40 nosso numero
      '0' + # 41 - 41 0 fixo
      carteira # 42 - 44 carteira
    end

    def agencia_codigo_cedente
      agencia + '/' + codigo_cedente
    end

    def nosso_numero
      ("%012d" % numero) + calculo_digito_verificador(numero.to_i, true).to_s
    end

    def nosso_numero_formatado
      nosso_numero
    end

    def caminho_logo
      'logo_santander.jpg'
    end

    def codigo_banco_formatado
      "033-7"
    end

    def carteira_formatado
      case carteira.to_s
      when '101' then 'COBRANCA SIMPLES - RCR'
      when '102' then 'COBRANCA SIMPLES - CSR'
      else carteira
      end
    end

    private

    def codigo_banco
      '033'
    end

    def moeda
      9
    end

    def fator_vencimento
      "%04d" % (data_vencimento - Date.new(1997, 10, 7)).to_i
    end

    def valor_documento_formatado
      "%010d" % (valor * 100)
    end

  end
end
