
% input values
spike_interval=input("Enter spike interval: ");
tau=input("Enter value of tau: ");

time=0:500; % time range 0 to 500 (Tmax given 500)
delta_t=1; % dt
g_final=[]; % array for g values

% initial values
g=0;
z=0;

% iterative method for calculating z and g 
for t=0:500
    g_final=[g_final,g]; % store g in array
    z=z+delta_t*z_func(z,tau,t,spike_interval); 
    g=g+delta_t*g_func(g,tau,z);
end

% Plot conductance vs time 
plot(time, g_final)
title(sprintf('Spike Interval=%d ms,tau=%d ms',spike_interval,tau))
xlabel('Time (ms)')
ylabel('g (muS)')


% Function for spike_interval
function u_t=u_t(spike_interval,t)
    if mod(t,spike_interval)==0 && t~=0
        u_t=1;
    else
        u_t=0;
    end

end

% function to calculate dg/dt 
function g_func=g_func(g,tau,z)
    g_func=(-g/tau)+z;
end

% function to calculate dz/dt
function z_func=z_func(z,tau,t,spike_interval)
    z_func=(-z/tau)+(Gnorm(tau)*u_t(spike_interval,t));
end

% function to calculate e^(-t/tau)
function eterm=eterm(t,tau)
    eterm=exp(-t/tau);
end

% function for Gnorm 
function Gnorm=Gnorm(tau)
    e=2.718;
    gpeak=0.1;
    Gnorm=gpeak/(tau/e);
end
