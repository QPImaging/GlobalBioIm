classdef Func < handle
    %% Func : Functional generic class
    %  Matlab Inverse Problems Library
    %  The Func meta class implements generic methods for all functionals
    %
    % -- Properties
    % * |name|       - name of the function  
    % * |sizein|     - size of input space (kernel)
    % * |H|          - LinOp composed with the functional
    % * |lip|        - Lipschitz constant of the gradient (if known, otherwise -1)
    % * |isconvex|   - boolean true is the function is convex
    %
    % -- Methods
    % * |eval|       - evaluates the functional 
    % * |grad|       - evaluates the gradient of the functional 
    % * |o|          - compose with a LinOp
    % * |prox|       - computes the proximity operator
    % * |prox_fench| - computes the proximity operator of the fenchel transform
    %                  (default for convex Func: uses the Moreau's identity 
    %                       prox_{alpha F*}(y) = y - alpha prox_{F/alpha}(y/alpha)
    %
    %     Copyright (C) 2017 E. Soubies emmanuel.soubies@epfl.ch
    %
    %     This program is free software: you can redistribute it and/or modify
    %     it under the terms of the GNU General Public License as published by
    %     the Free Software Foundation, either version 3 of the License, or
    %     (at your option) any later version.
    %
    %     This program is distributed in the hope that it will be useful,
    %     but WITHOUT ANY WARRANTY; without even the implied warranty of
    %     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    %     GNU General Public License for more details.
    %
    %     You should have received a copy of the GNU General Public License
    %     along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
    % Protected Set and public Read properties    
    properties (SetAccess = protected,GetAccess = public)
        name = 'none'       % name of the functional
        sizein;             % dimensions of the input vector space
        lip=-1;             % Lipschitz constant of the gradient
        % LinOp Infos
        H=LinOpIdentity();  % linear operator
        isconvex=false;
    end

    methods
    	%% Evaluation of the Functional
        function eval(~,~) 
            error('Eval not implemented');
        end
        %% Gradient of the Functional
        function grad(~,~) 
            error('Prox not implemented');
        end
        %% Proximity operator of the functional
        function prox(~,~,~) 
            error('Prox not implemented');
        end
        %% Proximity operator of the Fenchel transform of the functional prox_{alpha F*}
        function y=prox_fench(this,x,alpha) 
        	assert(isscalar(alpha),'alpha must be a scalar'); 
        	if this.isconvex
            	y= x - alpha*this.prox(x/alpha,1/alpha);
            else
            	error('Prox Fenchel not implemented');
            end
        end
        %% Operator compose with a LinOp
        function v=	o(this,x)
        	assert(isa(x,'LinOp'),' Composition of Func(.o) is only define with a LinOp');
        	v=ComposeLinOpFunc(this,x);
        end
        %% Overload the operator +
        function y = plus(this,x)
            assert(isa(x,'Func'),'Addition of Func is only define with other Func');
            y = SumFunc({this,x});
		end
		%% Overload the operator -
        function y = minus(this,x)
            assert(isa(x,'Func'),'Subtraction of Func is only define with other Func');
            y = SumFunc({this,x},[1,-1]);
		end
		%% Function that set properly the operator H (has to be modified if new properties is???H are added)
        function set_H(this,H)
        	this.H=H;
        	this.sizein=this.H.sizein;
        end
    end
end