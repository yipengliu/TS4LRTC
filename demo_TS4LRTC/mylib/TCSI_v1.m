%% main algorithm: tensor completion with side information
function [X_new,relChgXPath]=TCSI_v1(T,Omega,A,beta,lambda_G,lambda_Y)
%-----------------------------------------------------------------------------------------------------
% Model: min  lambda_Y*sum alpha(t)rank(Y(t))+ lambda_G*(rank(G))
%        s.t. X=G*_1A_1*_2A2*3A3+Y, X(Omega)=T(Omega)
%
% 
%--------------------------------INPUTs----------------------------------------------------------
sizeX=size(T);
known=find(Omega);
N    = prod(sizeX);
X_new=T.*Omega;

%  beta=0.05/norm(X_new(:),'fro');
% beta=0.05 for MSI;

%%  check and initilization
if ~exist('opts','var'); opts=[]; end
if isfield(opts,'maxIter'); maxIter = opts.maxIter; else maxIter =100; end
if isfield(opts,'tol');  tol = opts.tol; else tol = 1e-6; end
% if isfield(opts,'beta'); beta = opts.beta; else beta(1)=0.01; beta(2)=0.001; end
if isfield(opts,'isCont')
    isCont = opts.isCont; contpar = opts.contpar; contfactor = opts.contfactor;
 else
    isCont = true; contpar = 0.95; contfactor = 1.05;
end
display  = 1;

%  scrsz = get(0,'ScreenSize');
%  h1 = figure('Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.6 scrsz(4)*0.4]); 
%  figure(h1);

% initial
Y_new=randn(sizeX);
G_new=randn(size(A{1},2),size(A{2},2),size(A{3},2));
nr1_pre=0;
Lambda=zeros(sizeX);
sizeG=size(G_new);
 alpha_G=[sizeG(1),sizeG(2),sizeG(3)];
% alpha_G=[1,1,1];
alpha_G=alpha_G./sum(alpha_G);
sizeY=size(Y_new);
 alpha_Y=[sizeY(1),sizeY(2),sizeY(3)];
% alpha_M=[1,1,1];
alpha_Y=alpha_Y./sum(alpha_Y);

for iter=1:maxIter
    G_old=G_new;
    X_old=X_new;
    Y_old=Y_new;
          %% update G
          
Gsum=0;
for i=1:ndims(G_old)
    G_hat{i}=Fold(Pro2TraceNorm(Unfold(TensorChainProductT(X_old-Y_old+Lambda/beta,A,1:3), sizeG, i), alpha_G(i)*lambda_G/beta), sizeG, i);  
    Gsum=Gsum+G_hat{i};
end
G_new=Gsum/ndims(G_old);
X_G=TensorChainProduct(G_new,A,1:3);
%% update Y
     Ysum=0;
for i=1:ndims(Y_old)
    Y_hat{i}=Fold(Pro2TraceNorm(Unfold(X_old+Lambda/beta-X_G, sizeY, i), alpha_Y(i)*lambda_Y/beta), sizeY, i);  
    Ysum=Ysum+Y_hat{i};
end
Y_new=Ysum/ndims(Y_old);


    %% Update X
    X=X_G+Y_new-Lambda/beta;
    X_new=X.*(1-Omega)+T.*Omega;
    %% Update Lambda,beta
    temp_err=X_new-Y_new-X_G;
    Lambda=Lambda+beta*temp_err;
  
        %% stop Criterion 
       %- terminating the algorithm and saving some ralted information  
    relChgG = norm(G_new(:)- G_old(:),'fro')/norm(G_old(:));
    relChgX = norm(X_new(:)- X_old(:),'fro')/norm(X_old(:));
   
    relChgGPath(iter) = relChgG;
    relChgXPath(iter) = relChgX;

	if  display
        fprintf('Iter: %d, relChgG:%4.4e,  relChgX: %4.4e\n', iter, relChgG, relChgX);
    end
    
    if (iter> 50) &&  (relChgX < tol ) 
          disp(' !!!stopped by termination rule!!! ');  break;
    end
    
       beta= contfactor*beta;
   


end

end