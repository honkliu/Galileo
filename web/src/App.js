import React from 'react';
import { BrowserRouter as Router, Route, Routes, Link } from 'react-router-dom';
import './App.css';
import Products from './Products'; // Rename the current App logic to Products
import Flights from './Flights';

function App() {
  return (
    <Router>
      <div className="app-container">
        <nav>
          <Link to="/">Products</Link>
          <Link to="/flights">Flights</Link>
        </nav>
        <Routes>
          <Route path="/" element={<Products />} />
          <Route path="/flights" element={<Flights />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;