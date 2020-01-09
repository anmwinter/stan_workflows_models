data {
int<lower=0> N; 
real x[N]; 
real Y[N]; 
} 
parameters {
real alpha; 
real beta;  
real<lower=.5,upper= 1> lambda;  
real<lower=0> tau; 
} 
transformed parameters {
real sigma; 
real m[N];
for (i in 1:N) 
m[i] = alpha - beta * pow(lambda, x[i]);
sigma = 1 / sqrt(tau); 
} 
model {
// priors
alpha ~ cauchy(0, 1); 
beta ~ cauchy(0, 1); 
lambda ~ normal(.5, .5); 
tau ~ gamma(.0001, .0001); 
// likelihood
Y ~ normal(m, sigma);   
}
generated quantities{
real Y_mean[N]; 
real Y_pred[N]; 
for(i in 1:N){
// Posterior parameter distribution of the mean
Y_mean[i] = alpha - beta * pow(lambda, x[i]);
// Posterior predictive distribution
Y_pred[i] = normal_rng(Y_mean[i], sigma);   
}
}
