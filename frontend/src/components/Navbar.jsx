import React, { useContext } from 'react';
import { Link, useLocation } from 'react-router-dom';
import { AuthContext } from '../context/AuthContext';
import { Button } from './ui/Button';
import { cn } from '../utils/cn';
import { BarChart3 } from 'lucide-react';

export const Navbar = () => {
  const { user, logout } = useContext(AuthContext);
  const location = useLocation();

  const links = [
    { name: 'Home', path: '/' },
    { name: 'Search', path: '/search' },
    { name: 'Submit Salary', path: '/submit' },
    { name: 'Stats', path: '/stats' },
  ];

  return (
    <nav className="sticky top-0 z-50 border-b border-gray-100 bg-white/80 backdrop-blur-lg">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between h-16 items-center">
          <div className="flex items-center gap-2">
            <Link to="/" className="flex items-center gap-2 group">
              <div className="bg-primary-50 p-2 rounded-xl group-hover:bg-primary-100 transition-colors">
                <BarChart3 className="w-6 h-6 text-primary-600" />
              </div>
              <span className="font-bold text-xl tracking-tight text-gray-900">TechSalary</span>
            </Link>
          </div>
          
          <div className="hidden md:flex items-center space-x-1">
            {links.map((link) => (
              <Link
                key={link.name}
                to={link.path}
                className={cn(
                  "px-4 py-2 rounded-lg text-sm font-medium transition-colors",
                  location.pathname === link.path 
                    ? "bg-primary-50 text-primary-700"
                    : "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                )}
              >
                {link.name}
              </Link>
            ))}
          </div>

          <div className="flex items-center space-x-4">
            {user ? (
              <div className="flex items-center gap-4">
                <span className="text-sm text-gray-500 hidden sm:block">{user.email}</span>
                <Button variant="outline" size="sm" onClick={logout}>
                  Logout
                </Button>
                 <Button variant="outline" size="sm" onClick={logout}>
                  DIWANGA
                </Button>
              </div>
            ) : (
              <Link to="/auth">
                <Button size="sm">Login</Button>
              </Link>
            )}
          </div>
        </div>
      </div>
    </nav>
  );
};
