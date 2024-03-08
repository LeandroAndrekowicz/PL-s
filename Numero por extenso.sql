CREATE OR REPLACE FUNCTION 
    extenso(
		num integer
    ) RETURNS text
AS
    $corpo$
DECLARE
	unidades text[] = array[
							'um', 'dois', 'três', 'quatro', 'cinco', 
							'seis', 'sete', 'oito', 'nove', 'dez', 'onze',
							'doze', 'treze', 'quatorze', 'quinze', 'dezesseis',
							'dezessete', 'dezoito', 'dezenove'
						   ];
	dezenas text[] = array [
							'dez', 'vinte', 'trinta', 'quarenta', 'cinquenta', 
							'sessenta', 'setenta', 'oitenta', 'noventa'
						   ];
	centenas text[] = array[
							'cem', 'duzentos', 'trezentos', 'quatrocentos',
						   	'quinhentos', 'seissentos', 'setessentos',
							'oitossentos', 'novessentos'
						   ];
	_numStr text;
	_aux text = '';
	_trinomas integer;
	_tr text;
	_x integer;
	_ver text;
	_y text;
BEGIN
	_numStr = num::text;
	/*
	if num > 99 then
		raise exception 'O numero nao pode ser maior que 99';
	end if;
	*/
	if num = 0 then
		return 'zero';
	end if;
	
	if length(_numStr) % 3 > 0 then
		_numStr = lpad(_numStr, 3 * ((length(_numStr) / 3) + 1), '0');
	end if;
	
	_trinomas = length(_numStr) / 3;
	for _x in reverse _trinomas..1 LOOP
		_tr =  substr(_numStr, _x * 3 - 2, 3);
		for _y in 1 .. 3 LOOP
			_ver = substr(_tr, _y, 1);
			if _y = 1 and _ver::integer > 0 then
				_aux = _aux || centenas[_ver::integer] || ' ';
			end if;
			if _y = 2 and _ver::integer = 1 then
				_ver = substr(_tr, _y, 2);
				_aux = _aux || ' e ' || unidades[_ver::integer] || ' ';
				exit;
			else
				if _y = 2 and _ver::integer > 0 then
					_aux = _aux || ' e ' || dezenas[_ver::integer] || ' ';
				end if;
				if _y = 3 and _ver::integer > 0 then
					_aux = _aux || 'e ' || unidades[_ver::integer] || ' ';
				end if;
			end if;
		END LOOP;
		
		raise notice '%', _tr;
	END LOOP;
	
	return trim(initcap(_aux));
END;
    $corpo$
LANGUAGE PLPGSQL;

select * from extenso(999);

/*
select length('Leandro'), lpad('12', 20, 'X'), rpad('12', 20, 'Y'), 
	substr('minha casa eh azul', 7, 4),
	strpos('minha casa eh azul', 'azul'),
	trim('    trem     '),
	ltrim('    trem     '),
	rtrim('    trem     '),
	trim('  trem   ', 'tr'),
	reverse('ordnael')
	
*/