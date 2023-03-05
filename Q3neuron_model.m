
tau_syn=15;
tau_thresh=50;

Iinj1=1.1; % Injected current in Neuron1
Iinj2=0.9; % Injected current in Neuron2

Einh=-15; % Synaptic reverse Potential


Vspk=70; % Spiked Voltage -> Action potential amplitude

time=1:1500; % time range 0 to 500 (Tmax given 500)
delta_t=1; % dt

voltage1=[]; % Membrane Potential for Neuron 1
voltage2=[]; % Membrane Potential for Neuron 1
vthresh1=[]; % Threhold level for neuron 1
vthresh2=[]; % Threhold level for neuron 2

% initial values
g1=0;
g2=0;

z1=0;
z2=0;

v1=0;
v2=0;

vthr1=0; 
vthr2=0; 

% iterative method
for t=1:1500
    
    voltage1=[voltage1,v1];
    voltage2=[voltage2,v2];
    vthresh1=[vthresh1,vthr1];
    vthresh2=[vthresh2,vthr2];
    
    % Spike inpu for Neuron 2
    if v1==Vspk
        u2=1;
    else
        u2=0;
    end

    % Spike inpu for Neuron 1
    if v2==Vspk
        u1=1;
    else
        u1=0;
    end

    % Neuron 1 
    vthr1=vthr1+delta_t*vthr_func(vthr1,v1,tau_thresh);
    
    if v1~=Vspk
        v1=v1+delta_t*v_func(g1,v1,Iinj1);
    else
        v1=Einh;
    end

    if v1>=vthr1
        v1=Vspk;
    end

    g1=g1+delta_t*g_func(g1,tau_syn,z1);
    z1=z1+delta_t*z_func(z1,tau_syn,u1); 

    % Neuron 2 
    vthr2=vthr2+delta_t*vthr_func(vthr2,v2,tau_thresh);
    
    if v2~=Vspk
        v2=v2+delta_t*v_func(g2,v2,Iinj2);
    else
        v2=Einh;
    end

    if v2>=vthr2
        v2=Vspk;
    end

    g2=g2+delta_t*g_func(g2,tau_syn,z2);
    z2=z2+delta_t*z_func(z2,tau_syn,u2); 
    
end

% Plot Membrane Voltage of Neuron 1 and Neuron 2 vs time 
plot(time, voltage1,'b-');
hold on;
plot(time,vthresh1,'r--');
hold on;
plot(time, 100+voltage2,'g-');
hold on;
plot(time,100+vthresh2,'r--');
hold off;

title('Membrane Voltage vs Time for Neuron 1 and Neuron 2')
xlabel('Time (ms)')
ylabel('Membrane Potential')
legend('Neuron1','Vthr','Neuron2')

% Function for Threhold 
function vthr_func=vthr_func(vthr,v,tau_thresh)
    vthr_func=((-vthr+v)/tau_thresh);
end

% Function for dv/dt
function v_func=v_func(g,v,Iinj)
    C=1;
    R=10;
    E=-15;
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
function z_func=z_func(z,tau,u)
    z_func=(-z/tau)+(Gnorm(tau)*u);
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
