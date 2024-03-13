create or replace function 
    contaPalavras(
        in idTexto integer,
        in palavra text,
		out numLinha integer,
        out totalPalavrasLinhas integer,
		out ocorrencias integer,
		out totalLinhas numeric
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
			numLinha := _i;
        END LOOP;
		ocorrencias := _contador;
		totalPalavrasLinhas := _contador_geral;

        RETURN NEXT;
    END LOOP;
    
    RETURN;
END
$corpo$
LANGUAGE PLPGSQL;

-- Exemplo de uso:
SELECT * FROM contaPalavras(1, 'george');




