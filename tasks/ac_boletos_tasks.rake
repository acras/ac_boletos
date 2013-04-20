# coding: utf-8

namespace :ac_boletos do

  desc "Zerar e popular a tabela boletos com testes."
  task :populate_boletos => :environment do
    require 'populator'
    require 'faker'
    Boleto.delete_all
    CedenteBoletos.delete_all
    cedente = CedenteBoletos.create(
      :agencia => '0997',
      :codigo => '096070',
      :cnpj => '10637431000117',
      :nome_modelo => 'caixa_sigcb',
      :razao_social => 'Bruk Serviços de Informática'
      )

    opcoes_descricao = [
    "Serviços prestados no mês anterior.",
    "-30 horas de desenvolvimento de sistemas <br \>-Assistência técnica remota<br \>-Venda de um microcomputador",
    "Renovação do plano semestral de assinatura básica"
    ]

    i = 1
    Boleto.populate 100 do |boleto|
      boleto.nome_sacado = Faker::Name.name
      boleto.numero = i += 1
      boleto.valor = [100.00, 99.20, 20.90, 30.99]
      boleto.created_at = 2.months.ago..Date.yesterday.to_time
      boleto.data_processamento = boleto.created_at
      boleto.data_emissao = boleto.created_at
      boleto.data_vencimento = 45.days.ago.to_date..60.days.from_now.to_date
      boleto.access_key = String.random_alphanumeric
      boleto.descricao = opcoes_descricao
      boleto.cedente_boletos_id = cedente.id
      boleto.dado_adicional_1 = 'Valor do boleto por conta do cedente'
      boleto.dado_adicional_2 = 'Multa por atraso: 2% do valor do boleto'
      boleto.dado_adicional_3 = 'Juros de 0,33% ao dia de atraso, cobrados após o quinto dia'
      boleto.cpf_cnpj_sacado = ['007.591.579-01', '012.122.399-02', '07.054.505/0001-32', '120.222.122-95']
      boleto.logradouro_sacado = ['Rua do Berne', 'Des. Motta', 'XV de Novembro', 'Sete de Setembro']
      boleto.cidade_sacado = ['Curitiba', 'Ponta Grossa', 'Londrina', 'Maringá']
      boleto.estado_sacado = 'PR'
      boleto.cep_sacado = ['80.420-080', '80.250-060', '80.999-101']
      boleto.numero_sacado = ['123','3341','991-A','2131']
      boleto.aceite = 'N'
      boleto.instrucoes_1 = 'Não receber após 30 dias'
      boleto.instrucoes_2 = 'Não receber valor diferente do especificado'
      boleto.instrucoes_3 = ''
    end
  end
end
