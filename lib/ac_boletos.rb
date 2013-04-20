# encoding: utf-8

module AcBoletos

  def AcBoletos.generate_access_key(size=16)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s
  end

  def render_boleto(params_or_obj)
    # TODO
    # efetua validação
    if params_or_obj.is_a?(Hash)
      modelo = params_or_obj[:modelo]
    else
      modelo = params_or_obj.modelo
    end
    @boleto = ("AcBoletos::"+modelo).constantize.new params_or_obj
    render "boletos/show"
  end

end
