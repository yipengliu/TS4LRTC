clc;
clear;
 fname = strcat('dataset/RGB.png');
T = im2double(imread(fname));
SizeT=size(T);

%% set side information 
%%  Dictionary learning : Dictionary is used to explore the side information
fname = strcat('dataset/IR.png');
TXs = imread(fname);
 Xs = im2double(TXs(1:365,1:488,1));
     sizeXs=size(Xs);
     for n=1:2
       par.K=ceil(SizeT(n)/5);
     par.lambda=1e-5;
     D= Nonnegative_DL(Unfold(Xs,sizeXs,n), par );
     A{n}=orth(D);
     end
     A{3}=eye(SizeT(3),SizeT(3));  
 
%% set sampling ratio
SamplingRatio=0.05;
Omega=zeros(SizeT);
ind = find(rand(prod(SizeT),1)<SamplingRatio);
Omega(ind) = 1;
TX =T.*Omega;
  beta=0.5/norm(TX(:),'fro');
       lambda_G= exp(linspace(log(0.01),log(100), 10));
   lambda_M= exp(linspace(log(0.01),log(100), 10));
for k=1:1:length(lambda_G)
    for l=1:1:length(lambda_M)
% %% main algorithm: tensor completion with side information
X_new=TCSI_v1(TX,Omega,A,beta,lambda_G(k),lambda_M(l));
RSE1(k,l)=norm(X_new(:)-T(:),'fro')/norm(T(:),'fro');
    end
end
% 
% %% test

     [b1, b2] = find(RSE1 == min(min(RSE1)));
% X_new=TCSI_v1(TX,Omega,A,lambda_G(b1),lambda_M(b2));

tic;
X_new=TCSI_v1(TX,Omega,A,beta,lambda_G(4),lambda_M(5));
Time = toc;   
 [RSE , TCS] = EvaluationMetrics(T, X_new,Omega);
    disp([ ' done in ' num2str(Time ), ' s.'])
    disp([ ' RSE ' num2str(RSE ), ' .'])
    disp([ ' TCS ' num2str(TCS ), ' .'])


