# coding: utf-8

require File.dirname(__FILE__) + '/test_helper'

class BarcodeI25Test < ActiveSupport::TestCase
  test 'simbolos gerados corretamente' do
    preambulo = [:nb, :ns, :nb, :ns]
    posambulo = [:wb, :ns, :nb]
    valores_corretos = {
      1234567890 =>
        preambulo +
        [:wb, :ns, :nb, :ws, :nb, :ns, :nb, :ns, :wb, :ws, :wb, :ns,
         :wb, :ns, :nb, :ws, :nb, :ns, :nb, :ws, :wb, :ns, :nb, :ws,
         :wb, :ws, :nb, :ns, :nb, :ns, :nb, :ws, :nb, :ns, :nb, :ns, :wb,
         :ws, :wb, :ns, :nb, :ns, :wb, :ns, :nb, :ws, :wb, :ws, :nb, :ns
        ] + posambulo,
      8172 =>
        preambulo +
        [:wb, :ws, :nb, :ns, :nb, :ns, :wb, :ns, :nb, :ws,
         :nb, :ns, :nb, :ws, :nb, :ns, :wb, :ns, :wb, :ws
        ] + posambulo,

    }
    valores_corretos.each do |key, value|
      generated = BarcodeI25.new(key).generate
      if generated != value
        puts "For code #{@code.to_s} was expecting \n#{value.inspect} but generated \n#{generated.inspect}"
      end
      assert generated == value
    end
  end
end
