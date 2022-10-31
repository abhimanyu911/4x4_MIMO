%reform: THIS MULTIPLEXES THE BLOCK OF DATA BITS INTO A TRANSMISSION MATRIX
%X FOR ML DETECTION PURPOSES
function X_test=reform(data)
ncol=length(data)/4;
x_1=zeros(1,ncol);
x_2=zeros(1,ncol);
x_3=zeros(1,ncol);
x_4=zeros(1,ncol);
c1=1;c2=1;c3=1;c4=1;
mdata=qammod(data,4);
for i=1:8:(length(mdata)-1)
        x_1(c1)=mdata(i);
        x_1(c1+1)=mdata(i+1);
        c1=c1+2;
    
        x_2(c2)=mdata(i+2);
        x_2(c2+1)=mdata(i+3);
        c2=c2+2;
   
        x_3(c3)=mdata(i+4);
        x_3(c3+1)=mdata(i+5);
        c3=c3+2;
        
        x_4(c4)=mdata(i+6);
        x_4(c4+1)=mdata(i+7);
        c4=c4+2;
end
X_test=[x_1;x_2;x_3;x_4];
end

