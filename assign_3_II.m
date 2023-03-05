
% input values
spike_interval=30;
tau=10;
Iinj=0; % Assumed to be zero
E=70;
Vthr=5;
Vspk=70;


time=1:500; % time range 0 to 500 (Tmax given 500)
delta_t=1; % dt
g_final=[]; % array for g values
u=[];
voltage=[];
Isyn=[];

% initial values
g=0;
z=0;
v=0;
I=0;

% iterative method for calculating z and g 
for t=1:500
    
    g_final=[g_final,g]; % store g in array
    voltage=[voltage,v];
    u=[u,u_t(spike_interval,t)];
    Isyn=[Isyn,I];

    I=g*(v-E); % Synaptic Current
    
    if v~=Vspk % If V(t-1) is not spiked
        v=v+delta_t*v_func(g,v,Iinj);
    else
        v=0; % if V(t-1) is spiked, new v=0
    end

    % Spiking V at Threshold
    if v>=Vthr 
        v=Vspk;
    end

    % Calculating conductance and z
    g=g+delta_t*g_func(g,tau,z);
    z=z+delta_t*z_func(z,tau,t,spike_interval); 
    
end

% Plot conductance vs time 
subplot(4,1,1)
plot(time, g_final)
title('Synaptic Conductance vs Time')
xlabel('Time (ms)')
ylabel('g (muS)')

% Plot input spike train vs time 
subplot(4,1,2)
plot(time, u)
title('Input Spike vs Time')
xlabel('Time (ms)')
ylabel('u')
ylim([-0.5,1.5])

% Plot Synaptic Current vs time 

subplot(4,1,3)
plot(time,Isyn)
title('Synaptic Current vs Time')
xlabel('Time (ms)')
ylabel('Isyn')

% Plot Postsynaptic Membrane Voltage vs time 
vthr_arr=linspace(5,5,length(time));
subplot(4,1,4)
plot(time, voltage);
hold on;
plot(time,vthr_arr,'r--');
hold off;
title('Postsynaptic Membrane Voltage vs Time')
xlabel('Time (ms)')
ylabel('v (volts)')
legend('','Vthr')

% Function for dv/dt
function v_func=v_func(g,v,Iinj)
    C=1;
    R=10;
    E=70;
    v_func=(1/C)*((-v/R)-(g*(v-E))+Iinj);
end

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
    gpeak=0.01;
    Gnorm=gpeak/(tau/e);
end
