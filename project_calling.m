%CALLING SCRIPT: This script is used to call the main functions that will
%help us calculate BER for the given values of SNR and plot it accordingly.
BER=zeros(1,11);
ber_counter=1;
for i=0:2.5:25
    BER(ber_counter)=proj_test(i);
    ber_counter=ber_counter+1;
end
SNR=0:2.5:25;
%BER=berawgn(SNR,'qam',4,'nondiff');
semilogy(SNR,BER,'*--');

xlabel('SNR(dB)->')
ylabel('BER(log scale)->')
title("BER(log scale) v SNR with varying m as m->\infty");
legend("m=1","m=1000","AWGN(4-QAM)");
%m values are changed manually in the proj_test function
hold on
