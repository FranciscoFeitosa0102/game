
import { useState } from 'react';

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(false);

  return (
    <div className="App">
      <h1 className="text-4xl text-center">Bem-vindo ao Jogo</h1>
      {isLoggedIn ? (
        <div>Iniciar Jogo</div>
      ) : (
        <div>Login necessário</div>
      )}
    </div>
  );
}

export default App;
    