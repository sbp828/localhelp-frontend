import React from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import Home from "./Home";
import Help from "./Help";
import CartPage from "./CartPage";

function App() {
  return (
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/help" element={<Help />} />
      <Route path="/cart" element={<CartPage />} />

      {/* fallback */}
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  );
}

export default App;
