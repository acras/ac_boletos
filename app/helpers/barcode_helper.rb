# coding: utf-8

require 'barcode_i25'

module BarcodeHelper
  def barcode_i25_with_images(code)
    a = BarcodeI25.new(code).generate.map{|c| image_tag("ac_boletos/#{c.to_s}.gif")}.join
    if a.respond_to?('html_safe')
      a.html_safe
    else
      a
    end
  end
end
