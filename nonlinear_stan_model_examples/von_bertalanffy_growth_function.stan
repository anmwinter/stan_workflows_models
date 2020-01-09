data {
int<lower=0> N; 
real<lower=0> x[N]; 
real<lower=5> Y[N];
}

parameters {
real alpha; // Asymptotic average length-at-age
real beta;  // Brody growth rate coefficient, yr-1
real<lower=0> tau; 
}

transformed parameters {
real<lower=0> sigma; 
real<lower=0> m[N];
for (i in 1:N) 
m[i] = alpha * (1 - exp(-beta * x[i]));
sigma = 1 / sqrt(tau);
} 

model {
// priors
alpha ~ normal(90, 1); // L-infinity for the silvery minnow 
beta ~ normal(.6, .1); // K for silvery minnow
tau ~ gamma(.0001, .0001); 
Y ~ normal(m, sigma); // likelihood
}

generated quantities{
real Y_mean[N]; 
real Y_pred[N]; 
for(i in 1:N){
Y_mean[i] = alpha * (1-exp(-beta * x[i]));  // Posterior parameter distribution of the mean
Y_pred[i] = normal_rng(Y_mean[i], sigma);  // Posterior predictive distribution
}
}
