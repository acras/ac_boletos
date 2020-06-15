# coding: utf-8

require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/../../lib/boleto_utils'

class BoletoUtilsTest < ActiveSupport::TestCase
  test "criação do dígito verificador do nosso número (por enquanto só da caixa)" do
    v = {
      '24000000000000021' => 7,
      '24000000000000002' => 0,
      '24000000000000025' => 0,
      '24000000000000008' => 0,
      '24000000000000016' => 0,
      '24000000000000023' => 3,
      '24000000000000014' => 4,
      '24000000000000020' => 9,
      '24000000000000022' => 5,
      '24000000000000024' => 1,
      '24000000000000007' => 1,
      '24000000000000009' => 8,
      '24000000000000010' => 1,
      '24000000000000012' => 8
    }

    v.each do |key, value|
      assert_equal value, calculo_digito_verificador(key.to_i, true)
    end
  end

  test "criação do DV dos campos 1 a 3" do
    v = {
      '0000000211' => 3,
      '0000000253' => 5,
      '0000000024' => 0,
      '104905507' => 0
    }

    v.each do |key, value|
      assert_equal value, calculo_digito_verificador_modulo_10(key)
    end
  end
end
