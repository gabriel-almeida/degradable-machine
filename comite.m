function retorno = comite(redes, entrada)
    quantRedes = size( redes,1 );
    respostas = zeros( quantRedes, size( entrada, 1 ) );
    
    for i=1:quantRedes
        respostas(i, :) = redes{i}(entrada'); %resposta vem por linhas
    end
    retorno = mean(respostas); % media
end