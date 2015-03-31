# encoding: utf-8
#
require "#{File.dirname(__FILE__)}/../app/helpers/barcode_helper.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto_caixa.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto_real.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto_itau.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto_santander.rb"
require "#{File.dirname(__FILE__)}/boletos/boleto_banco_do_brasil.rb"
require 'ac_boletos/version'

ActionView::Base.send :include, BarcodeHelper

module AcBoletos

  module Rails
    class Engine < ::Rails::Engine
    end
  end

  def AcBoletos.generate_access_key(size=16)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s
  end

  def AcBoletos.boleto(params_or_obj)
    if params_or_obj.is_a?(Hash)
      modelo = params_or_obj[:modelo]
    else
      modelo = params_or_obj.modelo
    end
    ("AcBoletos::"+modelo).constantize.new params_or_obj
  end

  def render_boleto(params_or_obj)
    @boleto = AcBoletos.boleto(params_or_obj)
    render "boletos/show"
  end

end
