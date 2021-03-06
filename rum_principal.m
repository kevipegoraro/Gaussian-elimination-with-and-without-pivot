% In this script, the tri-diagonal matrix system generated by the Crank – Nicolson method 
% applied to the diffusion equation, for one and two dimensions, will be solved. 
% This problem arises naturally when solving many different EDP’s by implicit methods, 
% so it has enormous importance in engineering, physics and applied mathematics.

% In this project we find solutions for the different methods of the computational linear 
% algebra discipline applied to different practical situations. Gaussian elimination, 
% with and without pivot. LU decomposition, with and without pivot. Cholesky decomposition. 
%Matrix inversion.

% Author: Kévi Pegoraro, 2020, e-mail: kevipegoraro@hotmail.com

% method can be equal: LU, Ge, GeP, cho, inv
function rum_principal(method) 
[Nt Nx x v t MMl MMr] = cn_initial(); 
%Implementation of the Crank-Nicholson method with:  
total = ones(1,Nt+1); total(1) = cputime(); totalsum=0;
switch (method)
  case 'LU'
    % LU decomposition 
    [L,U]=lu(MMl); 
    for k=1:Nt % The time loop
        vv=v(2:Nx,k); 
        qq=MMr*vv; 
        w(1)=qq(1); 
        for j=2:Nx-1 
            w(j)=qq(j)-L(j,j-1)*w(j-1);
        end
        v(Nx,k)=w(Nx-1)/U(Nx-1,Nx-1); 
        for i=Nx-1:-1:2 
            v(i,k+1)=(w(i-1)-U(i-1,i)*v(i+1,k+1))/U(i-1,i-1);  
        end
        total(k+1) = cputime(); total(k)=total(k+1)-total(k); totalsum=totalsum+total(k);     
    end
    T='Temp. in Crank-Nicholson method (LU decompositiont)';
  case 'Ge'
    % Gaussian elimination without pivot
    for k=1:Nt % The time loop
        [A B] = Ge(MMl, MMr*v(2:Nx,k)); 
        v(2:Nx,k+1)=solvesup(A,B); 
        total(k+1) = cputime(); total(k)=total(k+1)-total(k); totalsum=totalsum+total(k);     
    end
    T='Temp. in Crank-Nicholson method (Gaussian elimination without pivot)';
  case 'GeP'
    % Gaussian elimination with pivot
    for k=1:Nt % The time loop
        [A B] = GeP(MMl, MMr*v(2:Nx,k)); 
        v(2:Nx,k+1)=solvesup(A,B); 
        total(k+1) = cputime(); total(k)=total(k+1)-total(k); totalsum=totalsum+total(k);     
    end
    T='Temp. in Crank-Nicholson method (Gaussian elimination with pivot)';
  case 'cho'
    %Cholesky decomposition 
    [GT]=chol(MMl);  
    for k=1:Nt % The time loop
        v(2:Nx,k+1)=solvesup(GT,solveL(GT',MMr*v(2:Nx,k))); 
        total(k+1) = cputime(); total(k)=total(k+1)-total(k); totalsum=totalsum+total(k);     
    end
     T='Temp. in Crank-Nicholson method (Cholesky decomposition)';
  case 'inv'
    % Matrix inversion
    M=inv(MMl)*MMr;
    for k=1:Nt % The time loop
        v(2:Nx,k+1)=M*v(2:Nx,k); 
        total(k+1) = cputime(); total(k)=total(k+1)-total(k); totalsum=totalsum+total(k);     
    end
    T='Temp. in Crank-Nicholson method (Matrix inversion)';
end 
plots(Nt, totalsum, v, x, t, T, total);
end