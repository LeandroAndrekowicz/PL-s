/*
	Criar função que valida cpf/cnpj en PLPGSQL
	Se for válida retoranar o CPF/CNPJ passado
	Se for inválida retornar "" (vazio);
*/

create or replace function validaCpf(
 	 cpf text
) returns text
AS
	$corpo$
DECLARE
	_auxCpf text;
	_i integer;
	_soma integer = 0;
	_primeiroVerificador integer;
	_segundoVerificador integer;
	_dg integer;
	_y integer = 2;
	_cpf text;
BEGIN
	_auxCpf = replace(cpf, '.', '');
	
	_auxCpf = replace(_auxCpf, '-', '');
	
	_auxCpf = replace(_auxCpf, '/', '');
	
	_cpf = _auxCpf;
	
	if length(_auxCpf) = 11 then
		raise notice 'é 11';
	end if;
	
	_auxCpf = substr(_auxCpf, 1, 9);
	
	for _i in reverse length(_auxCpf)..1 loop
		_dg = substr(_auxCpf, _i, 1);
		
		_soma = _soma + _dg * _y;
		
		_y = _y + 1;
	end loop;
	
	_y = 2;
	
	_primeiroVerificador = _soma % 11;
	
	_soma = 0;
	
	
	if _primeiroVerificador < 2 then
		_primeiroVerificador = 0;
	else 
		_primeiroVerificador = 11 - _primeiroVerificador;
	end if;
	
	if substr(_cpf, 10, 1)::integer != _primeiroVerificador then
		return '';
	end if;
	
	_auxCpf = substr(_cpf, 1, 10);
	
	
	for _i in reverse length(_auxCpf)..1 loop
		_dg = substr(_auxCpf, _i, 1);
		
		_soma = _soma + _dg * _y;
		
		_y = _y + 1;
	end loop;
	
	_segundoVerificador = _soma  % 11;
	
	if _segundoVerificador < 2 then
		_segundoVerificador = 0;
	else
		_segundoVerificador = 11 - _segundoVerificador;
	end if;
	
	if substr(_cpf, 11, 1)::integer != _segundoVerificador then
		return '';
	end if;
	
	return cpf;
END
	$corpo$
LANGUAGE PLPGSQL;



select * from validaCpf('107.560.699-19')
