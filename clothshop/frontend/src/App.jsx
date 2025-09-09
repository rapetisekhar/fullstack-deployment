import React, { useEffect, useState } from "react";

const API = process.env.REACT_APP_API || "http://localhost:4000";

export default function App() {
  const [products, setProducts] = useState([]);
  const [form, setForm] = useState({ name: "", price: 0, size: "", color: "", stock: 0 });

  useEffect(()=> fetchProducts(), []);

  async function fetchProducts(){
    const res = await fetch(`${API}/api/products`);
    const data = await res.json();
    setProducts(data);
  }
  async function addProduct(e){
    e.preventDefault();
    await fetch(`${API}/api/products`, {
      method: "POST",
      headers: {"Content-Type":"application/json"},
      body: JSON.stringify(form)
    });
    setForm({ name: "", price: 0, size: "", color: "", stock: 0 });
    fetchProducts();
  }

  return (
    <div style={{ maxWidth:800, margin:"20px auto", fontFamily:"Arial" }}>
      <h1>Vihaan's Vastralay</h1>
      <form onSubmit={addProduct} style={{ marginBottom:20 }}>
        <input required placeholder="Name" value={form.name} onChange={e=>setForm({...form,name:e.target.value})} />
        <input type="number" placeholder="Price" value={form.price} onChange={e=>setForm({...form,price:Number(e.target.value)})} />
        <input placeholder="Size" value={form.size} onChange={e=>setForm({...form,size:e.target.value})} />
        <input placeholder="Color" value={form.color} onChange={e=>setForm({...form,color:e.target.value})} />
        <input type="number" placeholder="Stock" value={form.stock} onChange={e=>setForm({...form,stock:Number(e.target.value)})} />
        <button type="submit">Add</button>
      </form>

      <h2>Products</h2>
      <ul>
        {products.map(p => (
          <li key={p._id}>
            <strong>{p.name}</strong> — ₹{p.price} — {p.size} — {p.color} — stock: {p.stock}
          </li>
        ))}
      </ul>
    </div>
  );
}

