import React, { useState, useEffect } from 'react';
import './App.css';

function Flights() {
  const [flights, setFlights] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const API_URL = "/api/flights";

  useEffect(() => {
    fetch(API_URL)
      .then(response => {
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        return response.json();
      })
      .then(data => {
        setFlights(data);
        setLoading(false);
      })
      .catch(error => {
        console.error("API Error:", error);
        setError(error.message);
        setLoading(false);
      });
  }, []);

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
        <p>Loading flights...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="error-container">
        <h2>⚠️ Error Loading Flights</h2>
        <p>{error}</p>
        <p>Please check your API connection and try again.</p>
      </div>
    );
  }

  return (
    <div className="container">
      <header>
        <h1>Flights</h1>
        <p className="subtitle">Dynamic data grid for flights</p>
      </header>

      <div className="flights-grid">
        <table>
          <thead>
            <tr>
              {flights.length > 0 &&
                Object.keys(flights[0]).map((col, index) => (
                  <th key={index}>{col}</th>
                ))}
            </tr>
          </thead>
          <tbody>
            {flights.map((flight, rowIndex) => (
              <tr key={rowIndex}>
                {Object.values(flight).map((value, colIndex) => (
                  <td key={colIndex}>{value}</td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      <footer>
        <p>Flights Data &copy; 2023 | Dynamic grid display</p>
      </footer>
    </div>
  );
}

export default Flights;