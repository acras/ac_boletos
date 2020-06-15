# coding: utf-8

require 'boleto_utils'

module AcBoletos

  class BoletoItau < Boleto

    def local_pagamento
      ['Até o vencimento, preferencialmente no Itaú', 'Após o vencimento, somente no Itaú']
    end

    def linha_digitavel
      dv1 = dv2 = dv3 = '?'
      c = codigo_barras.to_s
      c1 = c[0..3] + c[19..19] + c[20..23]
      c2 = c[24..33]
      c3 = c[34..43]
      c4 = c[4..4]
      c5 = c[5..18]

      dv1 = calculo_digito_verificador_modulo_10_itau(c1)
      dv2 = calculo_digito_verificador_modulo_10_itau(c2)
      dv3 = calculo_digito_verificador_modulo_10_itau(c3)

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
      carteira + # 20 a 22 carteira
      nosso_numero + # 23 a 30 Nosso Número
      dv_agencia_conta_carteira_nosso_numero + # 31 a 31 DAC  [Agência /Conta/Carteira/Nosso Número]
      agencia_formatado + # 32 a 35 n. da agencia cedente
      conta_formatado + # 36 a 41 n da conta corrente (assumimos que já vem com dígito verificador
      "000" # 42 a 44 Zeros
    end

    def dv_agencia_conta_carteira_nosso_numero
      calculo_digito_verificador_modulo_10_itau(agencia_formatado + conta_formatado_sem_dv + carteira + nosso_numero)
    end

    def get_codigo_cedente_formatted
      codigo_cedente[0..-2] + "-" + codigo_cedente[-1..-1]
    end

    def agencia_codigo_cedente
      agencia + '/' + get_codigo_cedente_formatted
    end

    def nosso_numero
      "%08d" % numero
    end

    def nosso_numero_formatado
      carteira + "/" + nosso_numero + "-" + dv_agencia_conta_carteira_nosso_numero
    end

    def agencia_formatado
      sprintf("%04s", agencia[0..3]).gsub(" ", "0")
    end

    def conta_formatado
      # utiliza apenas dígitos numéricos
      sprintf("%06s", conta.scan(/\d/).join).gsub(" ", "0")
    end

    def conta_formatado_sem_dv
      conta_formatado[0..-2]
    end

    def caminho_logo
      'logo_itau.jpg'
    end

    def codigo_banco_formatado
      "341-7"
    end

    private

    def codigo_banco
      341
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

    def calculo_digito_verificador_modulo_10_itau(num)
      inteiros_a_calcular = num.to_s.split('').map {|i| i.to_i}

      n = num.size
      inteiros_fatores = (1..n).collect { |x| x % 2 + 1 }.reverse

      soma = multiplica_itens_arrays_e_soma(inteiros_fatores, inteiros_a_calcular, true)

      resto = soma % 10
      res = 10 - resto
      res > 9 ? 0.to_s : res.to_s
    end

  end
end
