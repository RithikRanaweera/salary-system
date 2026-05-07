import React, { useState, useEffect } from 'react';
import { Search as SearchIcon, Filter } from 'lucide-react';
import { Input } from '../components/ui/Input';
import { Button } from '../components/ui/Button';
import { SalaryCard } from '../components/SalaryCard';
import api from '../services/api';

export const Search = () => {
  const [salaries, setSalaries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({ query: '', company: '', role: '', experience: '' });
  const [showFilters, setShowFilters] = useState(false);

  // const fetchSalaries = async () => {
  //   setLoading(true);
  //   try {
  //     const params = {};
  //     if (filters.company) params.company = filters.company;
  //     if (filters.role) params.role = filters.role;
  //     if (filters.experience) params.experience = filters.experience;
  //     if (filters.query) params.q = filters.query;
  //     const { data } = await api.get('/search', { params });
  //     setSalaries(data.results || []);
  //   } catch (err) {
  //     console.error('Search failed:', err);
  //     setSalaries([]);
  //   }
  //   setLoading(false);
  // };

  const fetchSalaries = async () => {
    setLoading(true);
    try {
        const params = {};
        if (filters.company) params.company = filters.company;
        if (filters.role) params.role = filters.role;
        if (filters.experience) params.experience = filters.experience;
        if (filters.query) params.q = filters.query;
        
        const { data } = await api.get('/search', { params });
        const results = data.results || [];

        // Fetch vote counts for each salary
        const withVotes = await Promise.all(
            results.map(async (salary) => {
                try {
                    const { data: voteData } = await api.get(
                        `/votes/${salary.id}/count`
                    );
                    return { ...salary, votes: voteData.upvotes || 0 };
                } catch {
                    return { ...salary, votes: 0 };
                }
            })
        );

        setSalaries(withVotes);
    } catch (err) {
        console.error('Search failed:', err);
        setSalaries([]);
    }
    setLoading(false);
};

  useEffect(() => {
    fetchSalaries();
  }, []);

  useEffect(() => {
    const timer = setTimeout(() => {
      fetchSalaries();
    }, 400);
    return () => clearTimeout(timer);
  }, [filters.query, filters.company, filters.role, filters.experience]);

  return (
    <div className="max-w-5xl mx-auto py-8 px-4 sm:px-6">
      <div className="mb-8 space-y-4">
        <h1 className="text-3xl font-bold text-gray-900 tracking-tight">Search Salaries</h1>
        <p className="text-gray-500">Find compensation data by company or role to know your worth.</p>
        
        <div className="flex gap-2">
          <div className="relative flex-1">
            <SearchIcon className="absolute left-3 top-3 w-5 h-5 text-gray-400" />
            <Input 
              placeholder="Search companies, roles..." 
              className="pl-10 h-12 text-base shadow-sm"
              value={filters.query}
              onChange={(e) => setFilters({ ...filters, query: e.target.value })}
            />
          </div>
          <Button variant="outline" className="h-12 px-4 shadow-sm group" onClick={() => setShowFilters(!showFilters)}>
            <Filter className="w-5 h-5 text-gray-500 group-hover:text-gray-900" />
            <span className="hidden sm:inline ml-2">Filters</span>
          </Button>
        </div>

        {showFilters && (
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 p-4 bg-white rounded-xl border border-gray-200 shadow-sm animate-in fade-in slide-in-from-top-2 duration-200">
            <div>
              <label className="block text-xs font-medium text-gray-500 uppercase tracking-wider mb-1">Company</label>
              <Input placeholder="Any company" />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 uppercase tracking-wider mb-1">Role</label>
              <Input placeholder="Any role" />
            </div>
            <div>
              <label className="block text-xs font-medium text-gray-500 uppercase tracking-wider mb-1">Experience (Years)</label>
              <Input type="number" placeholder="Any" />
            </div>
          </div>
        )}
      </div>

      <div className="space-y-4">
        {loading ? (
          <div className="py-12 text-center text-gray-500">Loading results...</div>
        ) : salaries.length > 0 ? (
          salaries.map(salary => (
            <SalaryCard 
    key={salary.id} 
    data={salary}
    onVote={(id, vote) => console.log('Voted', id, vote)}
/>
          ))
        ) : (
          <div className="py-12 text-center bg-gray-50 rounded-xl border border-gray-100 border-dashed">
            <h3 className="text-lg font-medium text-gray-900 mb-1">No results found</h3>
            <p className="text-gray-500 mb-4">Try adjusting your filters or search query.</p>
            <Button variant="outline" onClick={() => setFilters({ query: '', company: '', role: '', experience: '' })}>
              Clear all filters
            </Button>
          </div>
        )}
      </div>
    </div>
  );
};
