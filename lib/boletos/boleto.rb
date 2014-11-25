# encoding: utf-8
#
module AcBoletos
  class Boleto
    ATTRIBUTES = [ :numero,
                  :numero_documento,
                  :carteira,
                  :nome_sacado,
                  :logradouro_sacado,
                  :numero_sacado,
                  :complemento_sacado,
                  :bairro_sacado,
                  :cep_sacado,
                  :data_processamento,
                  :data_emissao,
                  :data_vencimento,
                  :valor,
                  :descricao,
                  :aceite,
                  :nosso_numero,
                  :especie_documento,
                  :banco,
                  :cpf_cnpj_sacado,
                  :dado_adicional_1,
                  :dado_adicional_2,
                  :dado_adicional_3,
                  :cidade_sacado,
                  :estado_sacado,
                  :instrucoes_1,
                  :instrucoes_2,
                  :instrucoes_3,
                  :nome_cedente,
                  :cnpj_cedente,
                  :agencia,
                  :conta,
                  :codigo_cedente,
                  :modelo]
    ATTRIBUTES.each {|attr| attr_accessor attr }

    def initialize(obj_or_params={})
      if obj_or_params.is_a? Hash
        obj_or_params.each { |k, v| self.send("#{k}=", v) }
      else
        ATTRIBUTES.each {|a| self.send("#{a}=", obj_or_params.send(a)) }
      end
    end

    def numero_guia
      ''
    end

    def endereco_sacado_linha_1
      r = logradouro_sacado + ', ' + numero_sacado
      r = r + ' - ' + complemento_sacado if complemento_sacado
      r
    end

    def endereco_sacado_linha_2
      (cidade_sacado || '') + ' - ' + (estado_sacado || '') + ' - ' + (cep_sacado || '')
    end

    def cnpj_cedente_formatado
      cnpj_formatado(cnpj_cedente)
    end

    def local_pagamento
      ['Pagável em qualquer banco até o vencimento']
    end

    def carteira_formatado
      carteira
    end

    private

    def cnpj_formatado(val)
      "#{val[0..1]}.#{val[2..4]}.#{val[5..7]}/#{val[8..11]}-#{val[12..13]}"
    end

  end
end
