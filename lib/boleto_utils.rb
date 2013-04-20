# coding: utf-8

def calculo_digito_verificador(num, manter_zero = false)
  inteiros_a_calcular = num.to_s.split('').map {|i| i.to_i}
  inteiros_fatores = get_weights(inteiros_a_calcular.size)

  soma = multiplica_itens_arrays_e_soma(inteiros_fatores, inteiros_a_calcular)

  resto = soma % 11
  res = 11 - resto
  res = res > 9 ? 0 : res

  if ((res == 0) and !manter_zero)
    res = 1
  end
  res
end

def calculo_digito_verificador_modulo_10(num)
  inteiros_a_calcular = num.to_s.split('').map {|i| i.to_i}

  n = num.size
  inteiros_fatores = (0..n).collect { |x| x % 2 + 1 }.reverse
  inteiros_fatores.pop

  soma = multiplica_itens_arrays_e_soma(inteiros_fatores, inteiros_a_calcular, true)

  resto = soma % 10
  res = 10 - resto
  res > 9 ? 0 : res
end

def get_weights(n)
  (0..n - 1).collect { |x| x % 8 + 2 }.reverse
end

def multiplica_itens_arrays_e_soma(a1, a2, somar_se_maior_que_9 = false)
  a = (0..a1.size-1).collect do |i|
    r = a1[i] * a2[i]
    if somar_se_maior_que_9 and (r > 9)
      i1 = r / 10
      i2 = r % 10
      r = i1 + i2
      r = 0 if (r > 9)
    end
    r
  end
  soma = a.inject {|sum, n| sum + n}
  soma
end
