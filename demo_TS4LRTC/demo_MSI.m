clc;
clear;
% close all;
addpath('mylib')
load('dataset/toy.mat')
%% normnize
msi=msi(:,:,1:30)/max(msi(:));

%% set sampling ratio
 SamplingRatio=0.02;

 %% set Observed data
 
     T = msi(:,:,21:30); %%b=10
     P=[5,10,15,20]
      SizeT = size(T);
       for h=1:4       
     Xs=msi(:,:,1:P(h)); %% Auxiliary data  
     sizeXs=size(Xs);
     
     %% 
     KK=[60 60 5];
     for n=1:3        
     par.K=KK(n);
     par.lambda=1e-5;
     D= Nonnegative_DL(Unfold(Xs,sizeXs,n), par );
     A{n}=orth(D);
     end
    if  P(h)~=10
        A{3}=eye(SizeT(3)) ;
    end
%
  
Omega=zeros(SizeT);
ind = find(rand(prod(SizeT),1)<SamplingRatio);
Omega(ind) = 1;
 TX =T.*Omega; %% generate missing data
  beta=0.05/norm(TX(:),'fro');
% Appropriate parameter adjustment can yield a better RSE result.
       lambda_G= exp(linspace(log(0.01),log(10), 10));
       lambda_M= exp(linspace(log(0.01),log(100), 10));
% for k=1:1:length(lambda_G)
%     for l=1:1:length(lambda_M)
% % %% main algorithm: tensor completion with side information
% X_new=TCSI_v1(TX,Omega,A,beta,lambda_G(k),lambda_M(l));
%  RSE1(k,l)=norm(X_new(:)-T(:),'fro')/norm(T(:),'fro');
%     end
% end
%    [b1, b2] = find(RSE1 == min(min(RSE1)));

   
     tic;
    T_TCSI{h}=TCSI_v1(TX,Omega,A,beta,lambda_G(2),lambda_M(7));
    time_TCSI(h)=toc;
    [RSE_TCSI(h), TCS_TCSI(h)] = EvaluationMetrics(T, T_TCSI{h},Omega);
    disp([ ' done in ' num2str(time_TCSI(h)), ' s.'])
    disp([ ' RSE ' num2str(RSE_TCSI(h)), ' .'])
    disp([ ' TCS ' num2str(TCS_TCSI(h)), ' .'])


    end




