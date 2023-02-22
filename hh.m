volt=-50:150;
tau_m=[];
tau_h=[];
tau_n=[];
m_inf=[];
h_inf=[];
n_inf=[];

for v=-50:150
        tau_m=[tau_m,tau(alpham(v),betam(v))];
        tau_h=[tau_h,tau(alphah(v),betah(v))];
        tau_n=[tau_n,tau(alphan(v),betan(v))];
        m_inf=[m_inf,inf(alpham(v),betam(v))];
        h_inf=[h_inf,inf(alphah(v),betah(v))];
        n_inf=[n_inf,inf(alphan(v),betan(v))];
end

subplot(2,3,1)
plot(volt,tau_m)
title('Tau_m')

xlabel('v(mV)');
ylabel('tau(msec)')

subplot(2,3,2)
plot(volt,tau_h)
title('Tau_h')

xlabel('v(mV)');
ylabel('tau(msec)')

subplot(2,3,3)
plot(volt,tau_n)
title('Tau_n')

xlabel('v(mV)');
ylabel('tau(msec)')

subplot(2,3,4)
plot(volt,m_inf)
title('m_i_n_f')
xlabel('v(mV)');

subplot(2,3,5)
plot(volt,h_inf)
title('h_i_n_f')
xlabel('v(mV)');

subplot(2,3,6)
plot(volt,n_inf)
title('n_i_n_f')
xlabel('v(mV)');


function tau=tau(alpha,beta)
    tau=1/(alpha+beta);
end

function inf=inf(alpha,beta)
    inf=alpha/(alpha+beta);
end

function alpha_n=alphan(v)
    if v==10
        alpha_n=0.1;
    else
        alpha_n=0.01*(10-v)/(exp((10-v)/10)-1);
    end
end

function beta_n=betan(v)
    beta_n=0.125*exp(-v/80);
end

function alpha_m=alpham(v)
    if v==25
        alpha_m=1;
    else
        alpha_m=0.1*(25-v)/(exp((25-v)/10)-1);
    end
end

function beta_m=betam(v)
    beta_m=4*exp(-v/18);
end

function alpha_h=alphah(v)
    alpha_h=0.07*exp(-v/20);
end

function beta_h=betah(v)
    beta_h=1/(exp((30-v)/10)+1);
end

