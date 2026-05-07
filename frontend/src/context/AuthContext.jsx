import React, { createContext, useState, useEffect } from 'react';
import api from '../services/api';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    // Check if user has token and is still valid
    const checkAuth = async () => {
      const token = localStorage.getItem('token');
      if (token) {
        // Ideally we verify with BFF, but for now we just parse or set a dummy user
        try {
          // const res = await api.get('/auth/me'); 
          // setUser(res.data);
          
          // Dummy logic since backend doesn't exist
          setUser({ email: 'user@example.com' });
        } catch (error) {
          localStorage.removeItem('token');
          setUser(null);
        }
      }
      setLoading(false);
    };
    checkAuth();
  }, []);

  const login = async (email, password) => {
    const response = await api.post('/login', { email, password });
    localStorage.setItem('token', response.data.token);
    setUser({ id: response.data.userId, email });
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading }}>
      {!loading && children}
    </AuthContext.Provider>
  );
};
