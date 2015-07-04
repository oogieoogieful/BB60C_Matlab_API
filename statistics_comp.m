comp_max = comp_max./10;
comp_max = 10.^ comp_max;
comp_min = comp_min./10;
comp_min = 10.^ comp_min;
for i=1:length(comp_max(:,1))
    comp_max(i,harmonic_idx)=comp_max(i,harmonic_idx)-linear_power_harmonic;
end
comp_max=abs(comp_max);
meanval = comp_max + comp_min;
comp_max = log10(comp_max);
comp_min = log10(comp_min);
comp_max = comp_max .* 10;
comp_min = comp_min .* 10;
meanval = log10(meanval);
meanval = 10.* meanval;
meanval = meanval - 3;

for i=1:length(comp_max(:,1))
    comp_max(i,:)=comp_max(i,:)+power_filter;
    comp_min(i,:)=comp_min(i,:)+power_filter;
    meanval(i,:)=meanval(i,:)+power_filter;
end

