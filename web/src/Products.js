// src/App.js
import React, { useState, useEffect } from 'react';
import './App.css';

function App() {
  const [products, setProducts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const API_URL = "/api/products";

  useEffect(() => {
    fetch(API_URL)
      .then(response => {
        if (!response.ok) throw new Error(`HTTP error! status: ${response.status}`);
        return response.json();
      })
      .then(data => {
        setProducts(data);
        setLoading(false);
      })
      .catch(error => {
        console.error("API Error:", error);
        setError(error.message);
        setLoading(false);
      });
  }, []);

  // Calculate summary values
  const totalProducts = products.length;
  const totalValue = products.reduce((sum, product) => sum + product.price, 0);
  const averagePrice = totalProducts > 0 ? totalValue / totalProducts : 0;

  if (loading) {
    return (
      <div className="loading-container">
        <div className="spinner"></div>
        <p>Loading products...</p>
      </div>
    );
  }

  if (error) {
    return (
      <div className="error-container">
        <h2>⚠️ Error Loading Products</h2>
        <p>{error}</p>
        <p>Please check your API connection and try again.</p>
      </div>
    );
  }

  return (
    <div className="container">
      <header>
        <h1>Product Catalog</h1>
        <p className="subtitle">Simple and clean product grid display</p>
      </header>
      
      <div className="product-grid">
        {/* Grid Header */}
        <div className="grid-header">
          <div className="grid-cell">ID</div>
          <div className="grid-cell">Product Name</div>
          <div className="grid-cell">Price</div>
        </div>
        
        {/* Product Rows */}
        {products.map(product => (
          <div key={product.id} className="product-row">
            <div className="grid-cell product-id">{product.id}</div>
            <div className="grid-cell product-name">{product.name}</div>
            <div className="grid-cell product-price">${product.price.toFixed(2)}</div>
          </div>
        ))}
      </div>
      
      <div className="summary">
        <div className="summary-item">
          <div className="summary-value">{totalProducts}</div>
          <div className="summary-label">Total Products</div>
        </div>
        <div className="summary-item">
          <div className="summary-value">${totalValue.toFixed(2)}</div>
          <div className="summary-label">Total Value</div>
        </div>
        <div className="summary-item">
          <div className="summary-value">${averagePrice.toFixed(2)}</div>
          <div className="summary-label">Average Price</div>
        </div>
      </div>
      
      <footer>
        <p>Product Catalog &copy; 2023 | Simple and efficient grid display</p>
      </footer>
    </div>
  );
}

export default App;