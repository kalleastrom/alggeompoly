function [ I ] = readM2ideal( fname, nv )

if nv > 0
    xx = create_vars(nv);
    m_one = multipol(1,zeros(nv,1));
    for k = 1:nv
        eval(['x' num2str(k) ' = xx(' num2str(k) ');']);
    end
end
fid = fopen(fname,'r');
line = fgetl(fid);
line = strrep(line,'ideal(','[');
line = strrep(line,')',']');

eval(['I = ' line ';']); 
if nv > 0
    I = I * m_one;
end
fclose(fid);

end

