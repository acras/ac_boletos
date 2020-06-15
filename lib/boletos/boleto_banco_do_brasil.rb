# coding: utf-8

require 'boleto_utils'

module AcBoletos

  class BoletoBancoDoBrasil < Boleto

    def local_pagamento
      ['Pagável em qualquer banco até o vencimento']
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
      codigo_banco.to_s + #01-03 código do banco
      moeda.to_s + #04-04 moeda 9 Real
      "?" + #05-05 dígito verificador Geral do Código de barras
      fator_vencimento + #06-09 fator de vencimento
      valor_documento_formatado + #10-19 valor do documento
      "0"*6 + # 20 a 25 zeros
      nosso_numero + # 26 a 42 nosso número
      carteira[0..1] # 43 a 44 Tipo de Carteira/Modalidade de Cobrança
    end

    def agencia_codigo_cedente
      agencia[0..3]+"-"+agencia[4] + '/' + conta[0..(conta.length-2)]+"-"+conta[-1]
    end

    def nosso_numero
      ("%07d" % codigo_cedente) + ("%010d" % numero)
    end

    def nosso_numero_formatado
      nosso_numero
    end

    def agencia_formatado
      sprintf("%04s", agencia[0..3]).gsub(" ", "0")
    end

    def conta_formatado
      # utiliza apenas dígitos numéricos
      sprintf("%09s", conta.scan(/\d/).join).gsub(" ", "0")
    end

    def conta_formatado_sem_dv
      conta_formatado[0..-2]
    end

    def caminho_logo
      'logo_bb.jpg'
    end

    def codigo_banco_formatado
      "001-9"
    end

    private

    def codigo_banco
      '001'
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
