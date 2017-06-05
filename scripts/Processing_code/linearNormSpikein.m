function data=linearNormSpikein(dataInput,dataSpike,experiments,reference)
% data=linearNormSpikein(dataInput,dataSpike,experiments,saveFCS,reference)
% Estimates the covariance of each of the spike-in samples and then
% normalizes the data to a reference covariance

% Input:
% dataInput = CyTOFData object that will be normalized
% dataSpike = CyTOFData object that contains only the corresponding
% spike-in samples
% experiments = second output from the readNormalizedData script
% saveFCS indicates whether the processed data should be saved as .fcs file
% reference = index of the reference sample. If empty, chosen to be the
% first one
%
% TODO: Add a feature that does hypothesis testing to see if the distributions of the normalized
% spike-in samples match. This will help determine if linear normalization
% is sufficient.

% Author: Kevin Moon
% Created: June 2017

data=dataInput;
if isempty(reference)
    reference=1;
end

% Compute the reference covariance matrix

Cref=cov(dataSpike{reference}.dataTransformed);
variances=diag(Cref);
nzero=variances>0;
Cref=Cref(nzero,nzero);
[Vref,Dref]=eig(Cref);
Cref_root=Vref*diag(sqrt(diag(Dref)))*Vref';
mean_ref=mean(dataSpike{reference}.dataTransformed(:,nzero));

% Normalize all other files
for m=1:length(experiments)
    if m~=reference
        
%         Compute the covariance and mean of each spike-in, take its square
%         root
        C=cov(dataSpike{m}.dataTransformed(:,nzero));
        mean_spike=mean(dataSpike{m}.dataTransformed(:,nzero));
        [V,D]=eig(C);
        Croot=V*diag(1./sqrt(diag(D)))*V';
        
%         Normalize the data to the reference sample
        temp_data=data{m}.dataTransformed(:,nzero);
        temp_data=bsxfun(@minus,temp_data,mean_spike);
        temp_data=bsxfun(@plus,temp_data*Croot*Cref_root,mean_ref);
        data{m}.dataTransformed(:,nzero)=temp_data;
        
%         Set the nontransformed data to be the sinh of the normalized
%         transformed data. Essentially this is assuming that the
%         transformed data is more linear than the nontransformed data.
        data{m}.data=sinh(data{m}.dataTransformed);
        
    end
end




