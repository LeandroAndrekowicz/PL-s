/*
select 'Texto linha 1'||E'\n'||'Texto linha 2';

select string_to_array('Texto linha 1'||E'\n'||'Texto linha 2',E'\n');
*/

create or replace function 
	contaPalavras(
		in idTexto integer,
		in palavra text,
		out totalLinhas numeric,
		out totalPalavrasLinhas numeric,
		out numLinha numeric
	) returns setof record
AS 
	$corpo$
DECLARE
	_linhas text[];
	_texto text;
	_linha text;
	_palavras text[];
	_palavra text;
	_contador integer;
	_contador_geral integer;
	_i integer;
BEGIN
	SELECT texto from texto_grande WHERE id = idTexto into _texto;
	
	_linhas = string_to_array(_texto,E'\n');
	
	for _i in 1 .. array_upper(_linhas, 1) loop
		_linha = _linhas[_i];
		_palavras = string_to_array(_linha, ' ');
		_contador = 0;
		FOREACH _palavra in ARRAY _palavras
		loop
			if palavra = _palavra then
				_contador =  _contador +1;
				_contador_geral = _contador_geral + _contador;
			end if;
		end loop;
		totalLinhas = _i;
	end loop;
	totalPalavrasLinhas = _contador_geral;
	return next;
END
	$corpo$
LANGUAGE PLPGSQL;

select * from contaPalavras(2, 'sherek');
