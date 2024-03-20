/*
	Criar função que valida cpf/cnpj em PLPGSQL
	Se for válida retoranar o CPF/CNPJ passado
	Se for inválida retornar "" (vazio);
*/

create or replace function validaCpf(
 	 cpfCnpj text
) returns text
AS
	$corpo$
DECLARE
	_auxCpfCnpj text;
	_i integer;
	_soma integer = 0;
	_primeiroVerificador integer;
	_segundoVerificador integer;
	_dg integer;
	_y integer = 2;
	_cpf text;
BEGIN
	_auxCpfCnpj = replace(cpfCnpj, '.', '');
	
	_auxCpfCnpj = replace(_auxCpfCnpj, '-', '');
	
	_auxCpfCnpj = replace(_auxCpfCnpj, '/', '');
	
	_cpf = _auxCpfCnpj;
	
	/*Aqui verifico CPF*/
	if length(_auxCpfCnpj) = 11 then
		_auxCpfCnpj = substr(_auxCpfCnpj, 1, 9);

		for _i in reverse length(_auxCpfCnpj)..1 loop
			_dg = substr(_auxCpfCnpj, _i, 1);

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

		_auxCpfCnpj = substr(_cpf, 1, 10);


		for _i in reverse length(_auxCpfCnpj)..1 loop
			_dg = substr(_auxCpfCnpj, _i, 1);

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
		
		
		/*Aqui verifico o CNPJ*/
		else if length(_auxCpfCnpj) = 14 then
			_auxCpfCnpj = substr(_auxCpfCnpj, 1, 12);
			
			for _i in reverse length(_auxCpfCnpj)..1 loop

				_dg = substr(_auxCpfCnpj, _i, 1);
				
				if _y > 9 then
					_y = 2;
				end if;

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
			
			if substr(_cpf, 13, 1)::integer != _primeiroVerificador then
				return '';
			end if;
			
			_auxCpfCnpj = substr(_cpf, 1, 13);
			
			for _i in reverse length(_auxCpfCnpj)..1 loop
				_dg = substr(_auxCpfCnpj, _i, 1);
				
				if _y > 9 then
					_y = 2;
				end if;

				_soma = _soma + _dg * _y;

				_y = _y + 1;
			end loop;
			
			_segundoVerificador = _soma  % 11;
			
			if _segundoVerificador < 2 then
				_segundoVerificador = 0;
			else
				_segundoVerificador = 11 - _segundoVerificador;
			end if;
			
			if substr(_cpf, 14, 1)::integer != _primeiroVerificador then
				return '';
			end if;
		/*Aqui é a exceção */
		else 
			raise exception 'O campo deve ser CPF ou CNPJ';
		end if;
	end if;	
	
	return cpfCnpj;
END
	$corpo$
LANGUAGE PLPGSQL;

select * from validaCpf('64.361.006/0001-77')