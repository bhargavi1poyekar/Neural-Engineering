delta_t=1;
n=100;
resistors=[2,5,10,20,50];
time=uint32(0):uint32(100);

for r=1:5
    voltage=[];
    v=0;
    for t=0:n
        voltage=[voltage,v];
        if t>10 && t<=60
            I=1;
        else
            I=0;
        end
        v=v+delta_t*voltage_fun(I,v,resistors(r));
    end
    disp(length(voltage))
    disp(length(time))
    plot(time,voltage)
    hold on
   
    
end
hold off

title('RC-circuit Step Response')
xlabel('Time')
ylabel('Voltage')
legend('r=2','r=5','r=10','r=20','r=50')

function diff_eqn_val=voltage_fun(I,v,R)
    C=1;
    diff_eqn_val=(I/C)-(v/R*C);
end
