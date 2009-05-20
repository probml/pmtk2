classdef MarkovModel < ChainModel
%MARKOVMODEL


	properties

		dof;
		ndimensions;
		params;
		prior;

	end


	methods

		function model = MarkovModel(varargin)
		%
		end


		function fit(model,varargin)
		%
			notYetImplemented('MarkovModel.fit()');
		end


		function logPdf(model,varargin)
		%
			notYetImplemented('MarkovModel.logpdf()');
		end


		function sample(model,varargin)
		%
			notYetImplemented('MarkovModel.sample()');
		end


	end


end

