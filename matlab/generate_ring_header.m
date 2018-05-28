function [ str ] = generate_ring_header( nv, opt )

varstr = '';

order = 1:nv;
if ~isempty(opt.monomial_order)
    order = order(opt.monomial_order);
end

for i=order
    varstr = [varstr sprintf('x%u,',i)]; %#ok
end

if strcmp(opt.backend,'M2')
    if ~strcmp(opt.coefficient_field,'Zp')
        error('Only Zp supported for M2 backend.');
    end
    
    str = sprintf('KK = ZZ / %d;\n',opt.prime_field);
    extra = '';
    if ~isempty(opt.M2_monomial_size)
        extra = sprintf(',MonomialSize=>%d',opt.M2_monomial_size);
    end
    
    if isfield(opt,'M2_monomial_ordering')
        extra = [extra sprintf(',MonomialOrder=>%s',opt.M2_monomial_ordering)];
    end
    
    if ~isempty(opt.M2_weights)
        w = opt.M2_weights;
        
        if isa(opt.M2_weights,'double')
            if size(w,2) == 1
                w = w';
            end
            extra = [extra ',MonomialOrder=>{'];
            for k = 1:size(w,1)
                extra = [extra 'Weights=>{' sprintf('%d,',w(k,:))];
                extra = [extra(1:end-1) '},'];
            end
            extra = [extra(1:end-1) '}'];
        else
            extra = [extra sprintf(',MonomialOrder=>{Weights=>{%s}}',w)];
        end
    end
    
    str = [str sprintf('R = KK[%s%s];\n',varstr(1:end-1),extra)];
elseif strcmp(opt.backend,'Singular')
    if strcmp(opt.coefficient_field,'Zp')
        str = sprintf('ring R=(integer,%d),(%s),dp;\n',opt.prime_field,varstr(1:end-1));
    elseif strcmp(opt.coefficient_field,'complex')
        str = sprintf('ring R=complex,(%s),dp;\n',varstr(1:end-1));
    else
        error('Unsupported coefficient field.');
    end
else
    error('Unknown backend.');
end

end

