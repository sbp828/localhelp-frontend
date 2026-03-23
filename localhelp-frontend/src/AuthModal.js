import React, { useState } from "react";

function AuthModal({ type, onClose }) {
  const [msg, setMsg] = useState("");

  const handleSubmit = () => {
    if (type === "signup") {
      setMsg("Verification email sent. Please verify to continue.");
    }

    if (type === "signin") {
      setMsg("Login request sent. Backend will verify credentials.");
    }

    if (type === "forgot") {
      setMsg("Reset code sent to email.");
    }
  };

  return (
    <div className="modal-bg">

      <div className="modal">

        <h2>
          {type === "signin" && "Sign In"}
          {type === "signup" && "Sign Up"}
          {type === "forgot" && "Forgot Password"}
        </h2>

        {type === "signup" && (
          <>
            <input placeholder="Name" />
            <input placeholder="Email" />
            <input type="password" placeholder="Password" />
          </>
        )}

        {type === "signin" && (
          <>
            <input placeholder="Email" />
            <input type="password" placeholder="Password" />
            <p className="link" onClick={() => setMsg("Switch to forgot password flow")}>
              Forgot Password?
            </p>
          </>
        )}

        {type === "forgot" && (
          <>
            <input placeholder="Email" />
            <input placeholder="Verification Code" />
          </>
        )}

        <button className="green-btn" onClick={handleSubmit}>
          Submit
        </button>

        <button className="red-btn" onClick={onClose}>
          Close
        </button>

        {msg && <p className="msg">{msg}</p>}

      </div>

    </div>
  );
}

export default AuthModal;
