import React from 'react';
import { Routes, Route } from 'react-router-dom';
import { Navbar } from './components/Navbar';
import { Home } from './pages/Home';
import { Auth } from './pages/Auth';
import { SubmitSalary } from './pages/SubmitSalary';
import { Search } from './pages/Search';
import { Stats } from './pages/Stats';
import { AuthProvider } from './context/AuthContext';

function App() {
  return (
    <AuthProvider>
      <div className="flex flex-col min-h-screen">
        <Navbar />
        <main className="flex-1">
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/auth" element={<Auth />} />
            <Route path="/submit" element={<SubmitSalary />} />
            <Route path="/search" element={<Search />} />
            <Route path="/stats" element={<Stats />} />
          </Routes>
        </main>
      </div>
    </AuthProvider>
  );
}

export default App;
