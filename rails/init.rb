# coding: utf-8

require 'ac_boletos'

require "#{File.dirname(__FILE__)}/../app/helpers/barcode_helper.rb"
require "#{File.dirname(__FILE__)}/../lib/boletos/boleto.rb"
require "#{File.dirname(__FILE__)}/../lib/boletos/boleto_caixa.rb"
require "#{File.dirname(__FILE__)}/../lib/boletos/boleto_real.rb"
require "#{File.dirname(__FILE__)}/../lib/boletos/boleto_itau.rb"

ActionView::Base.send :include, BarcodeHelper

