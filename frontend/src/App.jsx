
import React, { useState, useEffect } from 'react';
import axios from 'axios';
import { BrowserRouter as Router, Route, Switch, Link } from 'react-router-dom';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import GamePage from './pages/GamePage';
import SalesPage from './pages/SalesPage';
import RankingPage from './pages/RankingPage';

function App() {
  const [user, setUser] = useState(null);

  const handleLogin = (userData) => {
    setUser(userData);
  };

  useEffect(() => {
    // Get user data from the session or local storage
    const loggedUser = JSON.parse(localStorage.getItem('user'));
    if (loggedUser) {
      setUser(loggedUser);
    }
  }, []);

  return (
    <Router>
      <div className="App">
        <nav className="bg-gray-800 p-4">
          <ul className="flex space-x-4 text-white">
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              {user ? (
                <Link to="/game">Jogo</Link>
              ) : (
                <Link to="/login">Login</Link>
              )}
            </li>
            <li>
              {user ? (
                <Link to="/sales">Registrar Vendas</Link>
              ) : (
                <Link to="/register">Cadastrar</Link>
              )}
            </li>
            <li>
              <Link to="/ranking">Ranking</Link>
            </li>
          </ul>
        </nav>
        <Switch>
          <Route path="/login" render={() => <LoginPage onLogin={handleLogin} />} />
          <Route path="/register" component={RegisterPage} />
          <Route path="/game" render={() => <GamePage user={user} />} />
          <Route path="/sales" render={() => <SalesPage user={user} />} />
          <Route path="/ranking" component={RankingPage} />
          <Route path="/" exact>
            <h1>Bem-vindo ao Jogo</h1>
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
