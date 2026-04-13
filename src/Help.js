import React, { useEffect, useState } from "react";
import { useCart } from "./CartContext";
import { useNavigate } from "react-router-dom";

function Help() {
  const { cartItems, addToCart, increaseQty, decreaseQty } = useCart();
  const navigate = useNavigate();

  const [selectedService, setSelectedService] = useState("Medicines");
  const [medicines, setMedicines] = useState([]); // 🔥 FROM BACKEND

  // ✅ FETCH FROM BACKEND
  useEffect(() => {
    fetch("/api/medicines")
      .then((res) => res.json())
      .then((data) => setMedicines(data))
      .catch((err) => console.error(err));
  }, []);

  const totalItems = cartItems.reduce((s, i) => s + i.quantity, 0);

  const services = [
    "Medicines",
    "Food",
    "Transport",
    "Home Services",
    "Emergency"
  ];

  return (
    <div className="help-container">

      {/* HEADER */}
      <div className="help-header">
        <h2>Services</h2>

        <div className="cart-icon" onClick={() => navigate("/cart")}>
          🛒
          {totalItems > 0 && <span className="badge">{totalItems}</span>}
        </div>
      </div>

      {/* SERVICES ROW */}
      <div className="services-row">
        {services.map((s) => (
          <div
            key={s}
            className={`service-box ${selectedService === s ? "active" : ""}`}
            onClick={() => setSelectedService(s)}
          >
            {s}
          </div>
        ))}
      </div>

      {/* OTHER SERVICES */}
      {selectedService !== "Medicines" && (
        <div className="maintenance-msg">
          🚧 {selectedService} service is under development
        </div>
      )}

      {/* MEDICINES */}
      {selectedService === "Medicines" && (
        <div className="medicine-vertical">

          {medicines.map((med) => {
            const item = cartItems.find((i) => i.id === med.id);
            const qty = item ? item.quantity : 0;

            return (
              <div key={med.id} className="medicine-card">

                {/* LEFT INFO */}
                <div>
                  <h4>{med.name}</h4>
                  <small>{med.description}</small> {/* ✅ NEW */}
                  <p>₹{med.price}</p>
                  <small>Stock: {med.stock}</small> {/* ✅ LIVE STOCK */}
                </div>

                {/* RIGHT ACTION */}
                <div className="med-actions">
                  {qty === 0 ? (
                    <button
                      className="add-btn"
                      onClick={() =>
                        addToCart({
                          id: med.id,
                          name: med.name
                        })
                      }
                    >
                      Add
                    </button>
                  ) : (
                    <div className="qty-controls">
                      <button onClick={() => decreaseQty(med.id)}>-</button>
                      <span>{qty}</span>
                      <button
                        onClick={() => increaseQty(med.id)}
                        disabled={qty >= 5}
                      >
                        +
                      </button>
                    </div>
                  )}
                </div>

              </div>
            );
          })}

        </div>
      )}
    </div>
  );
}

export default Help;
