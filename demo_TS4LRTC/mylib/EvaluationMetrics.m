function [RSE,TCS]=EvaluationMetrics(T, T_hat,W)
RSE=norm(T_hat(:)-T(:),'fro')/norm(T(:),'fro');
W_hat=1-W;
TCS=norm(W_hat(:).*(T_hat(:)-T(:)),'fro')/norm(W_hat(:).*T(:),'fro');
% RMSE=norm(W(:).*(T_hat(:)-T(:)),'fro')/norm(W(:),'fro');
% MAE=sum(W(:).*abs(T_hat(:)-T(:)))/sum(W(:));
end