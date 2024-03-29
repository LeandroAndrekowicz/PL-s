create or replace function 
    contaPalavras(
        in idTexto integer,
        inout palavra text,
		out totalLinhas numeric,
		out numLinha integer,
		out ocorrencias integer,
		out totalPalavrasLinhas integer
    ) returns setof record
AS 
    $corpo$
DECLARE
    _linhas text[];
    _texto text;
    _linha text;
    _palavras text[];
    _palavra text;
    _contador integer := 0;
    _contador_geral integer := 0;
    _i integer;
BEGIN
    SELECT texto FROM texto_grande WHERE id = idTexto INTO _texto;
    
    _linhas = string_to_array(_texto, E'\n');
    totalLinhas := array_length(_linhas, 1);

    for _i in 1 .. array_upper(_linhas, 1) loop
        _linha = _linhas[_i];
        _palavras = string_to_array(_linha, ' ');
        _contador := 0;

        FOREACH _palavra IN ARRAY _palavras LOOP
            IF TRANSLATE(
				LOWER(palavra), 
				'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ',
				'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC'
			) 
			= 
			TRANSLATE(
				LOWER(_palavra),
				'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ',
				'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC'
			) 
			THEN
                _contador := _contador + 1;
                _contador_geral := _contador_geral + _contador;
            END IF;
        END LOOP;
		
    END LOOP;
		
	ocorrencias = _contador_geral;
	
	
	for _i in 1 .. array_upper(_linhas, 1) loop 
		_contador = 0;
        _linha = _linhas[_i];
        _palavras = string_to_array(_linha, ' ');

        FOREACH _palavra IN ARRAY _palavras LOOP

            IF TRANSLATE(
				LOWER(palavra), 
				'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ',
				'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC'
			) 
			= 
			TRANSLATE(
				LOWER(_palavra),
				'áéíóúàèìòùãõâêîôôäëïöüçÁÉÍÓÚÀÈÌÒÙÃÕÂÊÎÔÛÄËÏÖÜÇ',
				'aeiouaeiouaoaeiooaeioucAEIOUAEIOUAOAEIOOAEIOUC'
			) 
			THEN
                _contador := _contador + 1;
                _contador_geral := _contador_geral + _contador;
            END IF;

        END LOOP;
		numLinha := _i;
		totalPalavrasLinhas = _contador;
		
		if totalPalavrasLinhas > 0 then
			totalPalavrasLinhas = _contador;
        	RETURN NEXT;
		end if;
    END LOOP;

    RETURN;
END
$corpo$
LANGUAGE PLPGSQL;

-- Exemplo de uso:
SELECT * FROM contaPalavras(2, 'que');

