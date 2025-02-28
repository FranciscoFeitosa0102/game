import React, { useState } from "react";
import axios from "axios";

const Register = () => {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const response = await axios.post("http://localhost:5000/api/user/register", { email, password });
      if (response.data.success) {
        window.location.href = "/";
      } else {
        alert("Registration failed!");
      }
    } catch (error) {
      console.error("Registration error", error);
    }
  };

  return (
    <div className="flex justify-center items-center h-screen bg-gray-100">
      <form className="bg-white p-8 rounded-lg shadow-md" onSubmit={handleSubmit}>
        <h1 className="text-xl mb-4">Register</h1>
        <input
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          className="w-full mb-4 p-2 border"
        />
        <input
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          className="w-full mb-4 p-2 border"
        />
        <button type="submit" className="w-full bg-blue-500 text-white p-2">Register</button>
      </form>
    </div>
  );
};

export default Register;
