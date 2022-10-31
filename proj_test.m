%proj_test: THIS FUNCTION TAKES SNR AS AN INPUT AND CALCULATES BER
%DATA LENGTH AND 'm' ARE PRE-DEFINED AND CAN BE CHANGED HERE
function ber=proj_test(snr)
%data and initialization
rng default
data=randi([0 1],10000,1);
ncol=length(data)/4;
x_1=zeros(1,ncol);
x_2=zeros(1,ncol);
x_3=zeros(1,ncol);
x_4=zeros(1,ncol);
bit=1;
c1=1;c2=1;c3=1;c4=1;
index_tracker=1;
kai=zeros(256,8);
kai_row=zeros(1,8);
min_indices=zeros(1,length(data)/8);
rx_bits=zeros(1,length(data));

%4-QAM modulation
mdata=qammod(data,4);

%multiplexing

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

%Generating channel and symbol matrix
H=nak_m(1000,4,4);
X=[x_1;x_2;x_3;x_4];

%transmission through channel
E=X.*conj(X);
Es=sum(E(1,:))+sum(E(2,:))+sum(E(3,:))+sum(E(4,:));%energy
Y_no_noise=sqrt(Es)*H*X;
Y=awgn(Y_no_noise,snr,'measured');

%Making the 'Kai' matrix
for i=0:255
    binstr=dec2bin(i,8);
    for j=1:8
        kai_row(j)=str2double(binstr(j)); 
    end
    kai(i+1,:)=kai_row;
end
 
%computing x_hat and finding indices with min error
for j=1:2:ncol-1
for i=1:256
    X_test=reform(kai(i,:));
    Hx=H*X_test;
    y_Hx=Y(:,j:j+1)-sqrt(Es)*Hx;
    x_hat=norm(y_Hx,'fro')^2;%frobenius norm is computed as 2 columns are being considered at a time, thus it is a matrix and not a vector so L2 norm is not applicable
    if i==1
        min_index=1;
        min=x_hat;
    end
    if i~=1 && x_hat<min
        min_index=i;
        min=x_hat;
    end
end
min_indices(index_tracker)=min_index;
index_tracker=index_tracker+1;
end

for i=1:length(min_indices)
    rx_bits(bit:bit+7)=kai(min_indices(i),:);%rx bits concatenation
    bit=bit+8;
end
[~,ber]=biterr(data.',rx_bits);%BER
end
