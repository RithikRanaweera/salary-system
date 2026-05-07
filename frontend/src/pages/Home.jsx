import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from '../components/ui/Button';

export const Home = () => {
  return (
    <div className="min-h-[calc(100vh-4rem)] flex flex-col justify-center items-center text-center px-4 max-w-4xl mx-auto space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
      <div className="space-y-4">
        <h1 className="text-5xl sm:text-6xl font-extrabold tracking-tight text-gray-900 leading-tight">
          Empowering tech through <span className="text-transparent bg-clip-text bg-gradient-to-r from-primary-500 to-indigo-600">transparency</span>
        </h1>
        <p className="text-lg sm:text-xl text-gray-500 max-w-2xl mx-auto">
          Make informed decisions about your career. View anonymous salaries, track market trends, and get paid what you're worth.
        </p>
        <h1>TESTING CICD</h1>
      </div>

      <div className="flex flex-col sm:flex-row gap-4 pt-4">
        <Link to="/search">
          <Button size="lg" className="w-full sm:w-auto shadow-xl shadow-primary-500/20">
            Explore Salaries
          </Button>
        </Link>
        <Link to="/submit">
          <Button variant="outline" size="lg" className="w-full sm:w-auto">
            Share Your Salary
          </Button>
        </Link>
      </div>
      
      <div className="pt-12 grid grid-cols-2 md:grid-cols-4 gap-8 opacity-60">
        {/* Placeholder logos or stats could go here */}
      </div>
    </div>
  );
};
